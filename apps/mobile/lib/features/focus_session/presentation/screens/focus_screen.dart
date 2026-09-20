import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/screens/active_session_view.dart';
import 'package:homeo/features/focus_session/presentation/screens/focus_home_view.dart';
import 'package:homeo/features/focus_session/presentation/screens/session_setup_view.dart';
import 'package:homeo/features/focus_session/presentation/screens/session_summary_view.dart';

/// Top-level screen for the Focus feature.
///
/// Switches between sub-views based on the current [FocusPhase].
class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(focusSessionControllerProvider);

    return Scaffold(
      appBar: state.phase == FocusPhase.active
          ? null // hide AppBar during immersive timer
          : AppBar(title: const Text('Focus')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state.phase) {
          FocusPhase.idle => const FocusHomeView(),
          FocusPhase.setup => const SessionSetupView(),
          FocusPhase.active => const ActiveSessionView(),
          FocusPhase.summary => const SessionSummaryView(),
        },
      ),
    );
  }
}
