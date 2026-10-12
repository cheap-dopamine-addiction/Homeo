import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PartnerStatus { active, pending, revoked }

/// Permission ids shared with a partner (design: `ALL_PERMISSIONS`).
enum PartnerPermission {
  focusTime,
  sessionComplete,
  continuity,
  override,
  emergency,
}

@immutable
class VaultPartner {
  const VaultPartner({
    required this.id,
    required this.name,
    required this.status,
    required this.permissions,
    required this.since,
  });

  final String id;
  final String name;
  final PartnerStatus status;
  final Set<PartnerPermission> permissions;
  final DateTime since;

  VaultPartner copyWith({
    PartnerStatus? status,
    Set<PartnerPermission>? permissions,
  }) => VaultPartner(
    id: id,
    name: name,
    status: status ?? this.status,
    permissions: permissions ?? this.permissions,
    since: since,
  );
}

@immutable
class OverrideRequest {
  const OverrideRequest({
    required this.id,
    required this.partnerName,
    required this.appName,
    required this.reason,
    required this.requestedAt,
    required this.expiresAt,
  });

  final String id;
  final String partnerName;
  final String appName;
  final String reason;
  final DateTime requestedAt;
  final DateTime expiresAt;
}

@immutable
class VaultState {
  const VaultState({this.partners = const [], this.requests = const []});

  final List<VaultPartner> partners;
  final List<OverrideRequest> requests;

  VaultState copyWith({
    List<VaultPartner>? partners,
    List<OverrideRequest>? requests,
  }) => VaultState(
    partners: partners ?? this.partners,
    requests: requests ?? this.requests,
  );
}

/// In-memory Vault Partner state.
///
/// The partner backend (PRD §10, `/v1/vault/*`) does not exist yet, so this
/// is the local seam the UI works against. Debug builds are seeded with the
/// design's sample partners so the screens can be reviewed; release builds
/// start empty. `PartnerGateway.hasPartner` is deliberately *not* tied to
/// this state — L4 stays unavailable until real partners exist.
class VaultController extends Notifier<VaultState> {
  @override
  VaultState build() {
    if (!kDebugMode) return const VaultState();
    final now = DateTime.now();
    return VaultState(
      partners: [
        VaultPartner(
          id: 'demo-1',
          name: 'พี่นุ่น',
          status: PartnerStatus.active,
          permissions: const {
            PartnerPermission.focusTime,
            PartnerPermission.sessionComplete,
          },
          since: DateTime(now.year, 7, 12),
        ),
        VaultPartner(
          id: 'demo-2',
          name: 'เพื่อนแจน',
          status: PartnerStatus.pending,
          permissions: const {PartnerPermission.focusTime},
          since: now,
        ),
      ],
      requests: [
        OverrideRequest(
          id: 'demo-req-1',
          partnerName: 'พี่นุ่น',
          appName: 'Instagram',
          reason: 'ดูงานที่ส่งมาในแอป',
          requestedAt: now.subtract(const Duration(minutes: 2)),
          expiresAt: now.add(const Duration(minutes: 13)),
        ),
      ],
    );
  }

  /// Records an invitation that has been created locally and is waiting for
  /// the other person (no backend yet, so it stays `pending`).
  void addPending(String name, Set<PartnerPermission> permissions) {
    state = state.copyWith(
      partners: [
        ...state.partners,
        VaultPartner(
          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
          name: name,
          status: PartnerStatus.pending,
          permissions: permissions,
          since: DateTime.now(),
        ),
      ],
    );
  }

  void revoke(String partnerId) {
    state = state.copyWith(
      partners: [
        for (final p in state.partners)
          if (p.id == partnerId)
            p.copyWith(status: PartnerStatus.revoked)
          else
            p,
      ],
    );
  }

  void setPermissions(String partnerId, Set<PartnerPermission> permissions) {
    state = state.copyWith(
      partners: [
        for (final p in state.partners)
          if (p.id == partnerId) p.copyWith(permissions: permissions) else p,
      ],
    );
  }

  /// Approve or deny: either way the request leaves the inbox.
  void resolveRequest(String requestId) {
    state = state.copyWith(
      requests: [
        for (final r in state.requests)
          if (r.id != requestId) r,
      ],
    );
  }
}

final vaultControllerProvider = NotifierProvider<VaultController, VaultState>(
  VaultController.new,
);
