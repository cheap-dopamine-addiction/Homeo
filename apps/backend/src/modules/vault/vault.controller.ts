import { Body, Controller, Param, ParseUUIDPipe, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard'; // defined in AuthModule
import { CurrentUser } from '../../common/decorators/current-user.decorator'; // defined in AuthModule
import { VaultService } from './vault.service';
import { CreateOverrideRequestDto } from './dto/create-override-request.dto';
import { ResolveOverrideRequestDto } from './dto/resolve-override-request.dto';
import { OverrideRequestResponseDto } from './dto/override-request-response.dto';

@ApiTags('vault')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v1/vault/override-requests')
export class VaultController {
  constructor(private readonly vaultService: VaultService) {}

  @Post()
  @ApiCreatedResponse({ type: OverrideRequestResponseDto })
  create(@CurrentUser('id') userId: string, @Body() dto: CreateOverrideRequestDto) {
    return this.vaultService.createOverrideRequest(userId, dto);
  }

  @Post(':id/approve')
  approve(@CurrentUser('id') userId: string, @Param('id', ParseUUIDPipe) id: string) {
    return this.vaultService.resolve(id, userId, 'approved');
  }

  @Post(':id/deny')
  deny(
    @CurrentUser('id') userId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() _dto: ResolveOverrideRequestDto,
  ) {
    return this.vaultService.resolve(id, userId, 'denied');
  }
}
