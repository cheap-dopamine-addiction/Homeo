import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/friction/presentation/providers/friction_gate_controller.dart';
import 'package:homeo/features/friction/presentation/screens/friction_gate_overlay.dart';
import 'package:homeo/features/friction/presentation/widgets/emergency_override_sheet.dart';
import 'package:homeo/l10n/l10n.dart';

/// Scaffold + bottom navigation for the five tabs, plus the friction gate
/// that sits above everything.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const int _focusIndex = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // During setup / a running session / the summary the Focus tab is
    // full-screen. Leaving mid-session is what the exit gate is for, so the
    // tab bar is hidden — but only while the Focus tab is the visible one, so
    // it can never be hidden with no way back.
    final focusImmersive =
        ref.watch(focusImmersiveProvider) &&
        navigationShell.currentIndex == _focusIndex;

    // Watching the gate here also keeps its controller alive from launch,
    // so native "app opened" events are handled from the start.
    final gate = ref.watch(frictionGateControllerProvider);
    final hideNav = focusImmersive || gateCoversScreen(gate);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          if (gate != null) const Positioned.fill(child: FrictionGateOverlay()),
        ],
      ),
      bottomNavigationBar: hideNav
          ? null
          : GestureDetector(
              // Long-press the tab bar for the emergency unblock (PRD §14).
              behavior: HitTestBehavior.translucent,
              onLongPress: () => showEmergencySheet(context),
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => navigationShell.goBranch(
                  index,
                  // Tapping the active tab pops it back to its root.
                  initialLocation: index == navigationShell.currentIndex,
                ),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.adjust_rounded),
                    selectedIcon: const Icon(Icons.gps_fixed_rounded),
                    label: l10n.tabFocus,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.lock_outline_rounded),
                    selectedIcon: const Icon(Icons.lock_rounded),
                    label: l10n.tabVault,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.bar_chart_rounded),
                    selectedIcon: const Icon(Icons.bar_chart_rounded),
                    label: l10n.tabInsights,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    selectedIcon: const Icon(Icons.chat_bubble_rounded),
                    label: l10n.tabAiCoach,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings_rounded),
                    label: l10n.tabSettings,
                  ),
                ],
              ),
            ),
    );
  }
}
