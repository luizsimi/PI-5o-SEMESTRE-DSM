import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import type { Orcamento } from '../../generated/prisma/client';

@Injectable()
export class OrcamentoService {
  constructor(private prisma: PrismaService) {}

  async create(data: {
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
    return this.prisma.orcamento.create({ data });
  }

  async findAll(): Promise<Orcamento[]> {
    return this.prisma.orcamento.findMany({ include: { cliente: true } });
  }

  async findOne(id: number): Promise<Orcamento | null> {
    return this.prisma.orcamento.findUnique({ where: { id }, include: { cliente: true } });
  }

  async update(
    id: number,
    data: Partial<{
      clienteId: number;
      placa: string;
      modelo: string;
      status: string;
      classificacao: string;
      pecaDescricao: string;
      pecaValor: number;
      servicoDescricao: string;
      servicoValor: number;
    }>
  ): Promise<Orcamento> {
    return this.prisma.orcamento.update({ where: { id }, data });
  }

  async remove(id: number): Promise<Orcamento> {
    return this.prisma.orcamento.delete({ where: { id } });
  }
}
