import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';

/// Shown when state is [FocusSummary].
///
/// Displays session stats and collects a quick end-of-session reflection.
class SessionSummaryView extends ConsumerStatefulWidget {
  const SessionSummaryView({super.key});

  @override
  ConsumerState<SessionSummaryView> createState() => _SessionSummaryViewState();
}

class _SessionSummaryViewState extends ConsumerState<SessionSummaryView> {
  final _answerController = TextEditingController();
  int _currentPromptIndex = 0;

  static const _prompts = ReflectionPromptKeys.all;

  String get _currentPromptKey => _prompts[_currentPromptIndex];

  String _promptLabel(String key) => switch (key) {
        ReflectionPromptKeys.whatWentWell => 'What went well?',
        ReflectionPromptKeys.whatDistracted => 'What distracted you?',
        ReflectionPromptKeys.nextSessionGoal => 'Goal for next session?',
        ReflectionPromptKeys.overallFeeling => 'How do you feel overall?',
        _ => key,
      };

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(focusSessionControllerProvider) as FocusSummary;
    final notifier = ref.read(focusSessionControllerProvider.notifier);
    final theme = Theme.of(context);
    final session = summary.session;
    final elapsed = session.elapsed;

    final reflectionsDone = summary.reflections.length;
    final allDone = reflectionsDone >= _prompts.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(
            session.isCompleted
                ? Icons.check_circle_rounded
                : Icons.flag_rounded,
            size: 64,
            color: session.isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 12),
          Text(
            session.isCompleted ? 'Session Complete!' : 'Session Ended',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${elapsed.inMinutes} min ${elapsed.inSeconds % 60} sec',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Reflection prompts
          if (!allDone) ...[
            Text(
              'Quick Reflection (${reflectionsDone + 1}/${_prompts.length})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_promptLabel(_currentPromptKey)),
            const SizedBox(height: 8),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your answer…',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                if (_answerController.text.trim().isEmpty) return;
                await notifier.submitReflection(
                  promptKey: _currentPromptKey,
                  answer: _answerController.text.trim(),
                );
                _answerController.clear();
                if (_currentPromptIndex < _prompts.length - 1) {
                  setState(() => _currentPromptIndex++);
                }
              },
              child: const Text('Next'),
            ),
            TextButton(
              onPressed: notifier.dismissSummary,
              child: const Text('Skip reflections'),
            ),
          ] else ...[
            const Text(
              'Great job! Your reflection has been saved.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: notifier.dismissSummary,
              child: const Text('Done'),
            ),
          ],
        ],
      ),
    );
  }
}
