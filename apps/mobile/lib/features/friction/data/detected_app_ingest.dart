import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/friction/data/blocker_bridge.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/presentation/providers/friction_gate_controller.dart';
import 'package:uuid/uuid.dart';

/// Opens the reflective gate for one detected open. [eventId] ties the user's
/// answer to the row that was already logged for that open.
typedef InterventionHandler =
    Future<void> Function(String appPackageId, {String? eventId});

/// Whether a focus session was running at the given moment.
typedef SessionCoverageCheck = Future<bool> Function(DateTime at);

/// Turns "a watched app was opened" signals into `distraction_events` rows
/// (offline-first, PRD §9.3) and into the reflective gate. Nothing is ever
/// blocked: the gate is a pause the user can always walk through.
///
///  * Android: the accessibility service already showed a notification and
///    queued the event natively; [ingestPending] imports the queue. Tapping the
///    notification opens `homeo://intervention?app=<pkg>&ts=<ms>` →
///    [handleDeepLink] → the gate for that event.
///  * iOS: a Shortcuts automation opens `homeo://distraction-event?app=<id>`.
///    Homeo is then already in front, so the gate is shown directly.
///
/// Every link is checked against the watch list, and repeated opens of the
/// same app within [_dedupWindow] count once (PRD §9.3).
class DetectedAppIngest {
  DetectedAppIngest({
    required BlockerBridge bridge,
    required FrictionRepository repository,
    required Clock clock,
    required bool Function() isSessionRunning,
    required SessionCoverageCheck wasSessionRunningAt,
    required InterventionHandler onIntervention,
  }) : _bridge = bridge,
       _repo = repository,
       _clock = clock,
       _isSessionRunning = isSessionRunning,
       _wasSessionRunningAt = wasSessionRunningAt,
       _onIntervention = onIntervention;

  static const _uuid = Uuid();
  static const _scheme = 'homeo';
  static const _hostDetected = 'distraction-event';
  static const _hostIntervention = 'intervention';
  static const _dedupWindow = Duration(seconds: 30);

  final BlockerBridge _bridge;
  final FrictionRepository _repo;
  final Clock _clock;
  final bool Function() _isSessionRunning;
  final SessionCoverageCheck _wasSessionRunningAt;
  final InterventionHandler _onIntervention;

  bool _importing = false;

  /// Imports queued native events. Safe to call often. Returns how many were
  /// imported.
  ///
  /// Ids are deterministic (`native_<ts>_<package>`) and the insert ignores
  /// duplicates, so a crash between "insert" and "ack" simply re-imports the
  /// same rows next time without creating duplicates.
  Future<int> ingestPending() async {
    if (_importing) return 0;
    _importing = true;
    try {
      final pending = await _bridge.drainPendingEvents();
      if (pending.isEmpty) return 0;

      var newest = 0;
      for (final event in pending) {
        final at = DateTime.fromMillisecondsSinceEpoch(event.timestampMs);
        final blocked = await _repo.findBlockedApp(event.packageId);
        await _repo.logEvent(
          DistractionEvent(
            id: 'native_${event.timestampMs}_${event.packageId}',
            appPackageId: event.packageId,
            level: blocked?.level ?? FrictionLevel.awareness,
            action: ResolvedAction.notified,
            occurredAt: at,
            // Native cannot know about focus sessions; work it out from the
            // session history instead.
            duringSession: await _wasSessionRunningAt(at),
          ),
        );
        if (event.timestampMs > newest) newest = event.timestampMs;
      }

      // Only after every row is stored.
      await _bridge.ackPendingEvents(upTo: newest);
      return pending.length;
    } catch (e, st) {
      debugPrint('DetectedAppIngest.ingestPending failed: $e\n$st');
      return 0;
    } finally {
      _importing = false;
    }
  }

  /// `homeo://intervention?app=<pkg>&ts=<ms>` (Android notification tap) and
  /// `homeo://distraction-event?app=<id>` (iOS Shortcuts). Anything else, and
  /// any app that is not on the watch list, is ignored.
  Future<void> handleDeepLink(Uri uri) async {
    if (uri.scheme != _scheme) return;
    final appId = uri.queryParameters['app']?.trim();
    if (appId == null || appId.isEmpty) return;

    try {
      final blocked = await _repo.findBlockedApp(appId);
      if (blocked == null) return; // spoofed or stale link

      switch (uri.host) {
        case _hostIntervention:
          final ts = int.tryParse(uri.queryParameters['ts'] ?? '');
          await _onIntervention(
            appId,
            eventId: ts == null ? null : 'native_${ts}_$appId',
          );
        case _hostDetected:
          await _handleDetected(appId, blocked.level);
      }
    } catch (e, st) {
      debugPrint('DetectedAppIngest.handleDeepLink failed: $e\n$st');
    }
  }

  Future<void> _handleDetected(String appId, FrictionLevel level) async {
    final now = _clock.now();

    if (await _repo.countAttemptsSince(appId, now.subtract(_dedupWindow)) > 0) {
      return;
    }

    // Logged first as `notified` so the open is never lost; the gate replaces
    // this row with the user's answer (same id).
    final id = _uuid.v4();
    await _repo.logEvent(
      DistractionEvent(
        id: id,
        appPackageId: appId,
        level: level,
        action: ResolvedAction.notified,
        occurredAt: now,
        duringSession: _isSessionRunning(),
      ),
    );
    await _onIntervention(appId, eventId: id);
  }
}

final detectedAppIngestProvider = Provider<DetectedAppIngest>((ref) {
  return DetectedAppIngest(
    bridge: ref.watch(blockerBridgeProvider),
    repository: ref.watch(frictionRepositoryProvider),
    clock: ref.watch(clockProvider),
    isSessionRunning: () {
      final state = ref.read(focusSessionControllerProvider);
      return state is FocusRunning && !state.isPaused;
    },
    wasSessionRunningAt: (at) async {
      try {
        final state = ref.read(focusSessionControllerProvider);
        if (state is FocusRunning && !state.session.startedAt.isAfter(at)) {
          // Approximation: earlier pauses inside the session are ignored.
          final pausedAt = state.session.pausedAt;
          return pausedAt == null || !at.isAfter(pausedAt);
        }
        final finished = await ref.read(finishedSessionsProvider.future);
        return finished.any((s) {
          final end = s.endedAt;
          return end != null && !at.isBefore(s.startedAt) && !at.isAfter(end);
        });
      } catch (_) {
        return false;
      }
    },
    onIntervention: (appId, {eventId}) => ref
        .read(frictionGateControllerProvider.notifier)
        .onAttempt(appId, eventId: eventId),
  );
});
