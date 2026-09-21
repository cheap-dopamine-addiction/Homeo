// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_cipher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fieldCipher)
final fieldCipherProvider = FieldCipherProvider._();

final class FieldCipherProvider
    extends $FunctionalProvider<FieldCipher, FieldCipher, FieldCipher>
    with $Provider<FieldCipher> {
  FieldCipherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fieldCipherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fieldCipherHash();

  @$internal
  @override
  $ProviderElement<FieldCipher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FieldCipher create(Ref ref) {
    return fieldCipher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FieldCipher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FieldCipher>(value),
    );
  }
}

String _$fieldCipherHash() => r'ad2a5d62f1c67e617e2a3f783930739c360e6cc8';
