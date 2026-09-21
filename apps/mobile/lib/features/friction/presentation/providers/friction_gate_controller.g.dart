// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friction_gate_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Decides *whether and how hard* to gate an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// State is the gate on screen, or null. Attempts come from the native
/// blocker ([BlockerBridge.attempts]) or from [onAttempt] directly (debug
/// simulator).

@ProviderFor(FrictionGateController)
final frictionGateControllerProvider = FrictionGateControllerProvider._();

/// Decides *whether and how hard* to gate an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// State is the gate on screen, or null. Attempts come from the native
/// blocker ([BlockerBridge.attempts]) or from [onAttempt] directly (debug
/// simulator).
final class FrictionGateControllerProvider
    extends $NotifierProvider<FrictionGateController, FrictionGateRequest?> {
  /// Decides *whether and how hard* to gate an app launch, shows the gate (via
  /// state), and records how it ended (PRD §9.3, §11).
  ///
  /// State is the gate on screen, or null. Attempts come from the native
  /// blocker ([BlockerBridge.attempts]) or from [onAttempt] directly (debug
  /// simulator).
  FrictionGateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frictionGateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frictionGateControllerHash();

  @$internal
  @override
  FrictionGateController create() => FrictionGateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrictionGateRequest? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrictionGateRequest?>(value),
    );
  }
}

String _$frictionGateControllerHash() =>
    r'fbdbd14079e7044206bdb90eb017180e0d47ef95';

/// Decides *whether and how hard* to gate an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// State is the gate on screen, or null. Attempts come from the native
/// blocker ([BlockerBridge.attempts]) or from [onAttempt] directly (debug
/// simulator).

abstract class _$FrictionGateController
    extends $Notifier<FrictionGateRequest?> {
  FrictionGateRequest? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FrictionGateRequest?, FrictionGateRequest?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FrictionGateRequest?, FrictionGateRequest?>,
              FrictionGateRequest?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
