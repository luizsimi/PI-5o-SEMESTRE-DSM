import { Module } from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import { OrcamentoController } from './orcamento.controller';
import { PrismaService } from '../database/prisma/prisma.service';

@Module({
  providers: [OrcamentoService, PrismaService],
  controllers: [OrcamentoController],
})
export class OrcamentoModule {}
