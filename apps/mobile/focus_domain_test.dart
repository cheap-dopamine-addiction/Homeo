import 'package:flutter_test/flutter_test.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/focus_stats.dart';
import 'package:homeo/features/focus_session/domain/streak_calculator.dart';

void main() {
  final start = DateTime(2026, 9, 20, 9);
  const planned = Duration(minutes: 25);
  final session = FocusSession(
    id: 'a',
    intention: '',
    plannedDuration: planned,
    startedAt: start,
  );

  group('FocusSession timing', () {
    test('elapsed follows the clock', () {
      expect(
        session.elapsedAt(start.add(const Duration(minutes: 10))),
        const Duration(minutes: 10),
      );
    });

    test('time spent paused is not counted', () {
      final paused = session.paused(start.add(const Duration(minutes: 5)));

      // Frozen while paused, however long we wait.
      expect(
        paused.elapsedAt(start.add(const Duration(minutes: 30))),
        const Duration(minutes: 5),
      );

      final resumed = paused.resumed(start.add(const Duration(minutes: 15)));
      expect(resumed.pauseCount, 1);
      expect(resumed.pausedTotal, const Duration(minutes: 10));
      expect(resumed.isPaused, isFalse);
      // 20 min on the wall clock − 10 min paused = 10 min focused.
      expect(
        resumed.elapsedAt(start.add(const Duration(minutes: 20))),
        const Duration(minutes: 10),
      );
    });

    test('elapsed never exceeds the planned duration', () {
      expect(session.elapsedAt(start.add(const Duration(hours: 3))), planned);
      expect(session.remainingAt(start.add(const Duration(hours: 3))), Duration.zero);
    });

    test('completed session reports planned duration and the ideal end time', () {
      final paused = session
          .paused(start.add(const Duration(minutes: 5)))
          .resumed(start.add(const Duration(minutes: 15)));

      // App only noticed 40 min in; ideal end is 25 + 10 paused = 35 min.
      final done = paused.finished(
        now: start.add(const Duration(minutes: 40)),
        completed: true,
      );
      expect(done.status, FocusSessionStatus.completed);
      expect(done.actualDuration, planned);
      expect(done.endedAt, start.add(const Duration(minutes: 35)));
    });

    test('aborted session keeps the focused time so far', () {
      final aborted = session.finished(
        now: start.add(const Duration(minutes: 7)),
        completed: false,
      );
      expect(aborted.status, FocusSessionStatus.aborted);
      expect(aborted.actualDuration, const Duration(minutes: 7));
    });
  });

  group('StreakCalculator', () {
    final today = DateTime(2026, 9, 20);
    DateTime day(int daysAgo) => DateTime(2026, 9, 20 - daysAgo);

    test('empty history', () {
      final r = StreakCalculator.compute(const [], today);
      expect((r.current, r.best), (0, 0));
    });

    test('consecutive days ending today', () {
      final r = StreakCalculator.compute([day(0), day(1), day(2)], today);
      expect((r.current, r.best), (3, 3));
    });

    test('streak survives until the day is over (nothing yet today)', () {
      final r = StreakCalculator.compute([day(1), day(2)], today);
      expect((r.current, r.best), (2, 2));
    });

    test('a missed full day resets current but never erases best', () {
      final r = StreakCalculator.compute(
        [day(0), day(6), day(7), day(8), day(9), day(10)],
        today,
      );
      expect((r.current, r.best), (1, 5));
    });

    test('last activity two days ago → current is 0', () {
      final r = StreakCalculator.compute([day(2)], today);
      expect((r.current, r.best), (0, 1));
    });

    test('several sessions on one day count once', () {
      final r = StreakCalculator.compute(
        [DateTime(2026, 9, 20, 8), DateTime(2026, 9, 20, 21)],
        today,
      );
      expect((r.current, r.best), (1, 1));
    });
  });

  group('FocusStats', () {
    FocusSession finished(DateTime at, int minutes, FocusSessionStatus status) {
      return FocusSession(
        id: at.toIso8601String(),
        intention: '',
        plannedDuration: Duration(minutes: minutes),
        startedAt: at,
        status: status,
        actualDuration: Duration(minutes: minutes),
      );
    }

    test('counts completed sessions only', () {
      final now = DateTime(2026, 9, 20, 18); // a Sunday
      final stats = FocusStats.from([
        finished(DateTime(2026, 9, 20, 15), 25, FocusSessionStatus.completed),
        finished(DateTime(2026, 9, 20, 10), 45, FocusSessionStatus.aborted),
        finished(DateTime(2026, 9, 15, 10), 60, FocusSessionStatus.completed),
      ], now);

      expect(stats.focusToday, const Duration(minutes: 25));
      expect(stats.sessionsToday, 1);
      // Week starts Monday 2026-09-14 → includes the 15th.
      expect(stats.focusThisWeek, const Duration(minutes: 85));
      expect(stats.lastSession?.status, FocusSessionStatus.completed);
    });
  });
}
