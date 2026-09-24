import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { AuthProvider } from '../../common/enums';
import { FocusSession } from './focus-session.entity';
import { VaultPartnership } from './vault-partnership.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ name: 'display_name' })
  displayName: string;

  @Column({ type: 'enum', enum: AuthProvider, name: 'auth_provider' })
  authProvider: AuthProvider;

  @CreateDateColumn({ type: 'timestamptz', name: 'created_at' })
  createdAt: Date;

  /** IANA tz name — drives local-time logic for quiet hours, protected hours, etc. */
  @Column({ type: 'text' })
  timezone: string;

  @Column({ type: 'timestamptz', name: 'onboarding_completed_at', nullable: true })
  onboardingCompletedAt: Date | null;

  /** Soft delete — required to support GDPR-style erasure without cascading data loss mid-flight (PRD §24.2) */
  @DeleteDateColumn({ type: 'timestamptz', name: 'deleted_at' })
  deletedAt: Date | null;

  @OneToMany(() => FocusSession, (session) => session.user)
  focusSessions: FocusSession[];

  @OneToMany(() => VaultPartnership, (partnership) => partnership.owner)
  ownedPartnerships: VaultPartnership[];

  @OneToMany(() => VaultPartnership, (partnership) => partnership.partner)
  partneredPartnerships: VaultPartnership[];
}
