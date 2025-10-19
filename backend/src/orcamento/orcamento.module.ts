// src/orcamento/orcamento.module.ts
import { Module } from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import { OrcamentoController } from './orcamento.controller';
import { PrismaModule } from '../database/prisma/prisma.module';

@Module({
  imports: [PrismaModule],       
  providers: [OrcamentoService],
  controllers: [OrcamentoController], 
})
export class OrcamentoModule {}
