import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectQueue } from '@nestjs/bullmq';
import { InjectRepository } from '@nestjs/typeorm';
import { Queue } from 'bullmq';
import { Between, Repository } from 'typeorm';
import { OverrideRequest } from '../../database/entities/override-request.entity';
import { VaultPartnership } from '../../database/entities/vault-partnership.entity';
import { OverrideRequestStatus, VaultPartnershipStatus } from '../../common/enums';
import { CreateOverrideRequestDto } from './dto/create-override-request.dto';

/** PRD §10.2 — default window before an unanswered request auto-releases. */
const COOLING_OFF_MINUTES = 20;
/** PRD §10.3 — rate limit to prevent Owner spamming the Partner with requests. */
const MAX_REQUESTS_PER_DAY = 3;

@Injectable()
export class VaultService {
  constructor(
    @InjectRepository(VaultPartnership)
    private readonly partnerships: Repository<VaultPartnership>,
    @InjectRepository(OverrideRequest)
    private readonly overrideRequests: Repository<OverrideRequest>,
    @InjectQueue('vault-cooling-off')
    private readonly coolingOffQueue: Queue,
  ) {}

  async createOverrideRequest(requestedByUserId: string, dto: CreateOverrideRequestDto) {
    const partnership = await this.partnerships.findOneBy({ id: dto.partnershipId });

    if (!partnership || partnership.status !== VaultPartnershipStatus.ACTIVE) {
      throw new NotFoundException('VAULT_PARTNERSHIP_NOT_FOUND');
    }

    // Ownership check — only the Owner side of the partnership may request an override.
    // Resource-level check on top of the JWT scope guard, per PRD §19.2 (IDOR prevention).
    if (partnership.ownerUserId !== requestedByUserId) {
      throw new ForbiddenException('VAULT_NOT_PARTNERSHIP_OWNER');
    }

    await this.assertUnderDailyRateLimit(dto.partnershipId, requestedByUserId);

    const requestedAt = new Date();
    const coolingOffExpiresAt = new Date(requestedAt.getTime() + COOLING_OFF_MINUTES * 60_000);

    const request = await this.overrideRequests.save(
      this.overrideRequests.create({
        partnershipId: dto.partnershipId,
        requestedByUserId,
        appPackageId: dto.appPackageId,
        reasonText: dto.reasonText,
        status: OverrideRequestStatus.PENDING,
        requestedAt,
      }),
    );

    // Realtime notify (WebSocket + push fallback) is dispatched by NotificationModule,
    // subscribed to this queue's 'requested' event — not shown here.
    await this.coolingOffQueue.add(
      'auto-release',
      { overrideRequestId: request.id },
      { delay: COOLING_OFF_MINUTES * 60_000 },
    );

    return { ...request, coolingOffExpiresAt };
  }

  async resolve(requestId: string, resolvedByUserId: string, decision: 'approved' | 'denied') {
    const request = await this.overrideRequests.findOneBy({ id: requestId });
    if (!request) throw new NotFoundException('VAULT_OVERRIDE_REQUEST_NOT_FOUND');
    if (request.status !== OverrideRequestStatus.PENDING) {
      throw new BadRequestException('VAULT_OVERRIDE_REQUEST_ALREADY_RESOLVED');
    }

    const partnership = await this.partnerships.findOneBy({ id: request.partnershipId });
    // Only the Partner side may approve/deny — mirrors the Owner-only check above.
    if (!partnership || partnership.partnerUserId !== resolvedByUserId) {
      throw new ForbiddenException('VAULT_NOT_PARTNERSHIP_PARTNER');
    }

    request.status = decision === 'approved' ? OverrideRequestStatus.APPROVED : OverrideRequestStatus.DENIED;
    request.resolvedAt = new Date();
    request.resolvedByUserId = resolvedByUserId;

    // The pending cooling-off job becomes a no-op once status leaves 'pending' —
    // the auto-release worker re-checks status before releasing (idempotent by design).
    return this.overrideRequests.save(request);
  }

  private async assertUnderDailyRateLimit(partnershipId: string, ownerUserId: string) {
    const since = new Date();
    since.setHours(0, 0, 0, 0);

    const countToday = await this.overrideRequests.count({
      where: {
        partnershipId,
        requestedByUserId: ownerUserId,
        requestedAt: Between(since, new Date()),
      },
    });

    if (countToday >= MAX_REQUESTS_PER_DAY) {
      throw new BadRequestException('VAULT_OVERRIDE_RATE_LIMIT_EXCEEDED');
    }
  }
}
