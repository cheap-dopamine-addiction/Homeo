import { ApiProperty } from '@nestjs/swagger';
import { OverrideRequestStatus } from '../../../common/enums';

/**
 * Shape of `data` inside the standard { data, error, meta } envelope (PRD §18.1)
 * for a single override request.
 */
export class OverrideRequestResponseDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ enum: OverrideRequestStatus })
  status: OverrideRequestStatus;

  @ApiProperty({ type: String, format: 'date-time' })
  requestedAt: string;

  @ApiProperty({
    type: String,
    format: 'date-time',
    description: 'When this request auto-releases if the partner never responds (PRD §10.2).',
  })
  coolingOffExpiresAt: string;
}
