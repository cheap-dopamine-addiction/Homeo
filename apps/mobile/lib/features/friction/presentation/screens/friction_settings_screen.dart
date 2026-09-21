import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/data/partner_gateway.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/presentation/friction_level_l10n.dart';
import 'package:homeo/features/friction/presentation/providers/friction_gate_controller.dart';
import 'package:homeo/features/friction/presentation/providers/friction_providers.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:homeo/features/settings/domain/user_settings.dart';
import 'package:homeo/l10n/l10n.dart';

/// Friction level, watched apps and emergency quota (PRD §8 "Interventions").
/// Every restriction is adjustable here — PRD §11.4 "autonomy".
class FrictionSettingsScreen extends ConsumerWidget {
  const FrictionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    final settings =
        ref.watch(userSettingsProvider).value ?? UserSettings.defaults;
    final blocked =
        ref.watch(blockedAppsProvider).value ?? const <BlockedApp>[];
    final quota = ref.watch(emergencyQuotaProvider);
    final hasPartner = ref.watch(partnerGatewayProvider).hasPartner;
    final repo = ref.read(frictionRepositoryProvider);

    BlockedApp? blockedFor(String id) {
      for (final app in blocked) {
        if (app.appPackageId == id) return app;
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.frictionScreenTitle),
        backgroundColor: colors.canvas,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Text(l10n.frictionDefaultSection, style: text.titleSmall),
          const SizedBox(height: AppSpacing.md),
          for (final level in FrictionLevel.values) ...[
            _LevelTile(
              level: level,
              selected: settings.defaultFrictionLevel == level,
              enabled: level != FrictionLevel.partnerGated || hasPartner,
              onTap: () => ref
                  .read(settingsRepositoryProvider)
                  .save(settings.copyWith(defaultFrictionLevel: level)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.frictionAppsSection, style: text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.frictionAppsHint,
            style: text.bodySmall?.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final app in AppCatalog.apps)
            _AppRow(
              app: app,
              blocked: blockedFor(app.packageId),
              hasPartner: hasPartner,
              onToggle: (on) => on
                  ? repo.setBlockedApp(
                      BlockedApp(
                        appPackageId: app.packageId,
                        level: settings.defaultFrictionLevel,
                      ),
                    )
                  : repo.removeBlockedApp(app.packageId),
              onLevel: (level) => repo.setBlockedApp(
                BlockedApp(appPackageId: app.packageId, level: level),
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.frictionEmergencySection, style: text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.emergencyUsage(quota.used, quota.limit),
            style: text.bodyMedium?.copyWith(color: colors.inkMuted),
          ),
          if (kDebugMode && blocked.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.frictionDebugSection, style: text.titleSmall),
            const SizedBox(height: AppSpacing.md),
            for (final app in blocked) ...[
              OutlinedButton(
                onPressed: () => ref
                    .read(frictionGateControllerProvider.notifier)
                    .onAttempt(app.appPackageId),
                child: Text(
                  l10n.frictionDebugSimulate(
                    AppCatalog.nameOf(app.appPackageId),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ],
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.level,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final FrictionLevel level;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Material(
        color: selected ? colors.primarySoft : colors.surface,
        borderRadius: AppRadius.cardRadius,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.cardRadius,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardRadius,
              border: Border.all(
                color: selected ? colors.primary : colors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Opacity(
              opacity: enabled ? 1 : 0.6,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(level.label(l10n), style: text.titleSmall),
                        Text(
                          enabled
                              ? level.description(l10n)
                              : l10n.frictionL4Locked,
                          style: text.bodySmall?.copyWith(
                            color: colors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected)
                    Icon(Icons.check_circle_rounded, color: colors.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({
    required this.app,
    required this.blocked,
    required this.hasPartner,
    required this.onToggle,
    required this.onLevel,
  });

  final CatalogApp app;
  final BlockedApp? blocked;
  final bool hasPartner;
  final ValueChanged<bool> onToggle;
  final ValueChanged<FrictionLevel> onLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = blocked;

    // A stored L4 must stay representable even if the partner is gone.
    final levels = [
      for (final level in FrictionLevel.values)
        if (level != FrictionLevel.partnerGated ||
            hasPartner ||
            current?.level == FrictionLevel.partnerGated)
          level,
    ];

    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(app.icon),
          title: Text(app.displayName),
          value: current != null,
          onChanged: onToggle,
        ),
        if (current != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: DropdownButton<FrictionLevel>(
              isExpanded: true,
              value: current.level,
              items: [
                for (final level in levels)
                  DropdownMenuItem(
                    value: level,
                    child: Text(level.label(l10n)),
                  ),
              ],
              onChanged: (level) {
                if (level != null) onLevel(level);
              },
            ),
          ),
      ],
    );
  }
}
