import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';

enum FocusPhase { idle, setup, running, summary }

/// What the Focus tab is doing right now.
sealed class FocusSessionState {
  const FocusSessionState();

  FocusPhase get phase;
}

final class FocusIdle extends FocusSessionState {
  const FocusIdle();

  @override
  FocusPhase get phase => FocusPhase.idle;
}

final class FocusSetup extends FocusSessionState {
  const FocusSetup();

  @override
  FocusPhase get phase => FocusPhase.setup;
}

/// A session is active (running or paused).
///
/// [now] is the last time the controller ticked; countdown getters derive from
/// it. While paused nothing ticks and [FocusSession.elapsedAt] is frozen.
final class FocusRunning extends FocusSessionState {
  const FocusRunning({
    required this.session,
    required this.now,
    required this.pausesUsedBefore,
  });

  final FocusSession session;
  final DateTime now;

  /// Pauses spent by *other* sessions earlier today.
  final int pausesUsedBefore;

  @override
  FocusPhase get phase => FocusPhase.running;

  bool get isPaused => session.isPaused;
  Duration get remaining => session.remainingAt(now);

  /// Whole seconds, rounded up, so the display never shows 00:00 early.
  int get remainingSeconds => (remaining.inMilliseconds / 1000).ceil();

  /// 1.0 at the start, 0.0 at the end.
  double get progress {
    final total = session.plannedDuration.inMilliseconds;
    if (total <= 0) return 0;
    return (remaining.inMilliseconds / total).clamp(0.0, 1.0);
  }

  int get pausesUsedToday => pausesUsedBefore + session.pauseCount;
  bool get canPause => pausesUsedToday < FocusRules.maxPausesPerDay;

  FocusRunning copyWith({FocusSession? session, DateTime? now}) {
    return FocusRunning(
      session: session ?? this.session,
      now: now ?? this.now,
      pausesUsedBefore: pausesUsedBefore,
    );
  }
}

/// The just-finished session, waiting for the optional reflection.
final class FocusSummary extends FocusSessionState {
  const FocusSummary({required this.session});

  final FocusSession session;

  @override
  FocusPhase get phase => FocusPhase.summary;

  bool get completed => session.status == FocusSessionStatus.completed;
}
