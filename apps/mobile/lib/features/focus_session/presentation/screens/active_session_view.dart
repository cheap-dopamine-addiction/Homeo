import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';

/// Shown when state is [FocusRunning].
///
/// Displays the countdown timer, pause/resume controls, and an early-end
/// option.
class ActiveSessionView extends ConsumerWidget {
  const ActiveSessionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(focusSessionControllerProvider) as FocusRunning;
    final notifier = ref.read(focusSessionControllerProvider.notifier);
    final theme = Theme.of(context);

    final remaining = state.remaining;
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Task label
          if (state.session.taskLabel != null) ...[
            Text(
              state.session.taskLabel!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],

          // Progress ring + timer
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: state.progress,
                    strokeWidth: 10,
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.15),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$minutes:$seconds',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        state.isPaused ? 'Paused' : 'Focusing',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // End early
              OutlinedButton.icon(
                onPressed: () => _confirmEnd(context, notifier),
                icon: const Icon(Icons.stop_rounded),
                label: const Text('End'),
              ),
              // Pause / Resume
              FilledButton.icon(
                onPressed: notifier.togglePause,
                icon: Icon(state.isPaused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded),
                label: Text(state.isPaused ? 'Resume' : 'Pause'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmEnd(
      BuildContext context, FocusSessionController notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End session?'),
        content: const Text(
          'Your progress will be saved. Do you want to end this session now?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('End')),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.endSessionEarly(reason: ExitReason.userEnded);
    }
  }
}
