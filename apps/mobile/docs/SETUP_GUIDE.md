# Homeo mobile — placement & setup guide

Everything below is relative to your repo. The delivered folder `apps/mobile/`
maps 1-to-1 onto the `apps/mobile/` you created with
`flutter create apps/mobile --org com.cheapdopamine --project-name homeo`.

## A. Where every file goes

```
apps/mobile/   ← your project root (the folder `flutter create` made)
├── docs/
│   ├── NATIVE_SETUP.md                                                   # Android/iOS edits + native blocker contract (new)
│   └── SETUP_GUIDE.md                                                    # this guide (new)
├── lib/
│   ├── app/
│   │   ├── router/
│   │   │   ├── app_router.dart                                           # go_router: 5 tabs + /settings/friction  [generates .g.dart]
│   │   │   └── app_routes.dart                                           # route path constants
│   │   ├── shell/
│   │   │   └── app_shell.dart                                            # bottom nav, friction-gate overlay, long-press emergency
│   │   └── app.dart                                                      # MaterialApp.router, themes, l10n delegates
│   ├── core/
│   │   ├── local_db/
│   │   │   ├── tables/
│   │   │   │   ├── blocked_apps_table.dart                               # table: blocked_apps
│   │   │   │   ├── distraction_events_table.dart                         # table: distraction_events
│   │   │   │   ├── emergency_overrides_table.dart                        # table: emergency_overrides
│   │   │   │   ├── focus_sessions_table.dart                             # table: focus_sessions
│   │   │   │   ├── reflection_entries_table.dart                         # table: reflection_entries
│   │   │   │   └── user_settings_table.dart                              # table: user_settings
│   │   │   ├── app_database.dart                                         # Drift DB, schema v2, 6 tables  [generates .g.dart]
│   │   │   └── database_provider.dart                                    # DB provider  [generates .g.dart]
│   │   ├── security/
│   │   │   └── field_cipher.dart                                         # AES-256-GCM field encryption + key store  [generates .g.dart]
│   │   ├── theme/
│   │   │   ├── app_colors.dart                                           # PRD colour tokens, light/dark, WCAG-checked
│   │   │   ├── app_dimens.dart                                           # spacing + radius tokens
│   │   │   ├── app_text_styles.dart                                      # type scale (Inter + Noto Sans Thai fallback)
│   │   │   └── app_theme.dart                                            # ThemeData light/dark
│   │   ├── time/
│   │   │   └── clock.dart                                                # injectable clock  [generates .g.dart]
│   │   └── utils/
│   │       └── duration_format.dart                                      # formatClock / formatFocusDuration
│   ├── features/
│   │   ├── ai_coach/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── ai_coach_screen.dart                              # placeholder tab
│   │   ├── analytics/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── insights_screen.dart                              # placeholder tab
│   │   ├── focus_session/
│   │   │   ├── data/
│   │   │   │   ├── focus_session_repository.dart                         # Drift repo (encrypts reflections)  [generates .g.dart]
│   │   │   │   └── session_alarm.dart                                    # session-end notification  [generates .g.dart]
│   │   │   ├── domain/
│   │   │   │   ├── focus_rules.dart                                      # tunable focus constants
│   │   │   │   ├── focus_session.dart                                    # session entity + timestamp timer maths
│   │   │   │   ├── focus_session_state.dart                              # idle/setup/running/summary states
│   │   │   │   ├── focus_stats.dart                                      # home-screen numbers
│   │   │   │   ├── session_reflection.dart                               # mood / exit / streak-break enums
│   │   │   │   └── streak_calculator.dart                                # non-punishing streak + break detection
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── focus_session_controller.dart                     # session lifecycle controller  [generates .g.dart]
│   │   │       │   ├── focus_session_providers.dart                      # finishedSessions + focusStats  [generates .g.dart]
│   │   │       │   └── streak_recovery_providers.dart                    # streakBreak provider  [generates .g.dart]
│   │   │       ├── screens/
│   │   │       │   ├── active_session_view.dart                          # countdown, pause, exit, emergency link
│   │   │       │   ├── focus_home_view.dart                              # home: streak, start card, stats
│   │   │       │   ├── focus_screen.dart                                 # Focus tab root (phase switch)
│   │   │       │   ├── session_setup_view.dart                           # duration + intention
│   │   │       │   ├── session_summary_view.dart                         # result + mood
│   │   │       │   └── streak_recovery_view.dart                         # streak-break screen
│   │   │       └── widgets/
│   │   │           ├── duration_picker_sheet.dart                        # custom duration wheel
│   │   │           ├── exit_gate_sheet.dart                              # exit friction (reason + 5 s)
│   │   │           ├── pause_limit_sheet.dart                            # daily pause budget spent
│   │   │           ├── streak_card.dart                                  # current/best streak
│   │   │           └── timer_ring.dart                                   # circular countdown
│   │   ├── friction/
│   │   │   ├── data/
│   │   │   │   ├── blocker_bridge.dart                                   # native blocker channel contract  [generates .g.dart]
│   │   │   │   ├── friction_repository.dart                              # Drift repo: apps, events, emergencies  [generates .g.dart]
│   │   │   │   └── partner_gateway.dart                                  # Vault Partner seam (offline stub)  [generates .g.dart]
│   │   │   ├── domain/
│   │   │   │   ├── app_catalog.dart                                      # curated app list
│   │   │   │   ├── blocked_app.dart                                      # watch-list entity
│   │   │   │   ├── distraction_event.dart                                # log entity + ResolvedAction
│   │   │   │   ├── emergency.dart                                        # emergency override + monthly quota
│   │   │   │   ├── friction_level.dart                                   # L0–L4 enum
│   │   │   │   ├── friction_policy.dart                                  # escalation logic (pure)
│   │   │   │   └── friction_rules.dart                                   # friction constants (delays, windows, limits)
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── emergency_controller.dart                         # emergency unblock  [generates .g.dart]
│   │   │       │   ├── friction_gate_controller.dart                     # gate decision/resolution  [generates .g.dart]
│   │   │       │   └── friction_providers.dart                           # blockedApps + emergencyQuota  [generates .g.dart]
│   │   │       ├── screens/
│   │   │       │   ├── friction_gate_overlay.dart                        # L0–L4 gate UI
│   │   │       │   └── friction_settings_screen.dart                     # level, apps, quota, debug simulator
│   │   │       ├── widgets/
│   │   │       │   └── emergency_override_sheet.dart                     # emergency bottom sheet
│   │   │       └── friction_level_l10n.dart                              # level name/description strings
│   │   ├── settings/
│   │   │   ├── data/
│   │   │   │   └── settings_repository.dart                              # settings repo  [generates .g.dart]
│   │   │   ├── domain/
│   │   │   │   └── user_settings.dart                                    # settings entity
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── settings_screen.dart                              # Settings tab
│   │   └── vault_partner/
│   │       └── presentation/
│   │           └── screens/
│   │               └── vault_screen.dart                                 # placeholder tab
│   ├── l10n/
│   │   ├── app_en.arb                                                    # English strings
│   │   ├── app_th.arb                                                    # Thai strings (template, 129 keys)
│   │   └── l10n.dart                                                     # context.l10n helper
│   ├── shared/
│   │   └── widgets/
│   │       ├── choice_pill.dart                                          # single-choice chip
│   │       ├── placeholder_screen.dart                                   # stand-in for unbuilt tabs
│   │       └── remaining_builder.dart                                    # countdown builder driven by the clock
│   └── main.dart                                                         # entry point (REPLACES the generated file)
├── test/
│   ├── core/
│   │   └── security/
│   │       └── field_cipher_test.dart                                    # encryption tests
│   └── features/
│       ├── focus_session/
│       │   └── domain/
│       │       └── focus_domain_test.dart                                # timing, streak, break, stats tests
│       └── friction/
│           └── domain/
│               └── friction_domain_test.dart                             # policy + quota tests
├── tool/
│   ├── apply_native_config.dart                                          # patches AndroidManifest / gradle / AppDelegate automatically (new)
│   ├── setup.ps1                                                         # one-shot setup for Windows PowerShell (new)
│   └── setup.sh                                                          # one-shot setup for macOS/Linux/Git-Bash (new)
├── analysis_options.yaml                                                 # lint rules (REPLACES the generated file)
├── l10n.yaml                                                             # gen-l10n settings (new)
└── pubspec.yaml                                                          # dependencies + fonts + l10n switch (REPLACES the generated file)
```

