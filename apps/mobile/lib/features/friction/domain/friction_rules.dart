/// Tunable friction constants. Numbers with a PRD reference follow it; the
/// rest are product defaults chosen here — flagged so they can be revisited.
abstract final class FrictionRules {
  /// PRD §11.2 L1: "5–10 seconds".
  static const Duration microDelay = Duration(seconds: 7);

  /// Wireframe PRD §13.4 (L2 "เปิดต่อ (5s)").
  static const Duration reflectiveDelay = Duration(seconds: 5);

  static const int minReasonLength = 3;

  /// L0 banner auto-dismiss (prototype: 3.5 s).
  static const Duration awarenessBannerDuration = Duration(milliseconds: 3500);

  /// PRD §11.3 burst detection — thresholds are a product default.
  static const Duration burstWindow = Duration(minutes: 10);
  static const int burstThreshold = 3;

  /// After passing a gate the app stays open this long before it is gated
  /// again. Product default.
  static const Duration allowWindow = Duration(minutes: 5);

  /// PRD §23.4: 3 per month by default, adjustable with a hard ceiling.
  static const int emergencyDefaultPerMonth = 3;
  static const int emergencyHardCeilingPerMonth = 10;

  /// How long an emergency unblock lasts. Product default.
  static const Duration emergencyWindow = Duration(minutes: 15);

  /// PRD §10.2: cooling-off 10–30 min when the partner does not answer.
  static const Duration partnerCoolingOff = Duration(minutes: 20);
}
