import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';

// ---------------------------------------------------------------------------
// Phase enum  (used in focus_screen.dart to switch child views)
// ---------------------------------------------------------------------------

/// Which sub-view the Focus screen should display.
enum FocusPhase {
  /// Landing page — no session active.
  idle,

  /// Duration / task setup before starting the timer.
  setup,

  /// Timer is running (or paused).
  active,

  /// End-of-session summary & reflection.
  summary,
}

// ---------------------------------------------------------------------------
// Sealed state hierarchy
// ---------------------------------------------------------------------------

/// Base class for all states the [FocusSessionController] can emit.
sealed class FocusSessionState {
  const FocusSessionState();

  /// Which [FocusPhase] this state corresponds to.
  FocusPhase get phase;
}

/// No session is currently active.
final class FocusIdle extends FocusSessionState {
  const FocusIdle();

  @override
  FocusPhase get phase => FocusPhase.idle;
}

/// The user is configuring a new session (duration, task label).
final class FocusSetup extends FocusSessionState {
  const FocusSetup({this.plannedMinutes = 25, this.taskLabel});

  final int plannedMinutes;
  final String? taskLabel;

  @override
  FocusPhase get phase => FocusPhase.setup;

  FocusSetup copyWith({int? plannedMinutes, String? taskLabel}) => FocusSetup(
        plannedMinutes: plannedMinutes ?? this.plannedMinutes,
        taskLabel: taskLabel ?? this.taskLabel,
      );
}

/// The timer is running (or paused).
final class FocusRunning extends FocusSessionState {
  const FocusRunning({
    required this.session,
    required this.elapsedSeconds,
    this.isPaused = false,
  });

  final FocusSession session;
  final int elapsedSeconds;
  final bool isPaused;

  @override
  FocusPhase get phase => FocusPhase.active;

  Duration get elapsed => Duration(seconds: elapsedSeconds);
  Duration get planned => session.planned;
  Duration get remaining => (planned - elapsed).isNegative
      ? Duration.zero
      : planned - elapsed;

  double get progress => (elapsedSeconds / session.plannedMinutes / 60)
      .clamp(0.0, 1.0);

  FocusRunning copyWith({
    FocusSession? session,
    int? elapsedSeconds,
    bool? isPaused,
  }) =>
      FocusRunning(
        session: session ?? this.session,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        isPaused: isPaused ?? this.isPaused,
      );
}

/// Session has ended — showing the summary / reflection UI.
final class FocusSummary extends FocusSessionState {
  const FocusSummary({
    required this.session,
    this.reflections = const [],
  });

  final FocusSession session;
  final List<ReflectionEntry> reflections;

  @override
  FocusPhase get phase => FocusPhase.summary;
}
