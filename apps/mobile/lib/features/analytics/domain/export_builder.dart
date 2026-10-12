import 'dart:convert';

import 'package:homeo/features/analytics/domain/insights_calculator.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/features/settings/domain/user_settings.dart';

enum ExportFormat { pdf, csv, json, markdown, png }

extension ExportFormatX on ExportFormat {
  /// PDF and PNG need a renderer / file-saving plugin that the project does
  /// not depend on yet, so only text formats are produced today.
  bool get supported =>
      this == ExportFormat.csv ||
      this == ExportFormat.json ||
      this == ExportFormat.markdown;

  String get extension => switch (this) {
    ExportFormat.markdown => 'md',
    _ => name,
  };
}

enum ExportRange { days7, days30, thisMonth, custom }

/// Builds export text from local data only (offline-first, PRD §24.2 export
/// right). Encrypted reflection text is never exported here.
abstract final class ExportBuilder {
  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _hm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  static String fileName(ExportFormat format, DateTime today) =>
      'homeo_export_${_ymd(today)}_${format.name.toUpperCase()}';

  static InsightsRange rangeFor(
    ExportRange range,
    DateTime today, {
    required DateTime customStart,
    required DateTime customEnd,
  }) {
    final t = InsightsCalculator.dayOf(today);
    return switch (range) {
      ExportRange.days7 => InsightsRange(
        DateTime(t.year, t.month, t.day - 6),
        t,
      ),
      ExportRange.days30 => InsightsRange(
        DateTime(t.year, t.month, t.day - 29),
        t,
      ),
      ExportRange.thisMonth => InsightsRange(DateTime(t.year, t.month), t),
      ExportRange.custom => InsightsCalculator.rangeFor(
        InsightsPeriod.custom,
        t,
        customStart: customStart,
        customEnd: customEnd,
      ),
    };
  }

  static String build({
    required ExportFormat format,
    required InsightsRange range,
    required List<FocusSession> sessions,
    required List<DistractionEvent> events,
    required List<BlockedApp> blockedApps,
    required UserSettings settings,
    required List<Map<String, Object?>> partners,
  }) {
    final s = [
      for (final x in sessions)
        if (range.contains(x.startedAt)) x,
    ]..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    final e = [
      for (final x in events)
        if (range.contains(x.occurredAt)) x,
    ]..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    switch (format) {
      case ExportFormat.csv:
        return _csv(s, e);
      case ExportFormat.json:
        return const JsonEncoder.withIndent('  ').convert({
          'range': {'from': _ymd(range.start), 'to': _ymd(range.end)},
          'settings': {
            'defaultFrictionLevel': settings.defaultFrictionLevel.code,
            'emergencyLimitPerMonth': settings.emergencyLimitPerMonth,
          },
          'blockedApps': [
            for (final b in blockedApps)
              {'app': b.appPackageId, 'level': b.level.code},
          ],
          'partners': partners,
          'sessions': [
            for (final x in s)
              {
                'startedAt': x.startedAt.toIso8601String(),
                'status': x.status.name,
                'plannedMinutes': x.plannedDuration.inMinutes,
                'actualMinutes': x.actualDuration.inMinutes,
                'intention': x.intention,
              },
          ],
          'distractionEvents': [
            for (final x in e)
              {
                'at': x.occurredAt.toIso8601String(),
                'app': x.appPackageId,
                'level': x.level.code,
                'action': x.action.name,
                'duringSession': x.duringSession,
              },
          ],
        });
      case ExportFormat.markdown:
        return _markdown(range, s, e);
      case ExportFormat.pdf:
      case ExportFormat.png:
        return '';
    }
  }

  static String _csv(List<FocusSession> s, List<DistractionEvent> e) {
    String q(String v) => '"${v.replaceAll('"', '""')}"';
    final b = StringBuffer('type,date,time,app,level,detail,minutes\n');
    for (final x in s) {
      b.writeln(
        [
          'session',
          _ymd(x.startedAt),
          _hm(x.startedAt),
          '',
          '',
          q('${x.status.name}: ${x.intention}'),
          x.actualDuration.inMinutes,
        ].join(','),
      );
    }
    for (final x in e) {
      b.writeln(
        [
          'distraction',
          _ymd(x.occurredAt),
          _hm(x.occurredAt),
          q(AppCatalog.nameOf(x.appPackageId)),
          'L${x.level.code}',
          x.action.name,
          '',
        ].join(','),
      );
    }
    return b.toString();
  }

  static String _markdown(
    InsightsRange range,
    List<FocusSession> s,
    List<DistractionEvent> e,
  ) {
    final b = StringBuffer(
      '# Homeo — ${_ymd(range.start)} → ${_ymd(range.end)}\n\n',
    );
    var day = range.start;
    while (!day.isAfter(range.end)) {
      final ss = [
        for (final x in s)
          if (InsightsCalculator.dayOf(x.startedAt) == day) x,
      ];
      final ee = [
        for (final x in e)
          if (InsightsCalculator.dayOf(x.occurredAt) == day) x,
      ];
      if (ss.isNotEmpty || ee.isNotEmpty) {
        final mins = ss
            .where((x) => x.status == FocusSessionStatus.completed)
            .fold<int>(0, (a, x) => a + x.actualDuration.inMinutes);
        b.writeln('## ${_ymd(day)}');
        b.writeln('- Focus: $mins min (${ss.length} sessions)');
        b.writeln('- Distraction events: ${ee.length}');
        for (final x in ee) {
          b.writeln(
            '  - ${_hm(x.occurredAt)} ${AppCatalog.nameOf(x.appPackageId)} · L${x.level.code} · ${x.action.name}',
          );
        }
        b.writeln();
      }
      day = DateTime(day.year, day.month, day.day + 1);
    }
    final data = InsightsCalculator.compute(
      range: range,
      finishedSessions: s,
      events: e,
    );
    b.writeln('## Summary');
    b.writeln('- Total focus: ${data.focusMinutes} min');
    b.writeln('- Dopamine Load Index: ${data.dli}/100');
    return b.toString();
  }
}
