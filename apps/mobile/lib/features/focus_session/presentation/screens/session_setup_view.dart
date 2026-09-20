import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';

/// Shown when state is [FocusSetup].
///
/// Lets the user choose a duration and optional task label before
/// starting the timer.
class SessionSetupView extends ConsumerStatefulWidget {
  const SessionSetupView({super.key});

  @override
  ConsumerState<SessionSetupView> createState() => _SessionSetupViewState();
}

class _SessionSetupViewState extends ConsumerState<SessionSetupView> {
  late final TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    final setup = ref.read(focusSessionControllerProvider) as FocusSetup;
    _taskController = TextEditingController(text: setup.taskLabel ?? '');
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(focusSessionControllerProvider) as FocusSetup;
    final notifier = ref.read(focusSessionControllerProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: notifier.cancelSetup,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 16),
          Text('Set Up Session', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Task label input
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: 'What will you focus on? (optional)',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => notifier.updateSetup(taskLabel: v),
            maxLength: 100,
          ),
          const SizedBox(height: 24),

          // Duration presets
          Text('Duration', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: FocusRules.presets.map((mins) {
              final selected = setup.plannedMinutes == mins;
              return ChoiceChip(
                label: Text('$mins min'),
                selected: selected,
                onSelected: (_) => notifier.updateSetup(plannedMinutes: mins),
              );
            }).toList(),
          ),
          const Spacer(),

          // Start
          FilledButton.icon(
            onPressed: notifier.beginSession,
            icon: const Icon(Icons.play_arrow_rounded),
            label:
                Text('Focus for ${setup.plannedMinutes} min'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
