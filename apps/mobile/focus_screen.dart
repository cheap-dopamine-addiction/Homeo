import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/screens/active_session_view.dart';
import 'package:homeo/features/focus_session/presentation/screens/focus_home_view.dart';
import 'package:homeo/features/focus_session/presentation/screens/session_setup_view.dart';
import 'package:homeo/features/focus_session/presentation/screens/session_summary_view.dart';

/// Root of the Focus tab. Only decides *which* phase view to show; each view
/// watches exactly the state it needs.
///
/// Watching just `phase` keeps this widget from rebuilding on every timer
/// tick — only [ActiveSessionView] does that.
class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(
      focusSessionControllerProvider.select((s) => s.phase),
    );

    return switch (phase) {
      FocusPhase.idle => const FocusHomeView(),
      FocusPhase.setup => const SessionSetupView(),
      FocusPhase.running => const ActiveSessionView(),
      FocusPhase.summary => const SessionSummaryView(),
    };
  }
}
