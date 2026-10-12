import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/analytics/domain/insights_calculator.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';

/// All logged distraction events, newest first.
final distractionEventsProvider = StreamProvider<List<DistractionEvent>>((ref) {
  return ref.watch(frictionRepositoryProvider).watchEvents();
});

/// Smart insights for the last 7 days, used by the Focus-home tip card.
/// Empty until there is real data — nothing is invented.
final weeklySmartInsightsProvider = Provider<List<SmartInsight>>((ref) {
  final now = ref.watch(clockProvider).now();
  final sessions =
      ref.watch(finishedSessionsProvider).value ?? const <FocusSession>[];
  final events =
      ref.watch(distractionEventsProvider).value ?? const <DistractionEvent>[];
  final range = InsightsCalculator.rangeFor(
    InsightsPeriod.week,
    now,
    customStart: now,
    customEnd: now,
  );
  return InsightsCalculator.compute(
    range: range,
    finishedSessions: sessions,
    events: events,
  ).insights;
});
