import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Put,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import type { Orcamento } from '../database/prisma';
import { Status } from '../database/prisma';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@UseGuards(JwtAuthGuard) 
@Controller('orcamentos')
export class OrcamentoController {
  constructor(private readonly orcamentoService: OrcamentoService) {}

  @Post()
  async create(@Body() data: {
    clienteId: number;
    orcamentoItemId: number;
    placa: string;
    modelo: string;
    status: Status;
  }): Promise<Orcamento> {
    return this.orcamentoService.create(data);
  }

  @Get()
  async findAll(): Promise<Orcamento[]> {
    return this.orcamentoService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Orcamento | null> {
    return this.orcamentoService.findOne(Number(id));
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() data: Partial<{
      clienteId: number;
      orcamentoItemId: number;
      placa: string;
      modelo: string;
      status: Status;
    }>,
  ): Promise<Orcamento> {
    return this.orcamentoService.update(Number(id), data);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Orcamento> {
    return this.orcamentoService.remove(Number(id));
  }
}