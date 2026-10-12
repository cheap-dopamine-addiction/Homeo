import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/notifications/notification_service.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:homeo/features/settings/presentation/providers/preferences_controller.dart';

/// Step indices of the flow (design: `Onboarding.tsx`).
abstract final class OnboardingSteps {
  static const int welcome = 0;
  static const int triggers = 1;
  static const int goal = 2;
  static const int apps = 3;
  static const int friction = 4;
  static const int permissions = 5;
  static const int last = permissions;
}

@immutable
class OnboardingFlow {
  const OnboardingFlow({
    this.step = OnboardingSteps.welcome,
    this.triggers = const <String>{},
    this.goal = '',
    this.apps = const <String>{},
    this.friction = 1,
    this.finishing = false,
  });

  final int step;

  /// Trigger ids (stable keys, not display text).
  final Set<String> triggers;
  final String goal;

  /// `CatalogApp.key` values.
  final Set<String> apps;

  /// 0–4, default L1 (design default).
  final int friction;
  final bool finishing;

  bool get canProceed => switch (step) {
    OnboardingSteps.triggers => triggers.isNotEmpty,
    OnboardingSteps.goal => goal.isNotEmpty,
    _ => true,
  };

  OnboardingFlow copyWith({
    int? step,
    Set<String>? triggers,
    String? goal,
    Set<String>? apps,
    int? friction,
    bool? finishing,
  }) {
    return OnboardingFlow(
      step: step ?? this.step,
      triggers: triggers ?? this.triggers,
      goal: goal ?? this.goal,
      apps: apps ?? this.apps,
      friction: friction ?? this.friction,
      finishing: finishing ?? this.finishing,
    );
  }
}

class OnboardingController extends Notifier<OnboardingFlow> {
  @override
  OnboardingFlow build() => const OnboardingFlow();

  void next() {
    // "Skip" in the design behaves like "next" without the validation.
    if (state.step < OnboardingSteps.last) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void nextIfAllowed() {
    if (state.canProceed) next();
  }

  void back() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }

  void toggleTrigger(String id) {
    final next = {...state.triggers};
    if (!next.remove(id)) next.add(id);
    state = state.copyWith(triggers: next);
  }

  void selectGoal(String id) => state = state.copyWith(goal: id);

  void toggleApp(String key) {
    final next = {...state.apps};
    if (!next.remove(key)) next.add(key);
    state = state.copyWith(apps: next);
  }

  void selectFriction(int level) => state = state.copyWith(friction: level);

  /// Saves the choices and leaves onboarding. The router redirect reacts to
  /// `onboardingDone` and moves to the Focus tab.
  ///
  /// [askPermissions] is false for "skip and set up later".
  Future<void> finish({required bool askPermissions}) async {
    if (state.finishing) return;
    final flow = state;
    state = flow.copyWith(finishing: true);

    try {
      final level = FrictionLevel.fromCode(flow.friction);

      final settingsRepo = ref.read(settingsRepositoryProvider);
      final settings = await settingsRepo.load();
      await settingsRepo.save(settings.copyWith(defaultFrictionLevel: level));

      final frictionRepo = ref.read(frictionRepositoryProvider);
      for (final key in flow.apps) {
        final app = AppCatalog.byKey(key);
        if (app == null) continue;
        await frictionRepo.setBlockedApp(
          BlockedApp(appPackageId: app.packageId, level: level),
        );
      }

      if (askPermissions) {
        await ref.read(notificationServiceProvider).requestPermission();
      }
    } catch (e, st) {
      // Never trap the user in onboarding because a side effect failed.
      debugPrint('Onboarding.finish side effects failed: $e\n$st');
    }

    await ref
        .read(preferencesProvider.notifier)
        .update(
          (p) => p.copyWith(
            onboardingDone: true,
            onboardingGoal: flow.goal,
            onboardingTriggers: flow.triggers.toList(),
          ),
        );
    state = const OnboardingFlow();
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingFlow>(
      OnboardingController.new,
    );
