import 'package:homeo/features/focus_session/domain/focus_session.dart';

/// Aggregate statistics computed from a list of [FocusSession]s.
class FocusStats {
  const FocusStats({
    required this.totalSessions,
    required this.completedSessions,
    required this.abandonedSessions,
    required this.totalFocusMinutes,
    required this.averageFocusMinutes,
    required this.longestSessionMinutes,
    required this.currentStreak,
    required this.bestStreak,
  });

  final int totalSessions;
  final int completedSessions;
  final int abandonedSessions;
  final int totalFocusMinutes;
  final double averageFocusMinutes;
  final int longestSessionMinutes;
  final int currentStreak;
  final int bestStreak;

  double get completionRate =>
      totalSessions == 0 ? 0 : completedSessions / totalSessions;

  /// Computes [FocusStats] from a list of sessions.
  factory FocusStats.fromSessions(
    List<FocusSession> sessions, {
    required int currentStreak,
    required int bestStreak,
  }) {
    if (sessions.isEmpty) {
      return FocusStats(
        totalSessions: 0,
        completedSessions: 0,
        abandonedSessions: 0,
        totalFocusMinutes: 0,
        averageFocusMinutes: 0,
        longestSessionMinutes: 0,
        currentStreak: currentStreak,
        bestStreak: bestStreak,
      );
    }

    final completed = sessions
        .where((s) => s.status == FocusSessionStatus.completed)
        .toList();
    final abandoned = sessions
        .where((s) => s.status == FocusSessionStatus.abandoned)
        .toList();

    final totalSeconds =
        sessions.fold<int>(0, (sum, s) => sum + s.elapsedSeconds);
    final totalMinutes = totalSeconds ~/ 60;

    final longestSeconds =
        sessions.fold<int>(0, (m, s) => s.elapsedSeconds > m ? s.elapsedSeconds : m);

    return FocusStats(
      totalSessions: sessions.length,
      completedSessions: completed.length,
      abandonedSessions: abandoned.length,
      totalFocusMinutes: totalMinutes,
      averageFocusMinutes:
          sessions.isEmpty ? 0 : totalMinutes / sessions.length,
      longestSessionMinutes: longestSeconds ~/ 60,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
  }

  @override
  String toString() =>
      'FocusStats(total: $totalSessions, completed: $completedSessions, '
      'streak: $currentStreak)';
}
