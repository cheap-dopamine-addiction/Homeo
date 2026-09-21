import 'package:flutter/foundation.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';

/// How a gate ended (PRD §16.2 `distraction_events.resolved_action`).
enum ResolvedAction {
  returnedToFocus,
  openedAnyway,
  partnerApproved,

  /// Partner did not answer within the cooling-off period (PRD §10.3).
  partnerAutoReleased,
  emergencyOverride,
}

@immutable
class DistractionEvent {
  const DistractionEvent({
    required this.id,
    required this.appPackageId,
    required this.level,
    required this.action,
    required this.occurredAt,
    required this.duringSession,
    this.reasonText,
  });

  final String id;
  final String appPackageId;
  final FrictionLevel level;
  final ResolvedAction action;
  final DateTime occurredAt;
  final bool duringSession;
  final String? reasonText;
}
