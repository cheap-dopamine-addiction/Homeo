import 'package:flutter/foundation.dart';

/// PRD §16.2 `focus_sessions.status`.
enum FocusSessionStatus { active, completed, aborted }

/// One focus session.
///
/// Time is derived from wall-clock timestamps instead of counting ticks, so
/// the countdown stays correct when the app is backgrounded, throttled or
/// killed and restored — a decrementing `setInterval` (as in the React
/// prototype) drifts in all three cases.
@immutable
class FocusSession {
  const FocusSession({
    required this.id,
    required this.intention,
    required this.plannedDuration,
    required this.startedAt,
    this.status = FocusSessionStatus.active,
    this.actualDuration = Duration.zero,
    this.endedAt,
    this.pauseCount = 0,
    this.pausedTotal = Duration.zero,
    this.pausedAt,
  });

  final String id;
  final String intention;
  final Duration plannedDuration;
  final DateTime startedAt;
  final FocusSessionStatus status;

  /// Filled in when the session finishes.
  final Duration actualDuration;
  final DateTime? endedAt;

  /// How many times this session was paused.
  final int pauseCount;

  /// Total time spent in *finished* pauses.
  final Duration pausedTotal;

  /// Non-null while paused.
  final DateTime? pausedAt;

  bool get isActive => status == FocusSessionStatus.active;
  bool get isPaused => pausedAt != null;

  /// When the countdown reaches zero, *assuming no further pause*.
  /// Only meaningful while running (not paused).
  DateTime get endsAt => startedAt.add(plannedDuration + pausedTotal);

  /// Focused time at [now] (pauses excluded, capped at the planned duration).
  Duration elapsedAt(DateTime now) {
    final reference = pausedAt ?? now; // frozen while paused
    final elapsed = reference.difference(startedAt) - pausedTotal;
    if (elapsed.isNegative) return Duration.zero;
    return elapsed > plannedDuration ? plannedDuration : elapsed;
  }

  Duration remainingAt(DateTime now) => plannedDuration - elapsedAt(now);

  FocusSession paused(DateTime now) {
    if (isPaused) return this;
    return _copy(pausedAt: now, pauseCount: pauseCount + 1);
  }

  FocusSession resumed(DateTime now) {
    final since = pausedAt;
    if (since == null) return this;
    final gap = now.difference(since);
    return _copy(
      pausedTotal: pausedTotal + (gap.isNegative ? Duration.zero : gap),
      clearPausedAt: true,
    );
  }

  /// Closes the session.
  ///
  /// A completed session reports the planned duration and the *ideal* end
  /// time, even if the app only noticed later (e.g. it was suspended).
  FocusSession finished({required DateTime now, required bool completed}) {
    if (completed) {
      final idealEnd = startedAt.add(plannedDuration + pausedTotal);
      return _copy(
        status: FocusSessionStatus.completed,
        actualDuration: plannedDuration,
        endedAt: idealEnd.isBefore(now) ? idealEnd : now,
        clearPausedAt: true,
      );
    }
    return _copy(
      status: FocusSessionStatus.aborted,
      actualDuration: elapsedAt(now),
      endedAt: now,
    );
  }

  FocusSession _copy({
    FocusSessionStatus? status,
    Duration? actualDuration,
    DateTime? endedAt,
    int? pauseCount,
    Duration? pausedTotal,
    DateTime? pausedAt,
    bool clearPausedAt = false,
  }) {
    return FocusSession(
      id: id,
      intention: intention,
      plannedDuration: plannedDuration,
      startedAt: startedAt,
      status: status ?? this.status,
      actualDuration: actualDuration ?? this.actualDuration,
      endedAt: endedAt ?? this.endedAt,
      pauseCount: pauseCount ?? this.pauseCount,
      pausedTotal: pausedTotal ?? this.pausedTotal,
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
    );
  }
}
