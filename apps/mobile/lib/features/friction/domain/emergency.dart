import 'package:flutter/foundation.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';

@immutable
class EmergencyOverride {
  const EmergencyOverride({
    required this.id,
    required this.occurredAt,
    required this.windowEndsAt,
  });

  final String id;
  final DateTime occurredAt;
  final DateTime windowEndsAt;

  bool isActiveAt(DateTime now) => now.isBefore(windowEndsAt);
}

@immutable
class EmergencyQuota {
  const EmergencyQuota({required this.used, required this.limit});

  final int used;
  final int limit;

  int get remaining => (limit - used).clamp(0, limit);
  bool get exhausted => used >= limit;

  /// The user may lower/raise the monthly limit, but never past the ceiling
  /// and never below 1 (PRD §23.4 "hard ceiling").
  static int clampLimit(int value) =>
      value.clamp(1, FrictionRules.emergencyHardCeilingPerMonth);

  /// Local calendar month containing [now]: `[start, end)`.
  static (DateTime start, DateTime end) monthBounds(DateTime now) =>
      (DateTime(now.year, now.month), DateTime(now.year, now.month + 1));
}
