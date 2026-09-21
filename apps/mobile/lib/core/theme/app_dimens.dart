import 'package:flutter/painting.dart';

/// Spacing scale — PRD §12.2 (8pt grid: 4 / 8 / 12 / 16 / 24 / 32 / 48).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Corner radius — PRD §12.2 (card 12 / button 8 / pill 999).
abstract final class AppRadius {
  static const double card = 12;
  static const double button = 8;
  static const double pill = 999;
  static const double sheet = 24;

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );
}