**Rules**
1. Copy the *contents* of the delivered `apps/mobile/` **over** your `apps/mobile/` (merge, overwrite when asked).
   Three files replace ones `flutter create` generated: `pubspec.yaml`, `analysis_options.yaml`, `lib/main.dart`.
2. Do **not** touch `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`, `.metadata`, `.gitignore`.
3. Delete `test/widget_test.dart` (the default counter test; it references `MyApp` and would fail).
4. Do **not** create these by hand — tools generate them (section C):
   * 17 files `*.g.dart` next to the files marked `[generates .g.dart]`
   * `lib/l10n/gen/app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_th.dart`

## B. Prerequisites
* Flutter stable, recent. Hard minimum 3.32 (flutter_local_notifications 20); recommended: latest stable. Dart >= 3.9.
  Check with `flutter --version`; upgrade with `flutter upgrade`.
* Android: Android Studio + SDK, JDK 17. iOS (macOS only): Xcode + CocoaPods.
* `flutter doctor` must be green for the platform you run on.

## C. Steps after the files are in place

### C1. One command (recommended)
From `apps/mobile`:
* macOS / Linux / Git-Bash: `bash tool/setup.sh`
* Windows PowerShell: `.\tool\setup.ps1`

It runs, and stops at the first failure: version check → delete default test → native config patch → `flutter pub get` →
`flutter gen-l10n` → `dart run build_runner build --delete-conflicting-outputs` → `dart format` →
`flutter analyze --no-fatal-infos` → `flutter test`.

