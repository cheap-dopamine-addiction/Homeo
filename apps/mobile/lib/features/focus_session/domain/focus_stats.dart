import 'package:flutter/foundation.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/streak_calculator.dart';

/// Numbers shown on the Focus home screen.
///
/// Minutes and streak count **completed** sessions only, matching the North
/// Star "Weekly Sustained Focus Minutes" (PRD §32.1).
@immutable
class FocusStats {
  const FocusStats({
    required this.focusToday,
    required this.focusThisWeek,
    required this.sessionsToday,
    required this.streak,
    required this.lastSession,
  });

  static const FocusStats empty = FocusStats(
    focusToday: Duration.zero,
    focusThisWeek: Duration.zero,
    sessionsToday: 0,
    streak: StreakResult(current: 0, best: 0),
    lastSession: null,
  );

  final Duration focusToday;
  final Duration focusThisWeek;
  final int sessionsToday;
  final StreakResult streak;

  /// Most recent finished session (completed or aborted).
  final FocusSession? lastSession;

  /// [finishedNewestFirst] must be sorted by `startedAt`, newest first.
  factory FocusStats.from(
    List<FocusSession> finishedNewestFirst,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    var focusToday = Duration.zero;
    var focusWeek = Duration.zero;
    var sessionsToday = 0;
    final completedDays = <DateTime>{};

    for (final s in finishedNewestFirst) {
      if (s.status != FocusSessionStatus.completed) continue;
      final day = DateTime(
        s.startedAt.year,
        s.startedAt.month,
        s.startedAt.day,
      );
      completedDays.add(day);
      if (!day.isBefore(weekStart)) focusWeek += s.actualDuration;
      if (day == today) {
        focusToday += s.actualDuration;
        sessionsToday++;
      }
    }

    return FocusStats(
      focusToday: focusToday,
      focusThisWeek: focusWeek,
      sessionsToday: sessionsToday,
      streak: StreakCalculator.compute(completedDays, now),
      lastSession: finishedNewestFirst.isEmpty
          ? null
          : finishedNewestFirst.first,
    );
  }
}
