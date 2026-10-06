import 'package:flutter/foundation.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';

/// How a gate ended (PRD §16.2 `distraction_events.resolved_action`).
///
/// Stored by `name`, so only ever append new values.
enum ResolvedAction {
  returnedToFocus,
  openedAnyway,
  partnerApproved,

  /// Partner did not answer within the cooling-off period (PRD §10.3).
  partnerAutoReleased,
  emergencyOverride,

  /// Warning-only detection (no gate, no blocking): Android accessibility
  /// event or iOS Shortcuts deep link. The user was notified, nothing more.
  notified,
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
