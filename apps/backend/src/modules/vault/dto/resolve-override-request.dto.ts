import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

/** Body for both POST .../approve and POST .../deny — the route itself carries the decision. */
export class ResolveOverrideRequestDto {
  @ApiPropertyOptional({ maxLength: 280, description: 'Optional note from the Vault Partner.' })
  @IsOptional()
  @IsString()
  @MaxLength(280)
  note?: string;
}
