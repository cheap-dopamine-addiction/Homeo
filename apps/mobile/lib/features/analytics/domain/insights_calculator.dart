import 'package:flutter/foundation.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';

enum InsightsPeriod { week, month, threeMonth, custom }

/// Inclusive day range `[start, end]` (both at local midnight).
@immutable
class InsightsRange {
  const InsightsRange(this.start, this.end);

  final DateTime start;
  final DateTime end;

  int get days =>
      DateTime.utc(end.year, end.month, end.day)
          .difference(DateTime.utc(start.year, start.month, start.day))
          .inDays +
      1;

  DateTime get endExclusive => DateTime(end.year, end.month, end.day + 1);

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(endExclusive);
}

@immutable
class AppUsage {
  const AppUsage({
    required this.packageId,
    required this.attempts,
    required this.blocks,
    required this.lastAt,
    required this.levelCode,
    required this.hourly,
  });

  final String packageId;
  final int attempts;

  /// Gates that ended with "back to focus".
  final int blocks;
  final DateTime lastAt;

  /// Highest friction level seen in the range (0–4).
  final int levelCode;

  /// 8 buckets of 2 h starting at 08:00 (design: labels 8…22).
  final List<int> hourly;
}

enum TimelineKind {
  focusCompleted,
  focusEndedEarly,
  attemptReturned,
  attemptNotified,
  attemptOpened,
  override,
}

@immutable
class TimelineEntry {
  const TimelineEntry({
    required this.at,
    required this.kind,
    this.minutes = 0,
    this.packageId = '',
    this.levelCode = 0,
  });

  final DateTime at;
  final TimelineKind kind;
  final int minutes;
  final String packageId;
  final int levelCode;
}

enum SmartInsightKind { bestHour, topApp, frictionBlocks }

@immutable
class SmartInsight {
  const SmartInsight(this.kind, {this.hour = 0, this.packageId = '', this.count = 0});

  final SmartInsightKind kind;
  final int hour;
  final String packageId;
  final int count;

  String get id => '${kind.name}:$hour:$packageId:$count';
}

@immutable
class InsightsData {
  const InsightsData({
    required this.range,
    required this.focusMinutes,
    required this.completedSessions,
    required this.sessionsPerDay,
    required this.dli,
    required this.apps,
    required this.insights,
  });

  final InsightsRange range;
  final int focusMinutes;
  final int completedSessions;
  final double sessionsPerDay;

  /// Dopamine Load Index, 0–100 (lower is better).
  final int dli;
  final List<AppUsage> apps;
  final List<SmartInsight> insights;
}

/// Pure statistics for the Insights tab, the Focus-home teaser and exports.
abstract final class InsightsCalculator {
  static DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  static InsightsRange rangeFor(
    InsightsPeriod period,
    DateTime anchor, {
    required DateTime customStart,
    required DateTime customEnd,
  }) {
    final end = dayOf(anchor);
    switch (period) {
      case InsightsPeriod.week:
        return InsightsRange(DateTime(end.year, end.month, end.day - 6), end);
      case InsightsPeriod.month:
        return InsightsRange(DateTime(end.year, end.month, end.day - 29), end);
      case InsightsPeriod.threeMonth:
        return InsightsRange(DateTime(end.year, end.month, end.day - 89), end);
      case InsightsPeriod.custom:
        final a = dayOf(customStart);
        final b = dayOf(customEnd);
        return a.isAfter(b) ? InsightsRange(b, a) : InsightsRange(a, b);
    }
  }

  /// Weight of one logged event in the Dopamine Load Index. Getting through a
  /// gate counts fully; being turned back counts a little (the urge still
  /// happened).
  static double _weight(ResolvedAction a) => switch (a) {
    ResolvedAction.returnedToFocus => 0.25,
    ResolvedAction.openedAnyway ||
    ResolvedAction.partnerApproved ||
    ResolvedAction.partnerAutoReleased => 1,
    ResolvedAction.emergencyOverride || ResolvedAction.notified => 0.5,
  };

  /// Weighted attempts per day that map to an index of 100.
  static const double _dliCeilingPerDay = 12;