### C2. Same thing by hand
```
cd apps/mobile
rm test/widget_test.dart
dart tool/apply_native_config.dart
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze --no-fatal-infos
flutter test
```
Target: `flutter analyze` reports no errors (info-level lints are fine) and all 34 tests pass.

### C3. Native edits — now automatic (`dart tool/apply_native_config.dart`, already step 2 of the setup script)
The script below is what that patcher does; edit by hand only if it prints `! MANUAL`. Backups: `<file>.homeo.bak`.
Android — `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>   <!-- optional -->
<application android:allowBackup="false" ...>       <!-- see note below -->
    <receiver android:exported="false"
        android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
</application>
```
Android — `android/app/build.gradle.kts` (Groovy file: `coreLibraryDesugaringEnabled true` / `coreLibraryDesugaring '...'`)
```kotlin
android {
    compileOptions { isCoreLibraryDesugaringEnabled = true }
    defaultConfig { minSdk = maxOf(flutter.minSdkVersion, 23) }   // flutter_secure_storage needs >= 23
}
dependencies { coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") }
```
`allowBackup="false"` note: Android Auto-Backup can restore the database onto a new phone *without* the Keystore
key, which makes encrypted reflections unreadable. Turn backup off (or add backup rules) until you design that.

iOS — `ios/Runner/AppDelegate.swift`, inside `application(_:didFinishLaunchingWithOptions:)`:
```swift
UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
```
then `cd ios && pod install --repo-update`. If CocoaPods asks for a higher deployment target, raise `platform :ios` in `ios/Podfile`.

