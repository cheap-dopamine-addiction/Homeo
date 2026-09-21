// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocker_bridge.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(blockerBridge)
final blockerBridgeProvider = BlockerBridgeProvider._();

final class BlockerBridgeProvider
    extends $FunctionalProvider<BlockerBridge, BlockerBridge, BlockerBridge>
    with $Provider<BlockerBridge> {
  BlockerBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockerBridgeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockerBridgeHash();

  @$internal
  @override
  $ProviderElement<BlockerBridge> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BlockerBridge create(Ref ref) {
    return blockerBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlockerBridge value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlockerBridge>(value),
    );
  }
}

String _$blockerBridgeHash() => r'b6c58fac93b31e4b949505e210f07c158a04608d';
