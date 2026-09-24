import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { VaultApprovalRule, VaultPartnershipStatus } from '../../common/enums';
import { User } from './user.entity';
import { OverrideRequest } from './override-request.entity';

/** Granular, opt-in visibility flags — never all-or-nothing (PRD §10.4). */
export interface VaultPermissionScope {
  seesStreak: boolean;
  seesSessionCompletion: boolean;
  seesDistractionLog: boolean;
  seesReflectionEntries: boolean; // High-sensitivity; defaults to false
}

@Entity('vault_partnerships')
export class VaultPartnership {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.ownedPartnerships, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'owner_user_id' })
  owner: User;

  @Column({ name: 'owner_user_id' })
  ownerUserId: string;

  @ManyToOne(() => User, (user) => user.partneredPartnerships, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_user_id' })
  partner: User;

  @Column({ name: 'partner_user_id' })
  partnerUserId: string;

  @Column({ type: 'enum', enum: VaultPartnershipStatus, default: VaultPartnershipStatus.PENDING })
  status: VaultPartnershipStatus;

  @Column({ name: 'permission_scope', type: 'jsonb', default: {} })
  permissionScope: VaultPermissionScope;

  /** Relevant only when a user has more than one active partner (PRD §10.3, multi-partner). */
  @Column({ name: 'approval_rule', type: 'enum', enum: VaultApprovalRule, default: VaultApprovalRule.ANY_PARTNER })
  approvalRule: VaultApprovalRule;

  @CreateDateColumn({ type: 'timestamptz', name: 'created_at' })
  createdAt: Date;

  @Column({ name: 'revoked_at', type: 'timestamptz', nullable: true })
  revokedAt: Date | null;

  @OneToMany(() => OverrideRequest, (request) => request.partnership)
  overrideRequests: OverrideRequest[];
}
