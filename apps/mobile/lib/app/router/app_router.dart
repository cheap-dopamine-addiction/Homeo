import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/app/router/app_routes.dart';
import 'package:homeo/app/shell/app_shell.dart';
import 'package:homeo/features/ai_coach/presentation/screens/ai_coach_screen.dart';
import 'package:homeo/features/analytics/presentation/screens/insights_screen.dart';
import 'package:homeo/features/focus_session/presentation/screens/focus_screen.dart';
import 'package:homeo/features/friction/presentation/screens/friction_settings_screen.dart';
import 'package:homeo/features/settings/presentation/screens/settings_screen.dart';
import 'package:homeo/features/vault_partner/presentation/screens/vault_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Five tabs in a [StatefulShellRoute.indexedStack]: each tab keeps its own
/// navigation stack and widget state when you switch away (a plain
/// `ShellRoute` rebuilds the tab from scratch every time).
///
/// Branch order must match the destination order in [AppShell].
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.focus,
    debugLogDiagnostics: kDebugMode,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.focus,
                builder: (context, state) => const FocusScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.vault,
                builder: (context, state) => const VaultScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.insights,
                builder: (context, state) => const InsightsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiCoach,
                builder: (context, state) => const AiCoachScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'friction',
                    builder: (context, state) => const FrictionSettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
