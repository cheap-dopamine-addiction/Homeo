import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/friction/data/blocker_bridge.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/data/partner_gateway.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/domain/friction_policy.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';
import 'package:homeo/features/friction/presentation/providers/emergency_controller.dart';
import 'package:homeo/features/friction/presentation/providers/friction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'friction_gate_controller.g.dart';

enum PartnerStage { none, pending, denied }

/// A gate that is currently on screen.
@immutable
class FrictionGateRequest {
  const FrictionGateRequest({
    required this.appPackageId,
    required this.level,
    required this.baseLevel,
    required this.escalatedByBurst,
    required this.duringSession,
    required this.attemptNumberToday,
    this.unlockAt,
    this.partner = PartnerStage.none,
    this.coolingOffEndsAt,
  });

  final String appPackageId;
  final FrictionLevel level;
  final FrictionLevel baseLevel;
  final bool escalatedByBurst;
  final bool duringSession;
  final int attemptNumberToday;

  /// "Open anyway" is refused before this instant (L1 / L2 delay). The
  /// controller enforces it, so a UI bug cannot skip the friction.
  final DateTime? unlockAt;

  final PartnerStage partner;
  final DateTime? coolingOffEndsAt;

  String get appName => AppCatalog.nameOf(appPackageId);

  FrictionGateRequest copyWith({
    PartnerStage? partner,
    DateTime? coolingOffEndsAt,
  }) {
    return FrictionGateRequest(
      appPackageId: appPackageId,
      level: level,
      baseLevel: baseLevel,
      escalatedByBurst: escalatedByBurst,
      duringSession: duringSession,
      attemptNumberToday: attemptNumberToday,
      unlockAt: unlockAt,
      partner: partner ?? this.partner,
      coolingOffEndsAt: coolingOffEndsAt ?? this.coolingOffEndsAt,
    );
  }
}

/// Decides *whether and how hard* to gate an app launch, shows the gate (via
/// state), and records how it ended (PRD §9.3, §11).
///
/// State is the gate on screen, or null. Attempts come from the native
/// blocker ([BlockerBridge.attempts]) or from [onAttempt] directly (debug
/// simulator).
@Riverpod(keepAlive: true)
class FrictionGateController extends _$FrictionGateController {
  static const _uuid = Uuid();

  bool _resolving = false;
  Timer? _coolingOffTimer;
  StreamSubscription<PartnerDecision>? _partnerSub;

  Clock get _clock => ref.read(clockProvider);
  FrictionRepository get _repo => ref.read(frictionRepositoryProvider);
  BlockerBridge get _bridge => ref.read(blockerBridgeProvider);

  @override
  FrictionGateRequest? build() {
    final attempts = _bridge.attempts.listen((id) => unawaited(onAttempt(id)));
    ref.onDispose(() {
      unawaited(attempts.cancel());
      _clearPartnerWait();
    });

    // Keep the native blocker's watch list in step with the DB.
    ref.listen(blockedAppsProvider, (previous, next) {
      final apps = next.value;
      if (apps == null) return;
      _fire(_bridge.syncBlockedApps([for (final a in apps) a.appPackageId]));
    }, fireImmediately: true);

    // An emergency unblock closes whatever gate is open.
    ref.listen(emergencyControllerProvider, (previous, next) {
      if (state != null && next.isActiveAt(_clock.now())) {
        _fire(_release(ResolvedAction.emergencyOverride));
      }
    });

    return null;
  }

  // ── Entry point ──────────────────────────────────────────────────────────

  Future<void> onAttempt(String appPackageId) async {
    if (state != null || _resolving) return;
    _resolving = true;
    try {
      final now = _clock.now();
      final blocked = await _repo.findBlockedApp(appPackageId);
      if (blocked == null) return; // not on the watch list

      final session = ref.read(focusSessionControllerProvider);
      // A paused session is a deliberate break; pauses are budgeted (PRD §9.1).
      final sessionRunning = session is FocusRunning && !session.isPaused;

      if (ref.read(emergencyControllerProvider).isActiveAt(now)) {
        await _log(
          appPackageId: appPackageId,
          level: blocked.level,
          duringSession: sessionRunning,
          action: ResolvedAction.emergencyOverride,
        );
        _fire(_bridge.allow(appPackageId, FrictionRules.allowWindow));
        return;
      }

      final priorBurst = await _repo.countAttemptsSince(
        appPackageId,
        now.subtract(FrictionRules.burstWindow),
      );
      final priorToday = await _repo.countAttemptsSince(
        appPackageId,
        DateTime(now.year, now.month, now.day),
      );

      final decision = FrictionPolicy.resolve(
        base: blocked.level,
        sessionRunning: sessionRunning,
        priorAttemptsInBurstWindow: priorBurst,
        priorAttemptsToday: priorToday,
        partnerAvailable: ref.read(partnerGatewayProvider).hasPartner,
      );

      if (!ref.mounted) return;
      state = FrictionGateRequest(
        appPackageId: appPackageId,
        level: decision.level,
        baseLevel: decision.baseLevel,
        escalatedByBurst: decision.escalatedByBurst,
        duringSession: decision.duringSession,
        attemptNumberToday: decision.attemptNumberToday,
        unlockAt: switch (decision.level) {
          FrictionLevel.micro => now.add(FrictionRules.microDelay),
          FrictionLevel.reflective => now.add(FrictionRules.reflectiveDelay),
          _ => null,
        },
      );
    } finally {
      _resolving = false;
    }
  }

