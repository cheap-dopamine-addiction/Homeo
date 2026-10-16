// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friction_gate_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Decides *whether and how hard* to pause an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// Homeo only warns: the gate is a reflective pause the user can always walk
/// through ("open anyway"), after a short delay. Attempts arrive from a
/// tapped warning notification / Shortcuts link ([onAttempt] with an
/// `eventId`), from the native stream, or from the debug simulator.
///
/// State is the gate on screen, or null.

@ProviderFor(FrictionGateController)
final frictionGateControllerProvider = FrictionGateControllerProvider._();

/// Decides *whether and how hard* to pause an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// Homeo only warns: the gate is a reflective pause the user can always walk
/// through ("open anyway"), after a short delay. Attempts arrive from a
/// tapped warning notification / Shortcuts link ([onAttempt] with an
/// `eventId`), from the native stream, or from the debug simulator.
///
/// State is the gate on screen, or null.
final class FrictionGateControllerProvider
    extends $NotifierProvider<FrictionGateController, FrictionGateRequest?> {
  /// Decides *whether and how hard* to pause an app launch, shows the gate (via
  /// state), and records how it ended (PRD §9.3, §11).
  ///
  /// Homeo only warns: the gate is a reflective pause the user can always walk
  /// through ("open anyway"), after a short delay. Attempts arrive from a
  /// tapped warning notification / Shortcuts link ([onAttempt] with an
  /// `eventId`), from the native stream, or from the debug simulator.
  ///
  /// State is the gate on screen, or null.
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
    r'1a9ad5146fffd142dfd5dc6e3e738e22fe674f28';

/// Decides *whether and how hard* to pause an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// Homeo only warns: the gate is a reflective pause the user can always walk
/// through ("open anyway"), after a short delay. Attempts arrive from a
/// tapped warning notification / Shortcuts link ([onAttempt] with an
/// `eventId`), from the native stream, or from the debug simulator.
///
/// State is the gate on screen, or null.

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
