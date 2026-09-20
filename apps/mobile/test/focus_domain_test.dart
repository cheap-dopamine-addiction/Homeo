// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/focus_stats.dart';
import 'package:homeo/features/focus_session/domain/streak_calculator.dart';

// FIX: the test file was importing from paths that did not exist yet:
//   package:homeo/features/focus_session/domain/focus_session.dart   ← now created
//   package:homeo/features/focus_session/domain/focus_stats.dart      ← now created
//   package:homeo/features/focus_session/domain/streak_calculator.dart ← now created
//
// All FocusSession / FocusSessionStatus / FocusStats / StreakCalculator
// references are resolved once those files exist.

void main() {
  // Helper factory
  FocusSession makeSession({
    required String id,
    required DateTime startedAt,
    int plannedMinutes = 25,
    int elapsedSeconds = 1500, // 25 min
    FocusSessionStatus status = FocusSessionStatus.completed,
  }) =>
      FocusSession(
        id: id,
        plannedMinutes: plannedMinutes,
        startedAt: startedAt,
        elapsedSeconds: elapsedSeconds,
        status: status,
        endedAt: startedAt.add(Duration(seconds: elapsedSeconds)),
      );

  // ---------------------------------------------------------------------------
  // FocusSession
  // ---------------------------------------------------------------------------
  group('FocusSession', () {
    test('completionRatio returns correct fraction', () {
      final session = makeSession(
        id: '1',
        startedAt: DateTime(2025, 1, 1),
        plannedMinutes: 25,
        elapsedSeconds: 750, // half
      );
      expect(session.completionRatio, closeTo(0.5, 0.01));
    });

    test('isCompleted true when status is completed', () {
      final s = makeSession(id: '2', startedAt: DateTime(2025, 1, 2));
      expect(s.isCompleted, isTrue);
    });

    test('isAbandoned true when status is abandoned', () {
      final s = makeSession(
        id: '3',
        startedAt: DateTime(2025, 1, 3),
        status: FocusSessionStatus.abandoned,
      );
      expect(s.isAbandoned, isTrue);
    });

    test('FocusSessionStatus.completed name is "completed"', () {
      expect(FocusSessionStatus.completed.name, 'completed');
    });

    test('FocusSessionStatus.running name is "running"', () {
      expect(FocusSessionStatus.running.name, 'running');
    });
  });

  // ---------------------------------------------------------------------------
  // StreakCalculator
  // ---------------------------------------------------------------------------
  group('StreakCalculator', () {
    const calc = StreakCalculator();
    final today = DateTime(2025, 6, 10);

    test('returns 0 when no sessions', () {
      expect(calc.currentStreak([], now: today), 0);
    });

    test('returns 1 for a single session today', () {
      final sessions = [makeSession(id: '1', startedAt: today)];
      expect(calc.currentStreak(sessions, now: today), 1);
    });

    test('returns consecutive day count', () {
      final sessions = [
        makeSession(id: '1', startedAt: today),
        makeSession(
            id: '2', startedAt: today.subtract(const Duration(days: 1))),
        makeSession(
            id: '3', startedAt: today.subtract(const Duration(days: 2))),
      ];
      expect(calc.currentStreak(sessions, now: today), 3);
    });

    test('streak breaks on gap day', () {
      final sessions = [
        makeSession(id: '1', startedAt: today),
        // gap on day -1
        makeSession(
            id: '2', startedAt: today.subtract(const Duration(days: 2))),
      ];
      expect(calc.currentStreak(sessions, now: today), 1);
    });

    test('bestStreak is longest consecutive run', () {
      final sessions = [
        makeSession(id: '1', startedAt: DateTime(2025, 1, 1)),
        makeSession(id: '2', startedAt: DateTime(2025, 1, 2)),
        makeSession(id: '3', startedAt: DateTime(2025, 1, 3)),
        // gap
        makeSession(id: '4', startedAt: DateTime(2025, 1, 5)),
        makeSession(id: '5', startedAt: DateTime(2025, 1, 6)),
      ];
      expect(calc.bestStreak(sessions), 3);
    });
  });

  // ---------------------------------------------------------------------------
  // FocusStats
  // ---------------------------------------------------------------------------
  group('FocusStats', () {
    test('fromSessions returns zeros for empty list', () {
      final stats = FocusStats.fromSessions([], currentStreak: 0, bestStreak: 0);
      expect(stats.totalSessions, 0);
      expect(stats.completionRate, 0.0);
    });

    test('counts completed vs abandoned correctly', () {
      final sessions = [
        makeSession(id: '1', startedAt: DateTime(2025, 1, 1),
            status: FocusSessionStatus.completed),
        makeSession(id: '2', startedAt: DateTime(2025, 1, 2),
            status: FocusSessionStatus.abandoned),
        makeSession(id: '3', startedAt: DateTime(2025, 1, 3),
            status: FocusSessionStatus.completed),
      ];
      final stats = FocusStats.fromSessions(sessions,
          currentStreak: 2, bestStreak: 3);
      expect(stats.totalSessions, 3);
      expect(stats.completedSessions, 2);
      expect(stats.abandonedSessions, 1);
      expect(stats.completionRate, closeTo(2 / 3, 0.01));
    });

    test('propagates streak values', () {
      final stats = FocusStats.fromSessions([],
          currentStreak: 5, bestStreak: 10);
      expect(stats.currentStreak, 5);
      expect(stats.bestStreak, 10);
    });
  });
}
