import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';
import 'package:homeo/features/friction/presentation/providers/emergency_controller.dart';
import 'package:homeo/features/friction/presentation/providers/friction_providers.dart';
import 'package:homeo/l10n/l10n.dart';

/// Emergency unblock (PRD §9.7). Reachable from the gate, from an active
/// session, and by long-pressing the tab bar (PRD §14).
Future<void> showEmergencySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => const _EmergencySheet(),
  );
}

class _EmergencySheet extends ConsumerStatefulWidget {
  const _EmergencySheet();

  @override
  ConsumerState<_EmergencySheet> createState() => _EmergencySheetState();
}

class _EmergencySheetState extends ConsumerState<_EmergencySheet> {
  bool _busy = false;
  bool _limitReached = false;

  Future<void> _confirm() async {
    if (_busy) return;
    setState(() => _busy = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;

    final outcome = await ref
        .read(emergencyControllerProvider.notifier)
        .activate();
    if (!mounted) return;

    switch (outcome) {
      case EmergencyOutcome.granted:
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.emergencyDone(FrictionRules.emergencyWindow.inMinutes),
            ),
          ),
        );
      case EmergencyOutcome.limitReached:
        setState(() {
          _busy = false;
          _limitReached = true;
        });
      case EmergencyOutcome.ignored:
        setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final quota = ref.watch(emergencyQuotaProvider);
    final exhausted = _limitReached || quota.exhausted;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (exhausted) ...[
              Text(l10n.emergencyExhaustedTitle, style: text.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              // Real emergencies must never dead-end at a quota screen.
              Text(
                l10n.emergencyExhaustedBody,
                style: text.bodyMedium?.copyWith(color: colors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.setupClose),
              ),
            ] else ...[
              Text(l10n.emergencyTitle, style: text.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: AppRadius.cardRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.emergencyUsage(quota.used, quota.limit),
                      style: text.labelMedium?.copyWith(color: colors.inkMuted),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ExcludeSemantics(
                      child: Row(
                        children: [
                          for (var i = 0; i < quota.limit; i++)
                            Container(
                              width: 28,
                              height: 5,
                              margin: const EdgeInsetsDirectional.only(end: 6),
                              decoration: BoxDecoration(
                                color: i < quota.used
                                    ? colors.accent
                                    : colors.border,
                                borderRadius: AppRadius.pillRadius,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.emergencyBody(FrictionRules.emergencyWindow.inMinutes),
                style: text.bodyMedium?.copyWith(color: colors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _busy ? null : _confirm,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.danger,
                  foregroundColor: colors.onDanger,
                ),
                child: Text(l10n.emergencyConfirm),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.pickerCancel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
