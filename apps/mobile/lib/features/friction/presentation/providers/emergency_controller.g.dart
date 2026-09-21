// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emergency unblock (PRD §9.7): separate from partner approval, so it can
/// never be the thing standing between someone and a real emergency — but
/// rate-limited per month so it cannot become the everyday way around the
/// blocker (PRD §23.4).

@ProviderFor(EmergencyController)
final emergencyControllerProvider = EmergencyControllerProvider._();

/// Emergency unblock (PRD §9.7): separate from partner approval, so it can
/// never be the thing standing between someone and a real emergency — but
/// rate-limited per month so it cannot become the everyday way around the
/// blocker (PRD §23.4).
final class EmergencyControllerProvider
    extends $NotifierProvider<EmergencyController, EmergencyState> {
  /// Emergency unblock (PRD §9.7): separate from partner approval, so it can
  /// never be the thing standing between someone and a real emergency — but
  /// rate-limited per month so it cannot become the everyday way around the
  /// blocker (PRD §23.4).
  EmergencyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyControllerHash();

  @$internal
  @override
  EmergencyController create() => EmergencyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmergencyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmergencyState>(value),
    );
  }
}

String _$emergencyControllerHash() =>
    r'401995a86ad9728c7e84f2f92bd656544a3f91f6';

/// Emergency unblock (PRD §9.7): separate from partner approval, so it can
/// never be the thing standing between someone and a real emergency — but
/// rate-limited per month so it cannot become the everyday way around the
/// blocker (PRD §23.4).

abstract class _$EmergencyController extends $Notifier<EmergencyState> {
  EmergencyState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EmergencyState, EmergencyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmergencyState, EmergencyState>,
              EmergencyState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
