// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// keepAlive: leaving the Focus home view (e.g. during a session) must not
/// tear down the DB stream and flash empty stats on return.
///
/// MVP note: this reads every finished session so "best streak" is exact.
/// Swap for the `analytics_snapshots` daily roll-up (PRD §16.2) if history
/// grows large.

@ProviderFor(finishedSessions)
final finishedSessionsProvider = FinishedSessionsProvider._();

/// keepAlive: leaving the Focus home view (e.g. during a session) must not
/// tear down the DB stream and flash empty stats on return.
///
/// MVP note: this reads every finished session so "best streak" is exact.
/// Swap for the `analytics_snapshots` daily roll-up (PRD §16.2) if history
/// grows large.

final class FinishedSessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FocusSession>>,
          List<FocusSession>,
          Stream<List<FocusSession>>
        >
    with
        $FutureModifier<List<FocusSession>>,
        $StreamProvider<List<FocusSession>> {
  /// keepAlive: leaving the Focus home view (e.g. during a session) must not
  /// tear down the DB stream and flash empty stats on return.
  ///
  /// MVP note: this reads every finished session so "best streak" is exact.
  /// Swap for the `analytics_snapshots` daily roll-up (PRD §16.2) if history
  /// grows large.
  FinishedSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finishedSessionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finishedSessionsHash();

  @$internal
  @override
  $StreamProviderElement<List<FocusSession>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FocusSession>> create(Ref ref) {
    return finishedSessions(ref);
  }
}

String _$finishedSessionsHash() => r'5453f971ae3d6d71ec48aed387645f9f84d16603';

@ProviderFor(focusStats)
final focusStatsProvider = FocusStatsProvider._();

final class FocusStatsProvider
    extends $FunctionalProvider<FocusStats, FocusStats, FocusStats>
    with $Provider<FocusStats> {
  FocusStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusStatsHash();

  @$internal
  @override
  $ProviderElement<FocusStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FocusStats create(Ref ref) {
    return focusStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FocusStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FocusStats>(value),
    );
  }
}

String _$focusStatsHash() => r'2d375fef4ff2028a95cff733811c3f027e38b54c';
