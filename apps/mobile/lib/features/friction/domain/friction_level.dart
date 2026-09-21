/// Adaptive friction ladder — PRD §11.2.
enum FrictionLevel {
  /// L0: a quiet banner, then the app opens.
  awareness,

  /// L1: short delay, then "yes, really".
  micro,

  /// L2: say why, short delay, then open.
  reflective,

  /// L3: blocked. Only an emergency unblock opens it.
  fullBlock,

  /// L4: needs a Vault Partner's approval (opt-in).
  partnerGated;

  /// Stable number stored in the DB (0–4).
  int get code => index;

  static FrictionLevel fromCode(int code) =>
      values[code.clamp(0, values.length - 1)];

  /// True for levels the user can pass without an emergency/partner.
  bool get canProceedSelf => index <= FrictionLevel.reflective.index;
}
