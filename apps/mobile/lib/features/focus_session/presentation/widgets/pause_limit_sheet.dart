import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/l10n/l10n.dart';

/// Shown when the daily pause budget is spent (PRD §9.1). Supportive tone,
/// one clear action.
Future<void> showPauseLimitSheet(
  BuildContext context, {
  required int used,
  required int total,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => _PauseLimitSheet(used: used, total: total),
  );
}

class _PauseLimitSheet extends StatelessWidget {
  const _PauseLimitSheet({required this.used, required this.total});

  final int used;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

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
            ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < total; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: i < used ? colors.accent : colors.border,
                          borderRadius: AppRadius.pillRadius,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.pauseLimitTitle(used, total), style: text.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.pauseLimitBody,
              style: text.bodyMedium?.copyWith(color: colors.inkMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonBackToFocus),
            ),
          ],
        ),
      ),
    );
  }
}