  // ── Resolutions ──────────────────────────────────────────────────────────

  /// Every level has this way out (PRD §11.4).
  void returnToFocus() {
    final request = state;
    if (request == null) return;
    _clearPartnerWait();
    state = null;
    _fire(
      _log(
        appPackageId: request.appPackageId,
        level: request.level,
        duringSession: request.duringSession,
        action: ResolvedAction.returnedToFocus,
      ),
    );
    _fire(_bridge.returnHome());
  }

  /// "Open anyway" for L0–L2. Returns false — and changes nothing — if the
  /// level does not allow it yet.
  bool proceed({String? reason}) {
    final request = state;
    if (request == null || !request.level.canProceedSelf) return false;

    final unlockAt = request.unlockAt;
    if (unlockAt != null && _clock.now().isBefore(unlockAt)) return false;

    final trimmed = reason?.trim();
    if (request.level == FrictionLevel.reflective &&
        (trimmed?.length ?? 0) < FrictionRules.minReasonLength) {
      return false;
    }

    state = null;
    _fire(
      _release(ResolvedAction.openedAnyway, request: request, reason: trimmed),
    );
    return true;
  }

  /// L4: ask the Vault Partner. Without a reply the cooling-off period ends
  /// in an automatic release (PRD §10.2) so nobody is stuck because their
  /// partner is asleep.
  void requestPartnerOverride(String reason) {
    final request = state;
    if (request == null ||
        request.level != FrictionLevel.partnerGated ||
        request.partner != PartnerStage.none) {
      return;
    }
    final trimmed = reason.trim();
    if (trimmed.length < FrictionRules.minReasonLength) return;

    state = request.copyWith(
      partner: PartnerStage.pending,
      coolingOffEndsAt: _clock.now().add(FrictionRules.partnerCoolingOff),
    );

    _partnerSub = ref
        .read(partnerGatewayProvider)
        .requestOverride(appPackageId: request.appPackageId, reason: trimmed)
        .listen((decision) {
          final current = state;
          if (current == null || current.partner != PartnerStage.pending)
            return;
          switch (decision) {
            case PartnerDecision.approved:
              _fire(_release(ResolvedAction.partnerApproved, reason: trimmed));
            case PartnerDecision.denied:
              _clearPartnerWait();
              state = current.copyWith(partner: PartnerStage.denied);
          }
        });

    _coolingOffTimer = Timer(FrictionRules.partnerCoolingOff, () {
      final current = state;
      if (current == null || current.partner != PartnerStage.pending) return;
      _fire(_release(ResolvedAction.partnerAutoReleased, reason: trimmed));
    });
  }

  // ── Internals ────────────────────────────────────────────────────────────

  /// Closes the open gate (or [request]) and lets the app through.
  Future<void> _release(
    ResolvedAction action, {
    FrictionGateRequest? request,
    String? reason,
  }) async {
    final open = request ?? state;
    if (open == null) return;
    _clearPartnerWait();
    state = null;

    _fire(_bridge.allow(open.appPackageId, FrictionRules.allowWindow));
    await _log(
      appPackageId: open.appPackageId,
      level: open.level,
      duringSession: open.duringSession,
      action: action,
      reason: reason,
    );
  }

  Future<void> _log({
    required String appPackageId,
    required FrictionLevel level,
    required bool duringSession,
    required ResolvedAction action,
    String? reason,
  }) {
    return _repo.logEvent(
      DistractionEvent(
        id: _uuid.v4(),
        appPackageId: appPackageId,
        level: level,
        action: action,
        occurredAt: _clock.now(),
        duringSession: duringSession,
        reasonText: reason,
      ),
    );
  }

  void _clearPartnerWait() {
    _coolingOffTimer?.cancel();
    _coolingOffTimer = null;
    unawaited(_partnerSub?.cancel());
    _partnerSub = null;
  }

  /// Side effects (DB, native) must never crash the gate or the caller.
  void _fire(Future<void> future) {
    unawaited(
      future.catchError((Object e) {
        debugPrint('FrictionGate: $e');
      }),
    );
  }
}
