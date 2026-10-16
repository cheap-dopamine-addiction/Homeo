import 'dart:io' show Platform;
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

part 'notification_service.g.dart';

/// Shared notification wrapper for Android + iOS (PRD §20).
///
/// * app-opened warning (iOS deep link path; Android fires natively from
///   Kotlin so it also works with the Flutter engine dead),
/// * focus started / completed,
/// * weekly summary (repeating),
/// * "time check": a gentle check-in some minutes after the user chose to
///   carry on from a gate.
///
/// Every method is best effort: a notification problem must never break a
/// session or the gate, so failures are logged and swallowed. Notifications
/// are shown without a BuildContext, so the language comes from the device
/// locale (falling back to English).
class NotificationService {
  // 4001 is taken by the session-end alarm (session_alarm.dart).
  static const int _focusStartedId = 4002;
  static const int _focusCompletedId = 4003;
  static const int _weeklySummaryId = 4010;
  static const int _timeCheckId = 4020;
  static const int _appOpenedBaseId = 5000;

  static const String _focusChannelId = 'focus_session_events';
  static const String _appOpenedChannelId = 'app_opened_warning';
  static const String _weeklyChannelId = 'weekly_summary';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initialised;

  Future<void> init() async {
    await (_initialised ??= _initialise());
  }

