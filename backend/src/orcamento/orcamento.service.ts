import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import type { Orcamento } from '../database/prisma';

@Injectable()
export class OrcamentoService {
  constructor(private prisma: PrismaService) {}

  async create(data: {
    clienteId: number;
    orcamentoItemId: number;
    placa: string;
    modelo: string;
    status:
      | 'AGUARDANDO'
      | 'EM_MANUTENCAO'
      | 'REJEITADO'
      | 'FINALIZADO'
      | 'CANCELADO';
  }): Promise<Orcamento> {
    return this.prisma.orcamento.create({ data });
  }

  async findAll(): Promise<Orcamento[]> {
    return this.prisma.orcamento.findMany({ include: { cliente: true, orcamentoItem: true } });
  }

  async findOne(id: number): Promise<Orcamento | null> {
    return this.prisma.orcamento.findUnique({ where: { id }, include: { cliente: true, orcamentoItem: true } });
  }

  async update(
    id: number,
    data: Partial<{
      clienteId: number;
      orcamentoItemId: number;
      placa: string;
      modelo: string;
      status:
        | 'AGUARDANDO'
        | 'EM_MANUTENCAO'
        | 'REJEITADO'
        | 'FINALIZADO'
        | 'CANCELADO';
    }>
  ): Promise<Orcamento> {
    return this.prisma.orcamento.update({ where: { id }, data });
  }

  async remove(id: number): Promise<Orcamento> {
    return this.prisma.orcamento.delete({ where: { id } });
  }
}