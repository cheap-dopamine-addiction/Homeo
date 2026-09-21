import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/core/theme/app_theme.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/widgets/exit_gate_sheet.dart';
import 'package:homeo/features/focus_session/presentation/widgets/pause_limit_sheet.dart';
import 'package:homeo/features/focus_session/presentation/widgets/timer_ring.dart';
import 'package:homeo/features/friction/presentation/widgets/emergency_override_sheet.dart';
import 'package:homeo/l10n/l10n.dart';

/// Focus tab, running/paused phase. Always dark (calm, low-stimulus),
/// regardless of the app theme.
class ActiveSessionView extends ConsumerWidget {
  const ActiveSessionView({super.key});

  Future<void> _requestExit(BuildContext context, WidgetRef ref) async {
    final result = await showExitGateSheet(context);
    if (result == null || !result.leave) return; // dismissed = stay
    await ref
        .read(focusSessionControllerProvider.notifier)
        .abort(reason: result.reason);
  }

  void _togglePause(BuildContext context, WidgetRef ref, FocusRunning run) {
    final controller = ref.read(focusSessionControllerProvider.notifier);
    if (run.isPaused) {
      controller.resume();
      return;
    }
    if (controller.pause() == PauseOutcome.limitReached) {
      showPauseLimitSheet(
        context,
        used: run.pausesUsedToday,
        total: FocusRules.maxPausesPerDay,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.watch(focusSessionControllerProvider);
    if (run is! FocusRunning) return const SizedBox.shrink();

    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) {
          final l10n = context.l10n;
          final colors = AppColors.of(context);
          final text = Theme.of(context).textTheme;

          final status = run.isPaused
              ? l10n.activeStatusPaused
              : l10n.activeStatusFocusing;
          final time = formatClock(Duration(seconds: run.remainingSeconds));
          final intention = run.session.intention;

          return PopScope(
            canPop: false, // Android back → exit gate, never a silent exit
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _requestExit(context, ref);
            },
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              // Light status-bar icons: this screen is dark in both themes.
              value: SystemUiOverlayStyle.light,
              child: ColoredBox(
                color: colors.focusCanvas,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () => _requestExit(context, ref),
                            style: TextButton.styleFrom(
                              foregroundColor: colors.inkMuted,
                            ),
                            child: Text(l10n.activeExit),
                          ),
                        ),
                        if (intention.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: colors.focusSurface,
                              borderRadius: AppRadius.cardRadius,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.activeGoalLabel,
                                  style: text.labelSmall?.copyWith(
                                    color: colors.inkMuted,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  intention,
                                  style: text.bodyLarge,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) => TimerRing(
                                size: math.min(
                                  256.0,
                                  math.min(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                ),
                                progress: run.progress,
                                timeLabel: time,
                                statusLabel: status,
                                semanticsLabel: l10n.activeTimerSemantics(
                                  status,
                                  time,
                                ),
                                isPaused: run.isPaused,
                              ),
                            ),
                          ),
                        ),
                        _PauseBudget(
                          used: run.pausesUsedToday,
                          total: FocusRules.maxPausesPerDay,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          onPressed: () => _togglePause(context, ref, run),
                          child: Text(
                            run.isPaused ? l10n.activeResume : l10n.activePause,
                          ),
                        ),
                        TextButton(
                          onPressed: () => showEmergencySheet(context),
                          style: TextButton.styleFrom(
                            foregroundColor: colors.inkMuted,
                          ),
                          child: Text(l10n.emergencyLink),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PauseBudget extends StatelessWidget {
  const _PauseBudget({required this.used, required this.total});

  final int used;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < total; i++)
                Container(
                  width: 28,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i < used ? colors.accent : colors.focusSurface,
                    borderRadius: AppRadius.pillRadius,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.activePausesUsed(used, total),
          style: text.bodySmall?.copyWith(color: colors.inkMuted),
        ),
      ],
    );
  }
}
