import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/notifications/notification_service.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/friction/data/blocker_bridge.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:uuid/uuid.dart';

/// Turns "a watched app was opened" signals into `distraction_events` rows
/// (offline-first, PRD §9.3) — warning only, nothing is blocked.
///
///  * Android: the accessibility service already showed the notification and
///    queued the event natively; [ingestPending] imports the queue.
///  * iOS: a Shortcuts automation opens `homeo://distraction-event?app=<id>`;
///    [handleDeepLink] logs it and shows the notification.
class DetectedAppIngest {
  DetectedAppIngest({
    required BlockerBridge bridge,
    required FrictionRepository repository,
    required Clock clock,
    required NotificationService notifications,
    required bool Function() isSessionRunning,
  }) : _bridge = bridge,
       _repo = repository,
       _clock = clock,
       _notifications = notifications,
       _isSessionRunning = isSessionRunning;

  static const _uuid = Uuid();
  static const _scheme = 'homeo';
  static const _host = 'distraction-event';

  final BlockerBridge _bridge;
  final FrictionRepository _repo;
  final Clock _clock;
  final NotificationService _notifications;
  final bool Function() _isSessionRunning;

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
        final blocked = await _repo.findBlockedApp(event.packageId);
        await _repo.logEvent(
          DistractionEvent(
            id: 'native_${event.timestampMs}_${event.packageId}',
            appPackageId: event.packageId,
            level: blocked?.level ?? FrictionLevel.awareness,
            action: ResolvedAction.notified,
            occurredAt: DateTime.fromMillisecondsSinceEpoch(event.timestampMs),
            // Native cannot know about focus sessions.
            duringSession: false,
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

  /// `homeo://distraction-event?app=<app_id>` (iOS Shortcuts). Anything else is
  /// ignored.
  Future<void> handleDeepLink(Uri uri) async {
    if (uri.scheme != _scheme || uri.host != _host) return;
    final appId = uri.queryParameters['app']?.trim();
    if (appId == null || appId.isEmpty) return;

    try {
      final now = _clock.now();
      final blocked = await _repo.findBlockedApp(appId);
      await _repo.logEvent(
        DistractionEvent(
          id: _uuid.v4(),
          appPackageId: appId,
          level: blocked?.level ?? FrictionLevel.awareness,
          action: ResolvedAction.notified,
          occurredAt: now,
          duringSession: _isSessionRunning(),
        ),
      );

      // Counted after the insert, so this open is "time N today".
      final count = await _repo.countAttemptsSince(
        appId,
        DateTime(now.year, now.month, now.day),
      );
      await _notifications.showAppOpenedWarningNotification(
        appName: AppCatalog.nameOf(appId),
        count: count,
      );
    } catch (e, st) {
      debugPrint('DetectedAppIngest.handleDeepLink failed: $e\n$st');
    }
  }
}

final detectedAppIngestProvider = Provider<DetectedAppIngest>((ref) {
  return DetectedAppIngest(
    bridge: ref.watch(blockerBridgeProvider),
    repository: ref.watch(frictionRepositoryProvider),
    clock: ref.watch(clockProvider),
    notifications: ref.watch(notificationServiceProvider),
    isSessionRunning: () {
      final state = ref.read(focusSessionControllerProvider);
      return state is FocusRunning && !state.isPaused;
    },
  );
});
