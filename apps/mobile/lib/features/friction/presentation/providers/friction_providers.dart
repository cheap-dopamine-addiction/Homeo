import 'dart:async';

import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/emergency.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friction_providers.g.dart';

@Riverpod(keepAlive: true)
Stream<List<BlockedApp>> blockedApps(Ref ref) {
  return ref.watch(frictionRepositoryProvider).watchBlockedApps();
}

/// Emergency unblocks used this calendar month.
///
/// The `[from, to)` window is fixed when this provider is built, so a timer
/// re-builds it at 00:00 on the 1st; otherwise the "used x/y" display would
/// stay on last month's count until the app is restarted. (Enforcement is
/// unaffected — `EmergencyController.activate` always recounts from the DB.)
@Riverpod(keepAlive: true)
Stream<int> emergencyUsesThisMonth(Ref ref) {
  final now = ref.watch(clockProvider).now();
  final (from, to) = EmergencyQuota.monthBounds(now);

  final rollover = Timer(to.difference(now), ref.invalidateSelf);
  ref.onDispose(rollover.cancel);

  return ref.watch(frictionRepositoryProvider).watchEmergencyCount(from, to);
}

/// Used / limit for the current month, shown in the emergency sheet and in
/// Settings.
@Riverpod(keepAlive: true)
EmergencyQuota emergencyQuota(Ref ref) {
  final used = ref.watch(emergencyUsesThisMonthProvider).value ?? 0;
  final limit =
      ref.watch(userSettingsProvider).value?.emergencyLimitPerMonth ??
      FrictionRules.emergencyDefaultPerMonth;
  return EmergencyQuota(used: used, limit: limit);
}