### C4. Optional — fonts
Put `Inter-{Regular,SemiBold,Bold}.ttf` and `NotoSansThai-{Regular,SemiBold,Bold}.ttf` in `assets/fonts/`,
then remove the `#` comments on the `fonts:` block at the bottom of `pubspec.yaml`. Without them the app uses system fonts.

### C5. Run
`flutter run` (Android emulator/device or iOS simulator). Notifications work on a real device/emulator with Google Play services;
the iOS simulator can show them too.

## D. Smoke test (10 minutes)
1. **Home**: greeting, "start a new streak today", start card, three stat tiles.
2. **Session**: Start → custom → 1 minute → Start. Ring counts down. Press Home button; after the minute a
   "Session complete" notification arrives (accept the permission prompt on the first session). Open the app → summary → pick a mood → Save.
3. **Pause budget**: pause/resume 3 times; the 4th pause opens the "used all pauses" sheet.
4. **Restore**: start a session, swipe the app away, reopen — the session is still running with the right time left.
5. **Exit gate**: "Leave session" → sheet; the leave button is disabled for 5 s. Back gesture opens this sheet too.
6. **Friction**: Settings → Friction → switch TikTok on. In debug builds a "Test" section appears:
   * L0 banner (auto-dismiss) · L1 confirm after 7 s · L2 needs a reason + 5 s · L3 full block (also happens whenever a session is running).
   * Tap the same simulate button 3 times within 10 minutes → the gate is one level stricter and says why.
7. **Emergency**: from an L3 gate → "Emergency?" → confirm → snackbar "Unblocked for 15 minutes"; simulate again → passes. After 3 uses this month
   the 4th shows the "used this month" text with 1669 / 191.  Long-press the tab bar opens the same sheet.
8. **Streak recovery**: needs 2+ completed days then a gap. Easiest: Android Studio → App Inspection → Database Inspector → `homeo` →
   `focus_sessions`; insert three rows (`status='completed'`, `started_at` = unix seconds of 5, 4 and 3 days ago,
   `planned_duration_sec=1500`, `actual_duration_sec=1500`, other columns 0/'' and `updated_at` set). Reopen: the recovery screen shows once.
9. Switch the phone language Thai ↔ English; switch light ↔ dark.

## E. How the pieces connect

**Layers (imports only go downward)**: `presentation` → `providers/controllers` → `data (repositories)` → `core/local_db`. `domain` is pure Dart and imports nothing from Flutter UI.

**Provider graph** (name → what it needs)
```
clockProvider, appDatabaseProvider, fieldCipherProvider          (core, no dependencies)
focusSessionRepositoryProvider   ← appDatabase, clock, fieldCipher
frictionRepositoryProvider       ← appDatabase, clock, fieldCipher
settingsRepositoryProvider       ← appDatabase, clock
sessionAlarmProvider, blockerBridgeProvider, partnerGatewayProvider   (platform seams)

focusSessionControllerProvider   ← focusSessionRepository, sessionAlarm, clock
focusImmersiveProvider           ← focusSessionController
finishedSessionsProvider → focusStatsProvider (+clock) → streakBreakProvider (+userSettingsProvider)
blockedAppsProvider, emergencyUsesThisMonthProvider → emergencyQuotaProvider (+userSettings)
emergencyControllerProvider      ← frictionRepository, settingsRepository, blockerBridge, clock
frictionGateControllerProvider   ← blockerBridge, frictionRepository, partnerGateway, blockedApps,
                                   emergencyController, focusSessionController, clock
```
**UI entry points**: `main.dart` → `HomeoApp` → `appRouterProvider` → `AppShell`.
`AppShell` watches `focusImmersiveProvider` and `frictionGateControllerProvider` (this is what starts the gate at launch);
`FocusScreen` watches the session phase and `streakBreakProvider`.

**Database (schema v2)**: focus_sessions, reflection_entries, blocked_apps, distraction_events, user_settings, emergency_overrides.
v1→v2 migration creates the four new tables. If you ever get a schema mismatch during development, uninstall the app once.

