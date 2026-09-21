import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/focus_session/domain/streak_calculator.dart';
import 'package:homeo/l10n/l10n.dart';

/// Current streak next to best streak. Tone is deliberately gentle: a zero
/// streak reads "start a new streak today", never "you lost it".
class StreakCard extends StatelessWidget {
  const StreakCard({required this.streak, super.key});

  final StreakResult streak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 22,
              color: colors.accentText,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak.current > 0
                      ? l10n.streakDays(streak.current)
                      : l10n.streakNone,
                  style: text.titleSmall,
                ),
                if (streak.best > 0)
                  Text(
                    l10n.streakBest(streak.best),
                    style: text.bodySmall?.copyWith(color: colors.inkMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
