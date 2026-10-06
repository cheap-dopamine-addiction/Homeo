// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(blockedApps)
final blockedAppsProvider = BlockedAppsProvider._();

final class BlockedAppsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BlockedApp>>,
          List<BlockedApp>,
          Stream<List<BlockedApp>>
        >
    with $FutureModifier<List<BlockedApp>>, $StreamProvider<List<BlockedApp>> {
  BlockedAppsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedAppsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedAppsHash();

  @$internal
  @override
  $StreamProviderElement<List<BlockedApp>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BlockedApp>> create(Ref ref) {
    return blockedApps(ref);
  }
}

String _$blockedAppsHash() => r'9cb24a1e32c31121b9765b92db66e95a8f541bff';

/// Emergency unblocks used this calendar month.
///
/// The `[from, to)` window is fixed when this provider is built, so a timer
/// re-builds it at 00:00 on the 1st; otherwise the "used x/y" display would
/// stay on last month's count until the app is restarted. (Enforcement is
/// unaffected — `EmergencyController.activate` always recounts from the DB.)

@ProviderFor(emergencyUsesThisMonth)
final emergencyUsesThisMonthProvider = EmergencyUsesThisMonthProvider._();

/// Emergency unblocks used this calendar month.
///
/// The `[from, to)` window is fixed when this provider is built, so a timer
/// re-builds it at 00:00 on the 1st; otherwise the "used x/y" display would
/// stay on last month's count until the app is restarted. (Enforcement is
/// unaffected — `EmergencyController.activate` always recounts from the DB.)

final class EmergencyUsesThisMonthProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Emergency unblocks used this calendar month.
  ///
  /// The `[from, to)` window is fixed when this provider is built, so a timer
  /// re-builds it at 00:00 on the 1st; otherwise the "used x/y" display would
  /// stay on last month's count until the app is restarted. (Enforcement is
  /// unaffected — `EmergencyController.activate` always recounts from the DB.)
  EmergencyUsesThisMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyUsesThisMonthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyUsesThisMonthHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return emergencyUsesThisMonth(ref);
  }
}

String _$emergencyUsesThisMonthHash() =>
    r'4d48a633bf4917476f4b44cb50b3b4fc55e5cc98';

/// Used / limit for the current month, shown in the emergency sheet and in
/// Settings.

@ProviderFor(emergencyQuota)
final emergencyQuotaProvider = EmergencyQuotaProvider._();

/// Used / limit for the current month, shown in the emergency sheet and in
/// Settings.

final class EmergencyQuotaProvider
    extends $FunctionalProvider<EmergencyQuota, EmergencyQuota, EmergencyQuota>
    with $Provider<EmergencyQuota> {
  /// Used / limit for the current month, shown in the emergency sheet and in
  /// Settings.
  EmergencyQuotaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyQuotaProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyQuotaHash();

  @$internal
  @override
  $ProviderElement<EmergencyQuota> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmergencyQuota create(Ref ref) {
    return emergencyQuota(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmergencyQuota value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmergencyQuota>(value),
    );
  }
}

String _$emergencyQuotaHash() => r'a7dcb259ddb4587d9af1b72a18b31c879c5e22d0';
