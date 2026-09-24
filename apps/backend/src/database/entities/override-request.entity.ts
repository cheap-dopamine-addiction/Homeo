import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { OverrideRequestStatus } from '../../common/enums';
import { VaultPartnership } from './vault-partnership.entity';
import { User } from './user.entity';

@Entity('override_requests')
export class OverrideRequest {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => VaultPartnership, (partnership) => partnership.overrideRequests, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partnership_id' })
  partnership: VaultPartnership;

  @Column({ name: 'partnership_id' })
  partnershipId: string;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'requested_by_user_id' })
  requestedBy: User;

  @Column({ name: 'requested_by_user_id' })
  requestedByUserId: string;

  @Column({ name: 'app_package_id', type: 'text' })
  appPackageId: string;

  /** Scoped data only — never the underlying content the user was consuming (PRD §10.4). */
  @Column({ name: 'reason_text', type: 'text' })
  reasonText: string;

  @Column({ type: 'enum', enum: OverrideRequestStatus, default: OverrideRequestStatus.PENDING })
  status: OverrideRequestStatus;

  @CreateDateColumn({ type: 'timestamptz', name: 'requested_at' })
  requestedAt: Date;

  @Column({ name: 'resolved_at', type: 'timestamptz', nullable: true })
  resolvedAt: Date | null;

  @Column({ name: 'resolved_by_user_id', type: 'uuid', nullable: true })
  resolvedByUserId: string | null;
}
