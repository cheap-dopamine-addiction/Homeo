import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_gateway.g.dart';

enum PartnerDecision { approved, denied }

/// Seam for the Vault Partner slice (PRD §10). L4 talks only to this.
abstract interface class PartnerGateway {
  /// Whether an active Vault Partner exists. While false, L4 is unavailable
  /// and the policy falls back to L3.
  bool get hasPartner;

  /// Sends an override request. Emits at most one decision; if the partner
  /// never answers the stream simply stays silent and the caller applies the
  /// cooling-off auto-release (PRD §10.2).
  Stream<PartnerDecision> requestOverride({
    required String appPackageId,
    required String reason,
  });
}

/// Default until the Vault slice exists: no partner.
class OfflinePartnerGateway implements PartnerGateway {
  const OfflinePartnerGateway();

  @override
  bool get hasPartner => false;

  @override
  Stream<PartnerDecision> requestOverride({
    required String appPackageId,
    required String reason,
  }) => const Stream<PartnerDecision>.empty();
}

@Riverpod(keepAlive: true)
PartnerGateway partnerGateway(Ref ref) => const OfflinePartnerGateway();
