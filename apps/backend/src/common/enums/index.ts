// Shared enums — kept in sync with the PostgreSQL enum types in db/schema.sql
// and reused by TypeORM entities, DTOs, and the OpenAPI contract exported
// to the Flutter client (see PRD §28, packages/api-contracts).

export enum AuthProvider {
  EMAIL = 'email',
  GOOGLE = 'google',
  APPLE = 'apple',
}

export enum FocusSessionStatus {
  ACTIVE = 'active',
  COMPLETED = 'completed',
  ABORTED = 'aborted',
}

export enum DistractionResolvedAction {
  RETURNED_TO_FOCUS = 'returned_to_focus',
  OPENED_ANYWAY = 'opened_anyway',
  PARTNER_APPROVED = 'partner_approved',
  EMERGENCY_OVERRIDE = 'emergency_override',
}

export enum VaultPartnershipStatus {
  PENDING = 'pending',
  ACTIVE = 'active',
  REVOKED = 'revoked',
}

export enum VaultApprovalRule {
  ANY_PARTNER = 'any_partner',
  ALL_PARTNERS = 'all_partners',
}

export enum OverrideRequestStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  DENIED = 'denied',
  EXPIRED_AUTO_RELEASED = 'expired_auto_released',
}

/** Friction levels L0–L4, PRD §11.2 */
export enum FrictionLevel {
  AWARENESS = 0,
  MICRO_FRICTION = 1,
  REFLECTIVE_PAUSE = 2,
  FULL_BLOCK = 3,
  PARTNER_GATED = 4,
}
