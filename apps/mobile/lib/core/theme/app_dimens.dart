/// Border-radius tokens for the Homeo app.
class AppRadius {
  const AppRadius._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double full = 999;

  // Semantic aliases
  static const double button = md;
  static const double card = lg;
  static const double bottomSheet = xl;
  static const double dialog = xl;
  static const double chip = full;
  static const double inputField = sm;
}

/// Spacing tokens (padding / margin / gap) for the Homeo app.
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Semantic aliases
  static const double screenHorizontal = lg;
  static const double screenVertical = lg;
  static const double sectionGap = xxl;
  static const double itemGap = md;
}
