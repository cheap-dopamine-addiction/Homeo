// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the whole session lifecycle: setup → running/paused → summary → idle.
///
/// * keepAlive: switching tabs must never stop the timer.
/// * The countdown is *derived* from timestamps (see [FocusSession]); the
///   ticker only decides when to re-render.
/// * State changes happen synchronously before any `await`, so double taps
///   cannot start/finish a session twice.

@ProviderFor(FocusSessionController)
final focusSessionControllerProvider = FocusSessionControllerProvider._();

/// Owns the whole session lifecycle: setup → running/paused → summary → idle.
///
/// * keepAlive: switching tabs must never stop the timer.
/// * The countdown is *derived* from timestamps (see [FocusSession]); the
///   ticker only decides when to re-render.
/// * State changes happen synchronously before any `await`, so double taps
///   cannot start/finish a session twice.
final class FocusSessionControllerProvider
    extends $NotifierProvider<FocusSessionController, FocusSessionState> {
  /// Owns the whole session lifecycle: setup → running/paused → summary → idle.
  ///
  /// * keepAlive: switching tabs must never stop the timer.
  /// * The countdown is *derived* from timestamps (see [FocusSession]); the
  ///   ticker only decides when to re-render.
  /// * State changes happen synchronously before any `await`, so double taps
  ///   cannot start/finish a session twice.
  FocusSessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusSessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusSessionControllerHash();

  @$internal
  @override
  FocusSessionController create() => FocusSessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FocusSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FocusSessionState>(value),
    );
  }
}

String _$focusSessionControllerHash() =>
    r'89d6cbcfa76bd66c0e7315cf141362f0ae2c638b';

/// Owns the whole session lifecycle: setup → running/paused → summary → idle.
///
/// * keepAlive: switching tabs must never stop the timer.
/// * The countdown is *derived* from timestamps (see [FocusSession]); the
///   ticker only decides when to re-render.
/// * State changes happen synchronously before any `await`, so double taps
///   cannot start/finish a session twice.

abstract class _$FocusSessionController extends $Notifier<FocusSessionState> {
  FocusSessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FocusSessionState, FocusSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FocusSessionState, FocusSessionState>,
              FocusSessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// True while the Focus tab is in a full-screen phase (setup / running /
/// summary). The app shell hides the bottom navigation then.

@ProviderFor(focusImmersive)
final focusImmersiveProvider = FocusImmersiveProvider._();

/// True while the Focus tab is in a full-screen phase (setup / running /
/// summary). The app shell hides the bottom navigation then.

final class FocusImmersiveProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True while the Focus tab is in a full-screen phase (setup / running /
  /// summary). The app shell hides the bottom navigation then.
  FocusImmersiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusImmersiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusImmersiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return focusImmersive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$focusImmersiveHash() => r'b2031975f44ece3e9ee84189c50da6818031a53a';
