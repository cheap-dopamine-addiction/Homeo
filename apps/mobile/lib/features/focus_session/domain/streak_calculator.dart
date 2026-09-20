import 'package:homeo/features/focus_session/domain/focus_session.dart';

/// Pure function object that calculates focus streaks from session history.
///
/// A "streak day" is any calendar day (local time) on which the user
/// completed at least one session.
class StreakCalculator {
  const StreakCalculator();

  // ---------- Public API ----------

  /// Returns the number of consecutive days (ending today or yesterday)
  /// on which the user completed at least one session.
  int currentStreak(List<FocusSession> sessions, {required DateTime now}) {
    final days = _completedDays(sessions);
    if (days.isEmpty) return 0;

    final today = _dayOnly(now);
    int streak = 0;
    DateTime cursor = today;

    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    // Also count yesterday-anchor: if today is not yet in the set but
    // yesterday is, the streak is still live.
    if (streak == 0) {
      cursor = today.subtract(const Duration(days: 1));
      while (days.contains(cursor)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }

  /// Returns the longest streak ever recorded.
  int bestStreak(List<FocusSession> sessions) {
    final days = _completedDays(sessions).toList()..sort();
    if (days.isEmpty) return 0;

    int best = 1;
    int current = 1;

    for (int i = 1; i < days.length; i++) {
      final diff = days[i].difference(days[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > best) best = current;
      } else if (diff > 1) {
        current = 1;
      }
    }

    return best;
  }

  /// Returns the number of distinct days on which at least one
  /// session was completed.
  int totalActiveDays(List<FocusSession> sessions) =>
      _completedDays(sessions).length;

  // ---------- Helpers ----------

  Set<DateTime> _completedDays(List<FocusSession> sessions) {
    return sessions
        .where((s) => s.status == FocusSessionStatus.completed)
        .map((s) => _dayOnly(s.startedAt))
        .toSet();
  }

  DateTime _dayOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}
