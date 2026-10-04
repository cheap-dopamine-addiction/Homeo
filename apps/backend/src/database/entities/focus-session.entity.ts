import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { FocusSessionStatus } from '../../common/enums';
import { User } from './user.entity';

@Entity('focus_sessions')
export class FocusSession {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.focusSessions, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ name: 'user_id' })
  userId: string;

  /** Implementation-intention text captured before the session starts (PRD §3.2, Gollwitzer) */
  @Column({ type: 'text' })
  intention: string;

  @Column({ name: 'planned_duration_sec', type: 'int' })
  plannedDurationSec: number;

  @Column({ name: 'actual_duration_sec', type: 'int', nullable: true })
  actualDurationSec: number | null;

  @Column({ type: 'enum', enum: FocusSessionStatus, default: FocusSessionStatus.ACTIVE })
  status: FocusSessionStatus;

  @Column({ name: 'started_at', type: 'timestamptz' })
  startedAt: Date;

  @Column({ name: 'ended_at', type: 'timestamptz', nullable: true })
  endedAt: Date | null;

  /**
   * Client-generated UUID, written at creation time on-device (Drift). Doubles as the
   * idempotency key for POST /v1/focus-sessions/sync so a retried batch never double-inserts
   * a session that already landed (PRD §22.4).
   */
  @Column({ name: 'local_id', type: 'uuid' })
  localId: string;

  @Column({ name: 'synced_at', type: 'timestamptz', nullable: true })
  syncedAt: Date | null;
}
