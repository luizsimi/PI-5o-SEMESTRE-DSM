import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { OrcamentoItemService } from './orcamento_item.service';
import type { OrcamentoItem, TipoOrcamento } from '../database/prisma/';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('orcamento-items')
export class OrcamentoItemController {
  constructor(private readonly orcamentoItemService: OrcamentoItemService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async create(@Body() data: { tipoOrcamento: TipoOrcamento; orcamentoValor: number }): Promise<OrcamentoItem> {
    const item = await this.orcamentoItemService.create(data);
    return item;
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  async findAll(): Promise<OrcamentoItem[]> {
    const items = await this.orcamentoItemService.findAll();
    return items;
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async findOne(@Param('id') id: string): Promise<OrcamentoItem | null> {
    const item = await this.orcamentoItemService.findOne(Number(id));
    return item;
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() data: Partial<{ tipoOrcamento: TipoOrcamento; orcamentoValor: number }>
  ): Promise<OrcamentoItem> {
    const item = await this.orcamentoItemService.update(Number(id), data);
    return item;
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async remove(@Param('id') id: string): Promise<OrcamentoItem> {
    const item = await this.orcamentoItemService.remove(Number(id));
    return item;
  }
}