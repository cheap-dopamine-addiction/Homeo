import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsUUID, MaxLength } from 'class-validator';

export class CreateOverrideRequestDto {
  @ApiProperty({ description: 'Vault partnership this request is scoped to', format: 'uuid' })
  @IsUUID()
  partnershipId: string;

  @ApiProperty({ example: 'com.instagram.android' })
  @IsString()
  @IsNotEmpty()
  appPackageId: string;

  @ApiProperty({
    maxLength: 280,
    description: 'Shown to the Vault Partner verbatim — kept short by design (PRD §10.4).',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(280)
  reasonText: string;
}
