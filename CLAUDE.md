# Homeo (dopamine-focus) — Claude Code guide

Homeo is a Flutter app (iOS + Android) that helps people cut back on dopamine-driven
apps and build focus. It uses friction, reflection, and (later) a Vault Partner.
Read `PRD.md` for product intent. This file covers how to work in the code.

Thai is the primary audience language. English is also supported. Every
user-facing string must exist in both locales.

## Repo layout

- `apps/mobile/`: Flutter app (the only app with code so far).
- `apps/backend/`: NestJS, planned, not present yet. Sync is not implemented.
- `PRD.md`: product requirements. Section numbers (for example, "PRD §11.2") are
  referenced in code comments. Keep them accurate.
- Feature-first layout under `apps/mobile/lib/features/<feature>/{data,domain,presentation}`.
  Shared code lives in `core/` (theme, local_db, time, security, notifications, utils),
  `shared/widgets/`, `app/` (router, shell, boot), and `l10n/`.

## Commands

Run from `apps/mobile/`:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Riverpod + Drift codegen
dart run build_runner watch -d                              # while iterating
flutter gen-l10n                                            # after editing any .arb
flutter analyze
flutter test
flutter run
```

Accessibility Service, battery optimisation, and notification behaviour only work on
real devices. Do not treat emulator results as proof for those features.

## Architecture

**State: Riverpod with code generation.** Use `@Riverpod(...)` annotations and let
`build_runner` generate `*.g.dart`. Current code uses Riverpod 3 APIs (`ref.mounted`,
`$FunctionalProvider`). The PRD says "Riverpod 2.x", but the code is authoritative.

- Long-lived app state uses `keepAlive: true`. Examples: the focus controller, the
  friction gate, the database, and the clock.
- Use `ref.mounted` before touching `state` after an `await`.
- Use `ref.read` inside methods and `ref.watch` inside `build`.

**Data: local-first with Drift (SQLite).** The UI talks only to repositories
(`FocusSessionRepository`, `FrictionRepository`, `SettingsRepository`). Repositories
talk only to `AppDatabase`. Sync to the backend is a future background job that pushes
rows where `synced_at IS NULL`. Every mutation writes locally first.

**Time: always through `Clock`.** Read time via `clockProvider` (`core/time/clock.dart`),
never `DateTime.now()`, so behavioural tests can control it (PRD §30.3). Some existing
code still calls `DateTime.now()` (`session_alarm.dart`, `notification_service.dart`).
Do not copy that pattern into new code.

**Timers are derived from timestamps.** `FocusSession` computes remaining time from
`startedAt`, `pausedTotal`, and `pausedAt`. Tickers only decide when to re-render. Do
not decrement counters.

**Generated code is read-only.** Never hand-edit these files:
- `*.g.dart` (Riverpod and Drift)
- `lib/l10n/gen/*`

Edit the source (`.dart` for providers and tables, `.arb` for strings) and regenerate.

## Database (Drift)

- Tables: `focus_sessions`, `reflection_entries`, `blocked_apps`, `distraction_events`,
  `user_settings`, `emergency_overrides`. Definitions live in `core/local_db/tables/`.
- `AppDatabase.schemaVersion` is 2. Any schema change requires:
  1. Editing the table class.
  2. Bumping `schemaVersion`.
  3. Adding a branch in `migration.onUpgrade`.
  4. Re-running build_runner.
- Writes that must keep explicit NULLs use `toCompanion(false)`. Otherwise a NULL
  update such as clearing `paused_at` gets silently dropped.
- Append-only tables (`distraction_events`, `reflection_entries`, `emergency_overrides`)
  use `insertOrIgnore` or a deterministic id for idempotency.

### Web build requirement

`AppDatabase.open()` needs `web/sqlite3.wasm` and `web/drift_worker.js`, with versions
matching `pubspec.lock`. Without them, web silently hangs on every query. The comment
in `app_database.dart` refers to `DEBUG_REPORT.md`, which is not in this repo.

## Privacy and security (non-negotiable)

- Reflection mood and text, and friction reason text, are encrypted with `FieldCipher`
  (AES-256-GCM, `v1:` prefix) before storage. Never write plaintext into
  `mood_tag`, `response_text`, or `reason_text`.
- Key lives in the platform keystore (`flutter_secure_storage`). Losing it makes old
  encrypted fields unreadable by design.
- Detection is limited to package names. Do not add `canRetrieveWindowContent`, screen
  scraping, or content logging.
- Do not add analytics events, logs, or payloads that include message content or
  personally identifying data beyond what the PRD allows (§24.1, §33.2).

## Product rules that affect code

- **Tone:** neutral and supportive. Never shame or guilt the user. Streaks never erase
  history. A broken streak shows "start a new streak today", not "you lost it".
- **No dark patterns:** every gate, sheet, and dialog must have a visible way out.
  Back should never silently bypass a gate.
- **Friction is proportional:** L0 banner, L1 delay, L2 reason plus delay, L3 full block
  during a session, L4 partner-gated (opt-in). The `FrictionPolicy` class owns escalation.
  Keep it pure and testable.
- **Emergency unblock** is rate-limited per month (default 3, hard ceiling 10). It must
  never dead-end. Keep the emergency number hint visible when quota runs out.
- **Pause budget:** 3 per day. Pauses count across sessions for the same local day.
- **Motion:** avoid celebratory or variable-reward animations (PRD §12.2).
- **Scope of detection:** the implementation guide specifies warning-only detection
  ("Homeo only warns you. It never blocks or closes your apps"). The codebase also still
  contains an in-app gate (`FrictionGateController`) and native `allow`/`returnHome`
  calls via `BlockerBridge`. Confirm the intended behaviour before changing either. Do
  not silently expand or shrink enforcement.

## Platform notes

- **Android** is the primary target. Accessibility Service detects foreground apps and
  writes events to a native queue. Dart drains that queue with `drainPendingEvents` and
  then acks with `ackPendingEvents(upTo:)`. Ack only after rows are stored.
- Channel name is `com.cheapdopamine.homeo/friction`. Shared preference keys written by
  native code need the `flutter.` prefix when read from Kotlin.
- **iOS** uses a user-configured Shortcuts Automation that opens
  `homeo://distraction-event?app=<package_id>`. `DeepLinkService` handles it.
  `homeo://` is the scheme in use. PRD §14 mentions `dopaminefocus://`, which is stale.
- Notification IDs are reserved: 4001 session alarm, 4002 focus started, 4003 focus
  completed, 4010 weekly summary, 5000+ per-app warnings. Do not reuse them.
- Notifications are shown without a `BuildContext`. Locale comes from
  `PlatformDispatcher` via `lookupAppLocalizations`.

## Localization

- Source of truth: `lib/l10n/app_en.arb` and `lib/l10n/app_th.arb`. Keep keys in sync.
- Parameterized strings need `@key` placeholder metadata with types in the ARB.
- Use `context.l10n` in widgets (`core/../l10n/l10n.dart`). Outside widgets, use
  `lookupAppLocalizations`.
- Thai text: Inter has no Thai glyphs. Noto Sans Thai is the fallback. Keep line heights
  at 1.3 or higher so tone marks are not clipped.
- Use `characters` (grapheme clusters) for length checks on user text, not `String.length`.
  `FrictionRules.isValidReason` already does this.
- Use `formatClock` for digits (locale-independent) and `formatFocusDuration` for
  localized durations.

## UI conventions

- Colours come from `AppColors.of(context)`. Never hard-code hex in widgets. Brand
  tokens (`brandPrimary`, `brandAccent`, `brandDanger`) are locked to PRD §12.2.
- Amber (`accent`) is for reward and streak only. Danger red is for friction gates only.
- Spacing: `AppSpacing` (4/8/12/16/24/32/48). Radii: `AppRadius` (card 12, button 8,
  pill 999, sheet 24).
- Typography: `AppTextStyles` mapped into `textTheme`. Prefer `Theme.of(context).textTheme`
  over ad-hoc `TextStyle`s.
- The Focus session, friction gate (L3), and emergency-sensitive screens force dark
  theme via `Theme(data: AppTheme.dark, ...)`.
- Accessibility: wrap decorative-only widgets in `ExcludeSemantics`, and give summaries
  one `Semantics(label: ...)` instead of announcing every tick. Respect
  `MediaQuery.disableAnimationsOf`.
- Bottom navigation hides during an immersive Focus phase and while a gate covers the
  screen. Preserve this logic in `AppShell`.
- Use `ScrollViewKeyboardDismissBehavior` where text fields sit in scrollable content.

## Testing expectations

- Unit test pure domain code: `FocusSession`, `FocusStats`, `StreakCalculator`,
  `FrictionPolicy`, `FrictionRules`, `EmergencyQuota`.
- Inject a fake `Clock` through `clockProvider` for every time-dependent test.
- Scenario tests should cover the PRD §30.3 behaviours. Example: partner silence
  auto-releases at cooling-off end within ±5 s.
- Repositories can be tested with `NativeDatabase.memory()` by passing it to
  `AppDatabase(...)`.
- Widget tests should prove each gate has an exit.

## Things not to do

- Do not edit `*.g.dart` or `lib/l10n/gen/*` by hand.
- Do not add a backend call in the write path. Writes stay local first.
- Do not store reflection or reason text unencrypted.
- Do not bypass `Clock` or `FrictionPolicy` from the UI.
- Do not introduce monetisation, ads, or third-party trackers (PRD §34, §24.4).
- Do not add `localStorage`-style global state. Riverpod providers and repositories are
  the state layer.
- Do not add a `pubspec` dependency without checking the PRD tech stack (§26) and the
  Flutter-only constraint.

## Open items to confirm before big changes

1. Detection scope: warning-only (guide) versus in-app gate L0–L4 (current code).
2. Riverpod version: PRD says 2.x, code uses 3.x APIs.
3. Deep link scheme: `homeo://` (code) versus `dopaminefocus://` (PRD §14).
4. `DEBUG_REPORT.md` is referenced but absent.
5. Web assets (`sqlite3.wasm`, `drift_worker.js`) must be present in `web/`.
6. `DateTime.now()` usage in `session_alarm.dart` and `notification_service.dart` should
   move behind `Clock`.