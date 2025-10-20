import { Controller, Get, Post, Param, Body, Put, Delete, UseGuards } from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import type { Orcamento } from '../../generated/prisma/client';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('orcamentos')
export class OrcamentoController {
  constructor(private readonly orcamentoService: OrcamentoService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async create(@Body() data: {
    clienteId: number;
    placa: string;
    modelo: string;
    status: string;
    classificacao: string;
    pecaDescricao: string;
    pecaValor: number;
    servicoDescricao: string;
    servicoValor: number;
  }): Promise<Orcamento> {
    return this.orcamentoService.create(data);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  async findAll(): Promise<Orcamento[]> {
    return this.orcamentoService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Orcamento | null> {
    return this.orcamentoService.findOne(Number(id));
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() data: Partial<{
      clienteId: number;
      placa: string;
      modelo: string;
      status: string;
      classificacao: string;
      pecaDescricao: string;
      pecaValor: number;
      servicoDescricao: string;
      servicoValor: number;
    }>,
  ): Promise<Orcamento> {
    return this.orcamentoService.update(Number(id), data);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Orcamento> {
    return this.orcamentoService.remove(Number(id));
  }
}
