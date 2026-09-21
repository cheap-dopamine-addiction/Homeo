import 'package:flutter_test/flutter_test.dart';
import 'package:homeo/features/friction/domain/emergency.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/domain/friction_policy.dart';

FrictionDecision resolve(
  FrictionLevel base, {
  bool session = false,
  int burst = 0,
  int today = 0,
  bool partner = false,
}) {
  return FrictionPolicy.resolve(
    base: base,
    sessionRunning: session,
    priorAttemptsInBurstWindow: burst,
    priorAttemptsToday: today,
    partnerAvailable: partner,
  );
}

void main() {
  group('FrictionPolicy', () {
    test('uses the configured level when nothing escalates', () {
      final d = resolve(FrictionLevel.micro);
      expect(d.level, FrictionLevel.micro);
      expect(d.escalatedByBurst, isFalse);
      expect(d.attemptNumberToday, 1);
    });

    test('counts this attempt as "time N today"', () {
      expect(resolve(FrictionLevel.awareness, today: 4).attemptNumberToday, 5);
    });

    test('a running session forces L3', () {
      for (final base in [
        FrictionLevel.awareness,
        FrictionLevel.micro,
        FrictionLevel.reflective,
      ]) {
        expect(resolve(base, session: true).level, FrictionLevel.fullBlock);
      }
    });

    test('a burst raises the level by one step', () {
      // 2 earlier attempts + this one = 3 = threshold.
      final d = resolve(FrictionLevel.micro, burst: 2);
      expect(d.level, FrictionLevel.reflective);
      expect(d.escalatedByBurst, isTrue);
      expect(resolve(FrictionLevel.micro, burst: 1).level, FrictionLevel.micro);
    });

    test('a burst never escalates past L3 (L4 is opt-in only)', () {
      final d = resolve(FrictionLevel.reflective, burst: 5);
      expect(d.level, FrictionLevel.fullBlock);
      expect(
        resolve(FrictionLevel.fullBlock, burst: 5).level,
        FrictionLevel.fullBlock,
      );
    });

    test('L4 without a partner falls back to L3', () {
      expect(
        resolve(FrictionLevel.partnerGated).level,
        FrictionLevel.fullBlock,
      );
      expect(
        resolve(FrictionLevel.partnerGated, partner: true).level,
        FrictionLevel.partnerGated,
      );
    });

    test('only L0–L2 can be passed without emergency or partner', () {
      expect(FrictionLevel.reflective.canProceedSelf, isTrue);
      expect(FrictionLevel.fullBlock.canProceedSelf, isFalse);
      expect(FrictionLevel.partnerGated.canProceedSelf, isFalse);
    });

    test('level codes round-trip and clamp', () {
      for (final level in FrictionLevel.values) {
        expect(FrictionLevel.fromCode(level.code), level);
      }
      expect(FrictionLevel.fromCode(99), FrictionLevel.partnerGated);
      expect(FrictionLevel.fromCode(-3), FrictionLevel.awareness);
    });
  });

  group('EmergencyQuota', () {
    test('exhausted once used reaches the limit', () {
      expect(const EmergencyQuota(used: 2, limit: 3).exhausted, isFalse);
      expect(const EmergencyQuota(used: 3, limit: 3).exhausted, isTrue);
      expect(const EmergencyQuota(used: 5, limit: 3).remaining, 0);
    });

    test('limit is clamped between 1 and the hard ceiling', () {
      expect(EmergencyQuota.clampLimit(0), 1);
      expect(EmergencyQuota.clampLimit(3), 3);
      expect(EmergencyQuota.clampLimit(999), 10);
    });

    test('month bounds cover the calendar month, including December', () {
      final (start, end) = EmergencyQuota.monthBounds(
        DateTime(2026, 9, 20, 15),
      );
      expect(start, DateTime(2026, 9));
      expect(end, DateTime(2026, 10));

      final (decStart, decEnd) = EmergencyQuota.monthBounds(
        DateTime(2026, 12, 31),
      );
      expect(decStart, DateTime(2026, 12));
      expect(decEnd, DateTime(2027));
    });

    test('an override is active only inside its window', () {
      final start = DateTime(2026, 9, 20, 10);
      final override = EmergencyOverride(
        id: 'a',
        occurredAt: start,
        windowEndsAt: start.add(const Duration(minutes: 15)),
      );
      expect(
        override.isActiveAt(start.add(const Duration(minutes: 14))),
        isTrue,
      );
      expect(
        override.isActiveAt(start.add(const Duration(minutes: 15))),
        isFalse,
      );
    });
  });
}
