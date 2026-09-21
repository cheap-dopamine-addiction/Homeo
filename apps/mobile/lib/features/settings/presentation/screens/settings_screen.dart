import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/app/router/app_routes.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Text(l10n.settingsTitle, style: text.headlineMedium),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              leading: Icon(Icons.tune_rounded, color: colors.primary),
              title: Text(l10n.settingsFrictionTile),
              subtitle: Text(l10n.settingsFrictionTileSubtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.frictionSettings),
            ),
          ),
        ],
      ),
    );
  }
}