**Generated files (17)**: app_router, app_database, database_provider, field_cipher, clock, focus_session_repository, session_alarm,
focus_session_controller, focus_session_providers, streak_recovery_providers, blocker_bridge, friction_repository, partner_gateway,
emergency_controller, friction_gate_controller, friction_providers, settings_repository  (each `<name>.g.dart` beside its source).

### What was verified here (no Flutter/Dart SDK exists in the sandbox, so nothing was compiled)
A script checked all 72 Dart files: every `package:homeo/...` import resolves to a real file; every project symbol a file uses is imported
by it; all 21 `*Provider` names used exist; every `part` matches its file and its `@riverpod`/`@DriftDatabase` annotation; every third-party import is in
pubspec; bracket balance; the 129 ARB keys are identical in Thai/English, every `l10n.x(...)` call has the argument count the ARB declares and no
key is unused. The checker was mutation-tested (deliberately broken imports/keys/providers were all caught). Member names were scanned for typos
and the riskiest widget trees were re-read.
**Not verifiable without a compiler**: exact generated-code behaviour and third-party API details listed in F.

## F. Troubleshooting (most likely first)
| Symptom | Cause / fix |
|---|---|
| `pub get`: version solving failed | Flutter/Dart too old → `flutter upgrade`. Do not downgrade riverpod to 2.x: `drift_dev` (analyzer 13) and `riverpod_generator` 2.x (older analyzer) cannot resolve together. Try `flutter pub upgrade --major-versions`. |
| `Target of URI doesn't exist: 'package:homeo/l10n/gen/app_localizations.dart'` | gen-l10n has not written the files. Run `flutter gen-l10n`. If it warns about `synthetic-package`, delete that line in `l10n.yaml`. If files appear in `lib/l10n/` instead of `lib/l10n/gen/`, keep `output-dir: lib/l10n/gen` and rerun; as a last resort change the two imports in `lib/l10n/l10n.dart` to match. |
| `Target of URI hasn't been generated: '….g.dart'` | Run `dart run build_runner build --delete-conflicting-outputs`. Any build_runner error is shown once; fix it first, the others usually vanish. |
| `The method 'toCompanion' isn't defined for the type '…Row'` | Add `build.yaml` in `apps/mobile`: `targets:\n  $default:\n    builders:\n      drift_dev:\n        options:\n          data_class_to_companions: true` and rebuild. |
| Errors in `session_alarm.dart` about `initialize`, `zonedSchedule` or `cancel` parameters | Only this file talks to flutter_local_notifications. v20 uses named parameters (`settings:`, `id:`, `scheduledDate:`, `notificationDetails:`, `androidScheduleMode:`). Compare with the README of the version pub picked (`flutter pub deps | grep local_notifications`). |
| Gradle: "requires core library desugaring" | The patcher printed `! MANUAL` for gradle → do the C3 gradle step by hand. |
| Gradle: minSdk 21/22 vs 23 | Same: C3 `minSdk` line. |
| Manifest merger error on `POST_NOTIFICATIONS` | Put the `<uses-permission>` lines outside `<application>`. |
| iOS pod install fails | `cd ios && pod repo update && pod install`; raise `platform :ios` if asked. |
| `MissingPluginException` for `…/blocker` | Expected until the native blocker exists; the app catches it and carries on. |
| No notification | Permission denied (Settings → Apps), battery saver, or notification channel disabled. Emulators without Google APIs may not fire exact alarms; the app falls back to inexact (can be minutes late). |
| App crashes after you changed a table | Re-run build_runner; uninstall the app once (dev DB schema mismatch). |

## G. Not built yet (by design)
Native blocker (Kotlin/Swift), Vault Partner (L4 unlocks with it), partner notification after an emergency, protected hours, breathing exercise at L2,
Insights / AI Coach / Vault tabs, onboarding, auth, backend sync.