  static InsightsData compute({
    required InsightsRange range,
    required List<FocusSession> finishedSessions,
    required List<DistractionEvent> events,
  }) {
    final sessions = [
      for (final s in finishedSessions)
        if (s.status == FocusSessionStatus.completed &&
            range.contains(s.startedAt))
          s,
    ];
    final evs = [
      for (final e in events)
        if (range.contains(e.occurredAt)) e,
    ];

    final focusMinutes = sessions.fold<int>(
      0,
      (sum, s) => sum + s.actualDuration.inMinutes,
    );

    final weighted = evs.fold<double>(0, (sum, e) => sum + _weight(e.action));
    final dli = (weighted / range.days / _dliCeilingPerDay * 100)
        .round()
        .clamp(0, 100);

    return InsightsData(
      range: range,
      focusMinutes: focusMinutes,
      completedSessions: sessions.length,
      sessionsPerDay: sessions.length / range.days,
      dli: dli,
      apps: _apps(evs),
      insights: _insights(sessions, evs),
    );
  }

  static List<AppUsage> _apps(List<DistractionEvent> evs) {
    final byApp = <String, List<DistractionEvent>>{};
    for (final e in evs) {
      byApp.putIfAbsent(e.appPackageId, () => []).add(e);
    }
    final result = <AppUsage>[];
    byApp.forEach((id, list) {
      final hourly = List<int>.filled(8, 0);
      var last = list.first.occurredAt;
      var level = 0;
      var blocks = 0;
      for (final e in list) {
        final idx = ((e.occurredAt.hour - 8) ~/ 2).clamp(0, 7);
        hourly[idx]++;
        if (e.occurredAt.isAfter(last)) last = e.occurredAt;
        if (e.level.code > level) level = e.level.code;
        if (e.action == ResolvedAction.returnedToFocus) blocks++;
      }
      result.add(
        AppUsage(
          packageId: id,
          attempts: list.length,
          blocks: blocks,
          lastAt: last,
          levelCode: level,
          hourly: hourly,
        ),
      );
    });
    result.sort((a, b) => b.attempts.compareTo(a.attempts));
    return result;
  }

  static List<SmartInsight> _insights(
    List<FocusSession> sessions,
    List<DistractionEvent> evs,
  ) {
    final out = <SmartInsight>[];

    if (sessions.isNotEmpty) {
      final minutesByWindow = <int, int>{};
      for (final s in sessions) {
        final window = s.startedAt.hour - s.startedAt.hour % 2;
        minutesByWindow[window] =
            (minutesByWindow[window] ?? 0) + s.actualDuration.inMinutes;
      }
      final best = minutesByWindow.entries.reduce(
        (a, b) => b.value > a.value ? b : a,
      );
      out.add(SmartInsight(SmartInsightKind.bestHour, hour: best.key));
    }

    final apps = _apps(evs);
    if (apps.isNotEmpty) {
      out.add(
        SmartInsight(
          SmartInsightKind.topApp,
          packageId: apps.first.packageId,
          count: apps.first.attempts,
        ),
      );
    }

    final blocks = evs
        .where((e) => e.action == ResolvedAction.returnedToFocus)
        .length;
    if (blocks > 0) {
      out.add(SmartInsight(SmartInsightKind.frictionBlocks, count: blocks));
    }
    return out;
  }

  /// Chronological entries for one calendar [day].
  static List<TimelineEntry> timeline({
    required DateTime day,
    required List<FocusSession> finishedSessions,
    required List<DistractionEvent> events,
  }) {
    final d = dayOf(day);
    final range = InsightsRange(d, d);
    final out = <TimelineEntry>[];

    for (final s in finishedSessions) {
      if (!range.contains(s.startedAt)) continue;
      out.add(
        TimelineEntry(
          at: s.endedAt ?? s.startedAt,
          kind: s.status == FocusSessionStatus.completed
              ? TimelineKind.focusCompleted
              : TimelineKind.focusEndedEarly,
          minutes: s.actualDuration.inMinutes,
        ),
      );
    }
    for (final e in events) {
      if (!range.contains(e.occurredAt)) continue;
      final kind = switch (e.action) {
        ResolvedAction.returnedToFocus => TimelineKind.attemptReturned,
        ResolvedAction.notified => TimelineKind.attemptNotified,
        ResolvedAction.emergencyOverride => TimelineKind.override,
        _ => TimelineKind.attemptOpened,
      };
      out.add(
        TimelineEntry(
          at: e.occurredAt,
          kind: kind,
          packageId: e.appPackageId,
          levelCode: e.level.code,
        ),
      );
    }
    out.sort((a, b) => a.at.compareTo(b.at));
    return out;
  }
}