  Future<void> _initialise() async {
    // Only absolute instants are scheduled, so UTC is enough (same approach as
    // the session alarm). Thailand has no DST, so a weekly repeat stays put.
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested in context (setup screen), not at launch.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  /// Android 13+ `POST_NOTIFICATIONS` via permission_handler; iOS via the
  /// plugin (so no Podfile permission macros are needed). Without it Android
  /// drops notifications silently.
  Future<bool> requestPermission() async {
    try {
      await init();
      if (Platform.isAndroid) {
        return (await Permission.notification.request()).isGranted;
      }
      if (Platform.isIOS) {
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >()
                ?.requestPermissions(alert: true, badge: false, sound: true) ??
            false;
      }
    } catch (e) {
      debugPrint('NotificationService.requestPermission failed: $e');
    }
    return false;
  }

  Future<bool> hasPermission() async {
    try {
      if (Platform.isAndroid) return await Permission.notification.isGranted;
      if (Platform.isIOS) {
        await init();
        final settings = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return settings?.isEnabled ?? false;
      }
    } catch (e) {
      debugPrint('NotificationService.hasPermission failed: $e');
    }
    return false;
  }

  // ── Notifications ────────────────────────────────────────────────────────

  Future<void> showFocusStartedNotification(Duration duration) async {
    await _guard('focusStarted', () async {
      await init();
      final l10n = _l10n();
      await _plugin.show(
        id: _focusStartedId,
        title: l10n.notifFocusStartedTitle,
        body: l10n.notifFocusStartedBody(formatFocusDuration(l10n, duration)),
        notificationDetails: _details(
          channelId: _focusChannelId,
          channelName: l10n.notifChannelFocusName,
          channelDescription: l10n.notifChannelFocusDesc,
          importance: Importance.low,
          priority: Priority.low,
          presentSound: false,
        ),
      );
    });
  }

  Future<void> showFocusCompletedNotification(Duration duration) async {
    await _guard('focusCompleted', () async {
      await init();
      final l10n = _l10n();
      await _plugin.show(
        id: _focusCompletedId,
        title: l10n.notifFocusDoneTitle,
        body: l10n.notifFocusDoneBody(formatFocusDuration(l10n, duration)),
        notificationDetails: _details(
          channelId: _focusChannelId,
          channelName: l10n.notifChannelFocusName,
          channelDescription: l10n.notifChannelFocusDesc,
        ),
      );
    });
  }

  /// "Opening TikTok: time 3 today". Kept for callers that still want a plain
  /// banner; the iOS Shortcuts path now shows the gate directly instead.
  Future<void> showAppOpenedWarningNotification({
    required String appName,
    required int count,
  }) async {
    await _guard('appOpened', () async {
      await init();
      final l10n = _l10n();
      await _plugin.show(
        // One slot per app, so repeated opens replace instead of piling up.
        id: _appOpenedBaseId + (appName.hashCode.abs() % 1000),
        title: l10n.notifAppOpenedTitle(appName, count),
        body: l10n.notifAppOpenedBody,
        notificationDetails: _details(
          channelId: _appOpenedChannelId,
          channelName: l10n.notifChannelAppOpenedName,
          channelDescription: l10n.notifChannelAppOpenedDesc,
        ),
      );
    });
  }

  /// Gentle check-in at [at]: "Still on TikTok? It has been N minutes since
  /// you chose to continue." Neutral tone, no shaming (PRD §12.4). One slot,
  /// so a newer check-in replaces an older one.
  ///
  /// Strings are inline Thai/English (not ARB) so no `gen-l10n` run is needed;
  /// move them into the ARB files when convenient.
  Future<void> scheduleTimeCheck({
    required String appName,
    required DateTime at,
    required int minutes,
  }) async {
    await _guard('timeCheck', () async {
      await init();
      final l10n = _l10n();
      final thai = l10n.localeName == 'th';
      await _plugin.zonedSchedule(
        id: _timeCheckId,
        title: thai ? 'ยังอยู่ใน $appName ไหม?' : 'Still on $appName?',
        body: thai
            ? 'ผ่านไป $minutes นาทีแล้วตั้งแต่คุณเลือกเปิดต่อ — นี่คือการใช้เวลาที่คุณต้องการไหม?'
            : 'It has been $minutes minutes since you chose to continue. '
                  'Is this how you want to spend your time?',
        scheduledDate: tz.TZDateTime.from(at, tz.getLocation('UTC')),
        notificationDetails: _details(
          channelId: _appOpenedChannelId,
          channelName: l10n.notifChannelAppOpenedName,
          channelDescription: l10n.notifChannelAppOpenedDesc,
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    });
  }

  Future<void> cancelTimeCheck() async {
    await _guard('cancelTimeCheck', () async {
      await init();
      await _plugin.cancel(id: _timeCheckId);
    });
  }

  /// Repeats every Sunday at 20:00 (device local time).
  Future<void> scheduleWeeklySummary() async {
    await _guard('weeklySummary', () async {
      await init();
      final l10n = _l10n();

      final now = DateTime.now();
      var next = DateTime(
        now.year,
        now.month,
        now.day + (DateTime.sunday - now.weekday) % 7,
        20,
      );
      if (!next.isAfter(now)) {
        next = DateTime(next.year, next.month, next.day + 7, 20);
      }

      await _plugin.zonedSchedule(
        id: _weeklySummaryId,
        title: l10n.notifWeeklyTitle,
        body: l10n.notifWeeklyBody,
        scheduledDate: tz.TZDateTime.from(next, tz.getLocation('UTC')),
        notificationDetails: _details(
          channelId: _weeklyChannelId,
          channelName: l10n.notifChannelWeeklyName,
          channelDescription: l10n.notifChannelWeeklyDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        // Inexact: exact alarms need a permission Android 14+ denies by
        // default, and a few minutes of drift is fine for a weekly summary.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    });
  }

  Future<void> cancelWeeklySummary() async {
    await _guard('cancelWeekly', () async {
      await _plugin.cancel(id: _weeklySummaryId);
    });
  }

  // ── Internals ────────────────────────────────────────────────────────────

  NotificationDetails _details({
    required String channelId,
    required String channelName,
    required String channelDescription,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
    bool presentSound = true,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: presentSound,
      ),
    );
  }

  AppLocalizations _l10n() {
    final device = PlatformDispatcher.instance.locale;
    final supported = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == device.languageCode,
    );
    return lookupAppLocalizations(
      supported ? Locale(device.languageCode) : const Locale('en'),
    );
  }

  Future<void> _guard(String label, Future<void> Function() task) async {
    try {
      await task();
    } catch (e) {
      debugPrint('NotificationService.$label failed:$e');
    }
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService();
}
