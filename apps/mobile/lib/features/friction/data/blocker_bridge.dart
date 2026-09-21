import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocker_bridge.g.dart';

/// Contract with the native (Kotlin / Swift) blocker.
///
/// Dart owns *policy* (which friction, logging, quotas); native owns
/// *enforcement* (noticing an app launch, keeping it blocked). Channel
/// `com.cheapdopamine.homeo/blocker`:
///
///  native → Dart
///    `onAttempt(String packageId)` — the user tried to open a watched app.
///  Dart → native
///    `syncBlockedApps(List<String>)` — the current watch list.
///    `allow({packageId, seconds})`   — let this app through for a while.
///    `allowAll({seconds})`           — emergency: let everything through.
///    `returnHome()`                  — leave the blocked app (go to home).
///
/// Until the native side ships, calls are no-ops (MissingPluginException is
/// swallowed) and nothing emits on [attempts] — the debug simulator in
/// Settings ▸ Friction drives the gate instead.
///
/// Native design note: the blocker must keep working with the Flutter engine
/// stopped, and enforce the last synced list itself. `attempts` only reaches
/// Dart when the engine is alive.
abstract interface class BlockerBridge {
  Stream<String> get attempts;
  Future<void> syncBlockedApps(List<String> packageIds);
  Future<void> allow(String packageId, Duration window);
  Future<void> allowAll(Duration window);
  Future<void> returnHome();
}

class MethodChannelBlockerBridge implements BlockerBridge {
  MethodChannelBlockerBridge() {
    _channel.setMethodCallHandler(_onCall);
  }

  static const _channel = MethodChannel('com.cheapdopamine.homeo/blocker');

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

  Future<void> _invoke(String method, [Object? arguments]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on MissingPluginException {
      // Native blocker not shipped yet.
    } on PlatformException catch (e) {
      debugPrint('BlockerBridge.$method failed: ${e.message}');
    }
  }

  @override
  Future<void> syncBlockedApps(List<String> packageIds) =>
      _invoke('syncBlockedApps', packageIds);

  @override
  Future<void> allow(String packageId, Duration window) =>
      _invoke('allow', {'packageId': packageId, 'seconds': window.inSeconds});

  @override
  Future<void> allowAll(Duration window) =>
      _invoke('allowAll', {'seconds': window.inSeconds});

  @override
  Future<void> returnHome() => _invoke('returnHome');
}

@Riverpod(keepAlive: true)
BlockerBridge blockerBridge(Ref ref) => MethodChannelBlockerBridge();
