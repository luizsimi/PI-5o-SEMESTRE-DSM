import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { OrcamentoItem, TipoOrcamento } from '@prisma/client';

@Injectable()
export class OrcamentoItemService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: { tipoOrcamento: TipoOrcamento; orcamentoValor: number }): Promise<OrcamentoItem> {
    const item = await this.prisma.orcamentoItem.create({ data });
    return item;
  }

  async findAll(): Promise<OrcamentoItem[]> {
    const items = await this.prisma.orcamentoItem.findMany({ include: { orcamentos: true } });
    return items;
  }

  async findOne(id: number): Promise<OrcamentoItem | null> {
    const item = await this.prisma.orcamentoItem.findUnique({ where: { id }, include: { orcamentos: true } });
    return item;
  }

  async update(id: number, data: Partial<{ tipoOrcamento: TipoOrcamento; orcamentoValor: number }>): Promise<OrcamentoItem> {
    const item = await this.prisma.orcamentoItem.update({ where: { id }, data });
    return item;
  }

  async remove(id: number): Promise<OrcamentoItem> {
    const item = await this.prisma.orcamentoItem.delete({ where: { id } });
    return item;
  }
}