import 'package:homeo/features/focus_session/domain/session_reflection.dart';

// ---------------------------------------------------------------------------
// Status enum
// ---------------------------------------------------------------------------

/// Lifecycle status of a [FocusSession].
enum FocusSessionStatus {
  /// Session has been set up but not yet started.
  idle,

  /// Timer is running.
  running,

  /// Timer was paused by the user.
  paused,

  /// Session was abandoned before completion.
  abandoned,

  /// Session finished — either the planned duration was reached
  /// or the user ended it manually after a minimum threshold.
  completed,
}

// ---------------------------------------------------------------------------
// Domain model
// ---------------------------------------------------------------------------

/// Immutable representation of a single focus session.
class FocusSession {
  const FocusSession({
    required this.id,
    required this.plannedMinutes,
    required this.startedAt,
    this.taskLabel,
    this.endedAt,
    this.elapsedSeconds = 0,
    this.status = FocusSessionStatus.idle,
    this.exitReason,
    this.mood,
    this.reflections = const [],
  });

  final String id;

  /// Optional free-text label the user gives to the session.
  final String? taskLabel;

  /// How long the user intended to focus, in minutes.
  final int plannedMinutes;

  /// Actual elapsed time when the session ended, in seconds.
  final int elapsedSeconds;

  final FocusSessionStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final ExitReason? exitReason;
  final SessionMood? mood;
  final List<ReflectionEntry> reflections;

  // ---------- Derived ----------

  Duration get planned => Duration(minutes: plannedMinutes);
  Duration get elapsed => Duration(seconds: elapsedSeconds);

  bool get isCompleted => status == FocusSessionStatus.completed;
  bool get isAbandoned => status == FocusSessionStatus.abandoned;

  /// Completion ratio in [0, 1].
  double get completionRatio {
    final planned = this.planned.inSeconds;
    if (planned == 0) return 0;
    return (elapsedSeconds / planned).clamp(0.0, 1.0);
  }

  // ---------- Copy helpers ----------

  FocusSession copyWith({
    String? id,
    String? taskLabel,
    int? plannedMinutes,
    int? elapsedSeconds,
    FocusSessionStatus? status,
    DateTime? startedAt,
    DateTime? endedAt,
    ExitReason? exitReason,
    SessionMood? mood,
    List<ReflectionEntry>? reflections,
  }) =>
      FocusSession(
        id: id ?? this.id,
        taskLabel: taskLabel ?? this.taskLabel,
        plannedMinutes: plannedMinutes ?? this.plannedMinutes,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        status: status ?? this.status,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        exitReason: exitReason ?? this.exitReason,
        mood: mood ?? this.mood,
        reflections: reflections ?? this.reflections,
      );

  @override
  String toString() =>
      'FocusSession(id: $id, status: $status, planned: ${plannedMinutes}m)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
