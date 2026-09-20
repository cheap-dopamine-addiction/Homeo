import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/app/shell/app_shell.dart';
import 'package:homeo/features/ai_coach/presentation/screens/ai_coach_screen.dart';
import 'package:homeo/features/analytics/presentation/screens/insights_screen.dart';
import 'package:homeo/features/focus_session/presentation/screens/focus_screen.dart';
import 'package:homeo/features/settings/presentation/screens/settings_screen.dart';
import 'package:homeo/features/vault_partner/presentation/screens/vault_screen.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// NOTE on app_router.g.dart
// ---------------------------------------------------------------------------
// FIX: `app_router.g.dart` was missing because build_runner had not been run.
// The `part 'app_router.g.dart';` directive requires:
//
//   dart run build_runner build --delete-conflicting-outputs
//
// After running that command the generated file will appear and all
// TypedGoRoute-related errors will resolve automatically.
// ---------------------------------------------------------------------------

/// Application router — uses go_router's StatefulShellRoute for persistent
/// bottom navigation.
final appRouter = GoRouter(
  initialLocation: '/focus',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(child: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/focus',
              // FIX: FocusScreen() is a class constructor — not a function call.
              // Original error: "The name 'FocusScreen' isn't a class" was caused
              // by the import of focus_screen.dart being missing.
              builder: (context, state) => const FocusScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vault',
              // FIX: VaultScreen() — same fix as above.
              builder: (context, state) => const VaultScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/insights',
              // FIX: InsightsScreen() — same fix.
              builder: (context, state) => const InsightsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/coach',
              // FIX: AiCoachScreen() — same fix.
              builder: (context, state) => const AiCoachScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              // FIX: SettingsScreen() — same fix.
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
