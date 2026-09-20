/// Business rules governing focus-session behaviour.
///
/// Centralises constants and validation so they can be unit-tested
/// independently of UI or infrastructure.
abstract class FocusRules {
  FocusRules._();

  // ---------- Duration limits ----------

  /// Shortest allowed planned session, in minutes.
  static const int minPlannedMinutes = 1;

  /// Longest allowed planned session, in minutes.
  static const int maxPlannedMinutes = 180;

  /// Default planned duration when the user hasn't chosen one yet.
  static const int defaultPlannedMinutes = 25;

  // ---------- Completion threshold ----------

  /// A session is considered "completed" (not abandoned) when the user has
  /// focused for at least this fraction of the planned duration.
  static const double completionThreshold = 0.5;

  /// Minimum elapsed seconds before an intentional "end" counts as completed
  /// (prevents accidentally completing a 1-second session).
  static const int minElapsedSecondsForCompletion = 60;

  // ---------- Validation ----------

  /// Returns `true` when [minutes] is within the allowed range.
  static bool isValidDuration(int minutes) =>
      minutes >= minPlannedMinutes && minutes <= maxPlannedMinutes;

  /// Whether a session with [elapsedSeconds] out of [plannedSeconds]
  /// should be marked as [FocusSessionStatus.completed] vs abandoned.
  static bool isCompleted({
    required int elapsedSeconds,
    required int plannedSeconds,
  }) {
    if (elapsedSeconds < minElapsedSecondsForCompletion) return false;
    if (plannedSeconds == 0) return false;
    return (elapsedSeconds / plannedSeconds) >= completionThreshold;
  }

  // ---------- Pomodoro presets ----------

  /// Standard Pomodoro-technique preset durations (minutes).
  static const List<int> presets = [15, 25, 45, 60, 90];
}
