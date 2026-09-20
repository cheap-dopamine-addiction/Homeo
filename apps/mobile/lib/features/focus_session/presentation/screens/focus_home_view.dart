import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';

/// Shown when no session is active ([FocusPhase.idle]).
///
/// Lets the user start a new session setup.
class FocusHomeView extends ConsumerWidget {
  const FocusHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Icon(
            Icons.self_improvement_rounded,
            size: 96,
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to Focus?',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a focused work session to track your progress and build better habits.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () =>
                ref.read(focusSessionControllerProvider.notifier).startSetup(),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start Session'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
