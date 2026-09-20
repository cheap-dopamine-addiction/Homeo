import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/l10n/l10n.dart';

// ---------------------------------------------------------------------------
// AppShell
// ---------------------------------------------------------------------------

/// Persistent bottom navigation shell used by [GoRouter]'s ShellRoute.
///
/// FIX (app_shell.dart L17): `context.l10n` is defined as a [BuildContext]
/// extension in `lib/l10n/l10n.dart`.  The error "The getter 'l10n' isn't
/// defined for the type 'BuildContext'" was caused by the import being missing.
///
/// FIX (app_shell.dart L23): `focusImmersiveProvider` was referenced but
/// never declared.  It is now defined in focus_session_controller.dart and
/// returns `true` while the timer is actively running.
class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  // Tab configuration
  static const _tabs = [
    _Tab(label: 'Focus', icon: Icons.self_improvement_rounded, path: '/focus'),
    _Tab(label: 'Vault', icon: Icons.lock_rounded, path: '/vault'),
    _Tab(
        label: 'Insights',
        icon: Icons.bar_chart_rounded,
        path: '/insights'),
    _Tab(label: 'AI Coach', icon: Icons.smart_toy_rounded, path: '/coach'),
    _Tab(label: 'Settings', icon: Icons.settings_rounded, path: '/settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIX: use focusImmersiveProvider (now declared in focus_session_controller.dart)
    final isImmersive = ref.watch(focusImmersiveProvider);

    // The current location determines which tab is highlighted.
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _tabs.indexWhere(
      (t) => location.startsWith(t.path),
    );

    return Scaffold(
      body: child,
      // FIX: use context.l10n from the BuildContext extension in l10n.dart
      bottomNavigationBar: isImmersive
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex.clamp(0, _tabs.length - 1),
              onDestinationSelected: (i) => context.go(_tabs[i].path),
              destinations: _tabs.map((t) {
                // Demonstrates l10n usage — replace with context.l10n.tabFocus etc.
                final label = _resolveLabel(context, t);
                return NavigationDestination(
                  icon: Icon(t.icon),
                  label: label,
                );
              }).toList(),
            ),
    );
  }

  String _resolveLabel(BuildContext context, _Tab tab) {
    final l10n = context.l10n; // uses BuildContext.l10n extension
    return switch (tab.path) {
      '/focus' => l10n.tabFocus,
      '/vault' => l10n.tabVault,
      '/insights' => l10n.tabInsights,
      '/coach' => l10n.tabAiCoach,
      '/settings' => l10n.tabSettings,
      _ => tab.label,
    };
  }
}

class _Tab {
  const _Tab({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}
