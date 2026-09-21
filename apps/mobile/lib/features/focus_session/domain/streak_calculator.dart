import 'package:flutter/foundation.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';

@immutable
class StreakResult {
  const StreakResult({
    required this.current,
    required this.best,
    this.lastRunLength = 0,
    this.lastRunEnd,
  });

  final int current;
  final int best;

  /// The most recent run of consecutive days (alive or not) and the day it
  /// ended on. Lets the UI tell "no streak yet" from "streak just broke".
  final int lastRunLength;
  final DateTime? lastRunEnd;
}

/// A streak that ended — input for the recovery screen (PRD §7.3, §13.7).
@immutable
class StreakBreak {
  const StreakBreak({required this.length, required this.endedOn});

  final int length;
  final DateTime endedOn;
}

/// Non-punishing streak (PRD §9.2 / §2.3): shows *current* next to *best*, and
/// a missed day never erases history.
///
/// A day counts when it has at least one **completed** session. The current
/// streak stays alive through today if today has no session yet — you only
/// lose it once a whole day has passed without one.
abstract final class StreakCalculator {
  static final DateTime _epoch = DateTime.utc(1970);

  static StreakResult compute(
    Iterable<DateTime> completedDays,
    DateTime today,
  ) {
    final days = completedDays.map(_dayIndex).toSet();
    if (days.isEmpty) return const StreakResult(current: 0, best: 0);

    final sorted = days.toList()..sort();
    var best = 1;
    var run = 1;
    for (var i = 1; i < sorted.length; i++) {
      run = sorted[i] == sorted[i - 1] + 1 ? run + 1 : 1;
      if (run > best) best = run;
    }

    final lastDay = sorted.last;
    var lastRunLength = 0;
    for (var d = lastDay; days.contains(d); d--) {
      lastRunLength++;
    }

    final todayIndex = _dayIndex(today);
    final anchor = lastDay >= todayIndex - 1 ? lastDay : null;
    final current = anchor == null ? 0 : lastRunLength;

    return StreakResult(
      current: current,
      best: best,
      lastRunLength: lastRunLength,
      lastRunEnd: _fromIndex(lastDay),
    );
  }

  /// A break exists when the last run is dead, was long enough to matter, and
  /// the user has not acknowledged *that* run yet.
  static StreakBreak? detectBreak(
    StreakResult streak, {
    DateTime? acknowledgedRunEnd,
  }) {
    final end = streak.lastRunEnd;
    if (end == null) return null;
    if (streak.current > 0) return null;
    if (streak.lastRunLength < FocusRules.minStreakForRecovery) return null;
    if (acknowledgedRunEnd != null &&
        _dayIndex(acknowledgedRunEnd) == _dayIndex(end)) {
      return null;
    }
    return StreakBreak(length: streak.lastRunLength, endedOn: end);
  }

  /// Calendar-day number, immune to DST/time-of-day.
  static int _dayIndex(DateTime d) =>
      DateTime.utc(d.year, d.month, d.day).difference(_epoch).inDays;

  static DateTime _fromIndex(int index) {
    final utc = _epoch.add(Duration(days: index));
    return DateTime(utc.year, utc.month, utc.day);
  }
}
