// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friction_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(frictionRepository)
final frictionRepositoryProvider = FrictionRepositoryProvider._();

final class FrictionRepositoryProvider
    extends
        $FunctionalProvider<
          FrictionRepository,
          FrictionRepository,
          FrictionRepository
        >
    with $Provider<FrictionRepository> {
  FrictionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frictionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frictionRepositoryHash();

  @$internal
  @override
  $ProviderElement<FrictionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FrictionRepository create(Ref ref) {
    return frictionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrictionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrictionRepository>(value),
    );
  }
}

String _$frictionRepositoryHash() =>
    r'5cc70610f1bb8af1ff63641e74c7685d49e2c363';
