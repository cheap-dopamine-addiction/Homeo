import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/friction/data/blocker_bridge.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/domain/emergency.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'emergency_controller.g.dart';

enum EmergencyOutcome { granted, limitReached, ignored }

@immutable
class EmergencyState {
  const EmergencyState({this.windowEndsAt});

  /// While `now < windowEndsAt` nothing is gated.
  final DateTime? windowEndsAt;

  bool isActiveAt(DateTime now) {
    final ends = windowEndsAt;
    return ends != null && now.isBefore(ends);
  }
}

/// Emergency unblock (PRD §9.7): separate from partner approval, so it can
/// never be the thing standing between someone and a real emergency — but
/// rate-limited per month so it cannot become the everyday way around the
/// blocker (PRD §23.4).
@Riverpod(keepAlive: true)
class EmergencyController extends _$EmergencyController {
  static const _uuid = Uuid();

  bool _busy = false;

  @override
  EmergencyState build() {
    unawaited(_restoreWindow());
    return const EmergencyState();
  }

  /// A window granted just before the app was killed still applies.
  Future<void> _restoreWindow() async {
    final latest = await ref.read(frictionRepositoryProvider).latestEmergency();
    if (!ref.mounted || latest == null) return;
    if (latest.isActiveAt(ref.read(clockProvider).now())) {
      state = EmergencyState(windowEndsAt: latest.windowEndsAt);
    }
  }

  Future<EmergencyOutcome> activate() async {
    if (_busy) return EmergencyOutcome.ignored;
    _busy = true;
    try {
      final repo = ref.read(frictionRepositoryProvider);
      final now = ref.read(clockProvider).now();
      final settings = await ref.read(settingsRepositoryProvider).load();

      // Count fresh from the DB, not from a possibly stale provider.
      final (from, to) = EmergencyQuota.monthBounds(now);
      final used = await repo.countEmergencies(from, to);
      final quota = EmergencyQuota(
        used: used,
        limit: settings.emergencyLimitPerMonth,
      );
      if (quota.exhausted) return EmergencyOutcome.limitReached;

      final override = EmergencyOverride(
        id: _uuid.v4(),
        occurredAt: now,
        windowEndsAt: now.add(FrictionRules.emergencyWindow),
      );
      await repo.recordEmergency(override);
      await ref
          .read(blockerBridgeProvider)
          .allowAll(FrictionRules.emergencyWindow);

      if (ref.mounted) {
        state = EmergencyState(windowEndsAt: override.windowEndsAt);
      }
      return EmergencyOutcome.granted;
    } finally {
      _busy = false;
    }
  }
}
