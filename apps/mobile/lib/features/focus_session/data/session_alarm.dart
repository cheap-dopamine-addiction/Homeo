import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

part 'session_alarm.g.dart';

/// "Your session is over" while the app is in the background.
///
/// The countdown itself never depends on this (it is derived from
/// timestamps); this only makes the phone tell you. Best effort: a failure
/// here must never break a session.
abstract interface class SessionAlarm {
  Future<void> schedule({
    required DateTime at,
    required Duration focusDuration,
  });
  Future<void> cancel();
}

class NoopSessionAlarm implements SessionAlarm {
  const NoopSessionAlarm();

  @override
  Future<void> schedule({
    required DateTime at,
    required Duration focusDuration,
  }) async {}

  @override
  Future<void> cancel() async {}
}

class LocalNotificationSessionAlarm implements SessionAlarm {
  static const int _notificationId = 4001;
  static const String _channelId = 'focus_session_end';

  /// Fires a moment *after* the true end so that, when the app is in the
  /// foreground, the in-app finish can cancel it first (no double alert).
  static const Duration _graceAfterEnd = Duration(seconds: 1);

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initialised;
  bool _permissionRequested = false;

  Future<void> _ensureInitialised() => _initialised ??= _initialise();

  Future<void> _initialise() async {
    // An absolute instant is all we schedule, so UTC is enough — no device
    // time-zone lookup needed. (The tz database must still be loaded once.)
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested in context (first session), not at launch.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  Future<void> _requestPermissionOnce() async {
    if (_permissionRequested) return;
    _permissionRequested = true;
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: false, sound: true);
  }

  /// Notifications are shown without a BuildContext, so pick the language
  /// from the device locale (falling back to English).
  AppLocalizations _l10n() {
    final device = PlatformDispatcher.instance.locale;
    final supported = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == device.languageCode,
    );
    return lookupAppLocalizations(
      supported ? Locale(device.languageCode) : const Locale('en'),
    );
  }

  @override
  Future<void> schedule({
    required DateTime at,
    required Duration focusDuration,
  }) async {
    try {
      await _ensureInitialised();
      final fireAt = at.add(_graceAfterEnd);
      if (!fireAt.isAfter(DateTime.now())) return;

      await _requestPermissionOnce();

      // Exact alarms need a permission that Android 14+ denies by default;
      // fall back to inexact (may be a few minutes late in Doze) instead of
      // sending the user to Settings.
      final canBeExact =
          await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.canScheduleExactNotifications() ??
          false;

      final l10n = _l10n();
      await _plugin.zonedSchedule(
        id: _notificationId,
        title: l10n.alarmTitle,
        body: l10n.alarmBody(formatFocusDuration(l10n, focusDuration)),
        scheduledDate: tz.TZDateTime.from(fireAt, tz.getLocation('UTC')),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            l10n.alarmChannelName,
            channelDescription: l10n.alarmChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canBeExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('SessionAlarm.schedule failed: $e');
    }
  }

  @override
  Future<void> cancel() async {
    try {
      await _ensureInitialised();
      await _plugin.cancel(id: _notificationId);
    } catch (e) {
      debugPrint('SessionAlarm.cancel failed: $e');
    }
  }
}

@Riverpod(keepAlive: true)
SessionAlarm sessionAlarm(Ref ref) => LocalNotificationSessionAlarm();
