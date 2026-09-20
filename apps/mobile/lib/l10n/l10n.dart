import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ---------------------------------------------------------------------------
// If you use flutter gen-l10n (recommended), this file is auto-generated.
// Until then this stub satisfies the `context.l10n` usage in app_shell.dart
// while keeping the build clean.
// ---------------------------------------------------------------------------

/// Supported locales for the app.
const kSupportedLocales = [Locale('en'), Locale('th')];

/// Standard Material + Cupertino + Widgets localisation delegates.
const kLocalizationDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

// ---------------------------------------------------------------------------
// Minimal AppLocalizations stub
// ---------------------------------------------------------------------------
// Replace the stub below with the real generated class once you run
// `flutter gen-l10n`.  The BuildContext extension stays the same either way.

/// Provides localised strings.
///
/// Add new keys here and in the corresponding `.arb` files.
class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // ---------- Tab labels ----------
  String get tabFocus => _resolve(en: 'Focus', th: 'โฟกัส');
  String get tabVault => _resolve(en: 'Vault', th: 'คลัง');
  String get tabInsights => _resolve(en: 'Insights', th: 'ข้อมูล');
  String get tabAiCoach => _resolve(en: 'AI Coach', th: 'โค้ช AI');
  String get tabSettings => _resolve(en: 'Settings', th: 'ตั้งค่า');

  // ---------- Focus session ----------
  String get startSession => _resolve(en: 'Start Session', th: 'เริ่มเซสชัน');
  String get endSession => _resolve(en: 'End Session', th: 'จบเซสชัน');
  String get sessionComplete =>
      _resolve(en: 'Session Complete!', th: 'เซสชันเสร็จแล้ว!');

  // ---------- Helpers ----------
  String _resolve({required String en, required String th}) =>
      locale.languageCode == 'th' ? th : en;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'th'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

// ---------------------------------------------------------------------------
// BuildContext extension — used as `context.l10n.tabFocus` etc.
// ---------------------------------------------------------------------------

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
