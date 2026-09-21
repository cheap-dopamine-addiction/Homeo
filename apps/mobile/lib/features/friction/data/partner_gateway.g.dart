// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_gateway.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(partnerGateway)
final partnerGatewayProvider = PartnerGatewayProvider._();

final class PartnerGatewayProvider
    extends $FunctionalProvider<PartnerGateway, PartnerGateway, PartnerGateway>
    with $Provider<PartnerGateway> {
  PartnerGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerGatewayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerGatewayHash();

  @$internal
  @override
  $ProviderElement<PartnerGateway> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PartnerGateway create(Ref ref) {
    return partnerGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerGateway>(value),
    );
  }
}

String _$partnerGatewayHash() => r'087d0c55fc726764e422def29bed99f11753b164';
