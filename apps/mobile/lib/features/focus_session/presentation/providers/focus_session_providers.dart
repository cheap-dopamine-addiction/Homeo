import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/data/focus_session_repository.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/focus_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'focus_session_providers.g.dart';

/// keepAlive: leaving the Focus home view (e.g. during a session) must not
/// tear down the DB stream and flash empty stats on return.
///
/// MVP note: this reads every finished session so "best streak" is exact.
/// Swap for the `analytics_snapshots` daily roll-up (PRD §16.2) if history
/// grows large.
@Riverpod(keepAlive: true)
Stream<List<FocusSession>> finishedSessions(Ref ref) {
  return ref.watch(focusSessionRepositoryProvider).watchFinished();
}

@Riverpod(keepAlive: true)
FocusStats focusStats(Ref ref) {
  final sessions =
      ref.watch(finishedSessionsProvider).value ?? const <FocusSession>[];
  return FocusStats.from(sessions, ref.watch(clockProvider).now());
}
