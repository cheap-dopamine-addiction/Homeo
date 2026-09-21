import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/focus_session/data/focus_session_repository.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:homeo/features/focus_session/domain/streak_calculator.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/choice_pill.dart';

/// Shown once after a streak ends (PRD §7.3 / §13.7). No blame: the best
/// streak is restated as still theirs, the reason is optional, and there is
/// a way out that does not require starting anything.
class StreakRecoveryView extends ConsumerStatefulWidget {
  const StreakRecoveryView({required this.streakBreak, super.key});

  final StreakBreak streakBreak;

  @override
  ConsumerState<StreakRecoveryView> createState() => _StreakRecoveryViewState();
}

class _StreakRecoveryViewState extends ConsumerState<StreakRecoveryView> {
  StreakBreakReason? _reason;
  bool _busy = false;

  Future<void> _acknowledge({required bool restart}) async {
    if (_busy) return;
    setState(() => _busy = true);

    // Grab everything first: acknowledging removes this view, and `ref`
    // cannot be used once it is gone.
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final sessionRepo = ref.read(focusSessionRepositoryProvider);
    final controller = ref.read(focusSessionControllerProvider.notifier);
    final reason = _reason;
    final endedOn = widget.streakBreak.endedOn;

    try {
      if (reason != null) {
        await sessionRepo.saveReflection(
          promptKey: ReflectionPromptKeys.streakBreakReason,
          responseText: reason.name,
        );
      }
      final settings = await settingsRepo.load();
      await settingsRepo.save(
        settings.copyWith(streakBreakAckedRunEnd: endedOn),
      );

      if (restart) controller.openSetup();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final best = ref.watch(focusStatsProvider).streak.best;

    String label(StreakBreakReason reason) => switch (reason) {
      StreakBreakReason.tired => l10n.recoveryReasonTired,
      StreakBreakReason.emergency => l10n.recoveryReasonEmergency,
      StreakBreakReason.motivation => l10n.recoveryReasonMotivation,
      StreakBreakReason.other => l10n.exitReasonOther,
    };

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: colors.accentSoft,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      size: 44,
                      color: colors.accentText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.recoveryTitle(widget.streakBreak.length),
                    style: text.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.recoveryBody,
                    style: text.bodyLarge?.copyWith(color: colors.inkMuted),
                    textAlign: TextAlign.center,
                  ),
                  if (best > 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.recoveryBest(best),
                      style: text.bodySmall?.copyWith(color: colors.inkMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(l10n.recoveryQuestion, style: text.titleSmall),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final reason in StreakBreakReason.values)
                          ChoicePill(
                            label: label(reason),
                            selected: _reason == reason,
                            onSelected: () => setState(
                              () => _reason = _reason == reason ? null : reason,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: _busy ? null : () => _acknowledge(restart: true),
                  child: Text(l10n.recoveryRestart),
                ),
                TextButton(
                  onPressed: _busy ? null : () => _acknowledge(restart: false),
                  style: TextButton.styleFrom(foregroundColor: colors.inkMuted),
                  child: Text(l10n.recoveryLater),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
