import { Controller, Get, Post, Param, Body, Put, Delete } from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import type { Orcamento } from '../../generated/prisma/client';

@Controller('orcamentos')
export class OrcamentoController {
  constructor(private readonly orcamentoService: OrcamentoService) {}

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

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Orcamento> {
    return this.orcamentoService.remove(Number(id));
  }
}
