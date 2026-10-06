import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocker_bridge.g.dart';

/// One "watched app was opened" record captured natively (Android) while the
/// Flutter engine may have been asleep.
@immutable
class NativeDistractionOpen {
  const NativeDistractionOpen({
    required this.packageId,
    required this.timestampMs,
  });

  final String packageId;

  /// Epoch milliseconds.
  final int timestampMs;
}

/// Contract with the native (Kotlin / Swift) side.
///
/// Scope: **warning only — nothing is ever blocked or killed.** Native
/// *detects* a watched app coming to the foreground, notifies the user, and
/// keeps a queue of events; Dart owns policy and the local DB.
///
/// Channel `com.cheapdopamine.homeo/friction`
///
///  Dart → native
///    `isAccessibilityEnabled() → bool`
///    `openAccessibilitySettings()`
///    `setBlockedPackages(List<String>)` — stored in `FlutterSharedPreferences`
///        under `flutter.blocked_packages`, read by the accessibility service.
///    `drainPendingEvents() → List<{app, ts}>` — events not yet imported.
///    `ackPendingEvents({upTo})` — remove events with `ts <= upTo` (call only
///        after they are safely in the DB).
///    `isIgnoringBatteryOptimizations() → bool`
///    `requestIgnoreBatteryOptimizations()`
///    `allow({packageId, seconds})` / `allowAll({seconds})` — mute warnings.
///    `returnHome()` — go to the launcher (user pressed "back to focus").
///  native → Dart
///    `onAttempt(String packageId)` — optional; only used by the debug gate.
///
/// Every call is a no-op / default on platforms without the native half
/// (iOS, tests): MissingPluginException is swallowed.
abstract interface class BlockerBridge {
  Stream<String> get attempts;
  Future<bool> isAccessibilityEnabled();
  Future<void> openAccessibilitySettings();
  Future<bool> isIgnoringBatteryOptimizations();
  Future<void> requestIgnoreBatteryOptimizations();
  Future<void> syncBlockedApps(List<String> packageIds);
  Future<List<NativeDistractionOpen>> drainPendingEvents();
  Future<void> ackPendingEvents({required int upTo});
  Future<void> allow(String packageId, Duration window);
  Future<void> allowAll(Duration window);
  Future<void> returnHome();
}

class MethodChannelBlockerBridge implements BlockerBridge {
  MethodChannelBlockerBridge() {
    _channel.setMethodCallHandler(_onCall);
  }

  static const _channel = MethodChannel('com.cheapdopamine.homeo/friction');

  final _attempts = StreamController<String>.broadcast();

  @override
  Stream<String> get attempts => _attempts.stream;

  Future<dynamic> _onCall(MethodCall call) async {
    if (call.method == 'onAttempt') {
      final id = call.arguments;
      if (id is String && id.isNotEmpty) _attempts.add(id);
    }
    return null;
  }

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      return null; // native half not available on this platform
    } on PlatformException catch (e) {
      debugPrint('BlockerBridge.$method failed: ${e.message}');
      return null;
    }
  }

  @override
  Future<bool> isAccessibilityEnabled() async =>
      await _invoke<bool>('isAccessibilityEnabled') ?? false;

  @override
  Future<void> openAccessibilitySettings() =>
      _invoke<void>('openAccessibilitySettings');

  @override
  Future<bool> isIgnoringBatteryOptimizations() async =>
      await _invoke<bool>('isIgnoringBatteryOptimizations') ?? false;

  @override
  Future<void> requestIgnoreBatteryOptimizations() =>
      _invoke<void>('requestIgnoreBatteryOptimizations');

  @override
  Future<void> syncBlockedApps(List<String> packageIds) =>
      _invoke<void>('setBlockedPackages', packageIds);

  @override
  Future<List<NativeDistractionOpen>> drainPendingEvents() async {
    final raw = await _invoke<List<Object?>>('drainPendingEvents');
    if (raw == null) return const [];

    final events = <NativeDistractionOpen>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final app = item['app'];
      final ts = item['ts'];
      if (app is String && app.isNotEmpty && ts is int) {
        events.add(NativeDistractionOpen(packageId: app, timestampMs: ts));
      }
    }
    return events;
  }

  @override
  Future<void> ackPendingEvents({required int upTo}) =>
      _invoke<void>('ackPendingEvents', {'upTo': upTo});

  @override
  Future<void> allow(String packageId, Duration window) => _invoke<void>(
    'allow',
    {'packageId': packageId, 'seconds': window.inSeconds},
  );

  @override
  Future<void> allowAll(Duration window) =>
      _invoke<void>('allowAll', {'seconds': window.inSeconds});

  @override
  Future<void> returnHome() => _invoke<void>('returnHome');
}

@Riverpod(keepAlive: true)
BlockerBridge blockerBridge(Ref ref) => MethodChannelBlockerBridge();
