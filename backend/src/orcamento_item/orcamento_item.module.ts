import { Module } from '@nestjs/common';
import { OrcamentoItemService } from './orcamento_item.service';
import { OrcamentoItemController } from './orcamento_item.controller';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [AuthModule],
  controllers: [OrcamentoItemController],
  providers: [OrcamentoItemService, PrismaService],
})
export class OrcamentoItemModule {}