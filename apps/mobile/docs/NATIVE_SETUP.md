# Native setup (things `flutter create` cannot do for you)

> Sections 1–2 are applied automatically by `dart tool/apply_native_config.dart`
> (step 2 of `tool/setup.sh` / `setup.ps1`). Do them by hand only if it prints `! MANUAL`.

These edits live in `android/` and `ios/`, which are only on your machine.
Check each plugin's README for your Flutter version — native snippets change.

## 1. Session-end notification (`flutter_local_notifications`)

### Android
`android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<!-- Optional. Without it the app falls back to inexact alarms (may be a few
     minutes late in Doze). -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>

<application ...>
    <receiver
        android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
        android:exported="false"/>
</application>
```

`android/app/build.gradle.kts` (Groovy: `coreLibraryDesugaringEnabled true` and
`coreLibraryDesugaring '...'`)

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

### iOS
`ios/Runner/AppDelegate.swift` — inside `application(_:didFinishLaunchingWithOptions:)`:

```swift
UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
```

Notification permission is requested when the first session starts, not at launch.

## 2. `flutter_secure_storage` (encryption key)
Android needs `minSdk` 23 or higher (Flutter's default is already above that).
No iOS setup for the default Keychain options.

## 3. Native blocker contract (not implemented yet)
Channel: `com.cheapdopamine.homeo/blocker` — see the doc comment on
`BlockerBridge` in `lib/features/friction/data/blocker_bridge.dart`.

| Direction        | Method                                   | Meaning                              |
|------------------|------------------------------------------|--------------------------------------|
| native → Dart    | `onAttempt(String packageId)`            | user tried to open a watched app     |
| Dart → native    | `syncBlockedApps(List<String>)`          | current watch list                   |
| Dart → native    | `allow({packageId, seconds})`            | let one app through for a while      |
| Dart → native    | `allowAll({seconds})`                    | emergency unblock                    |
| Dart → native    | `returnHome()`                           | leave the blocked app                |

Until it exists, use **Settings ▸ Friction ▸ Test (debug only)** to trigger a gate.

Design notes for the native side:
* The blocker must keep enforcing the last synced list when the Flutter
  engine is not running; `onAttempt` only reaches Dart when it is.
* Never block the phone dialer or system emergency features.
* iOS Screen Time (FamilyControls) returns opaque tokens, not package ids —
  map them to the ids in `AppCatalog` inside the native layer.
