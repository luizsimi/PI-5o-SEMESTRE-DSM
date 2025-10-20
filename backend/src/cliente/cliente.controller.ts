import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards} from '@nestjs/common';
import { ClienteService } from './cliente.service';
import type { Cliente } from '../../generated/prisma/client';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('clientes') 
export class ClienteController {
  constructor(private readonly clienteService: ClienteService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async create(
    @Body() data: { nome: string; cpf: string; telefone: string }
  ): Promise<Cliente> {
    return this.clienteService.create(data);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  async findAll(): Promise<Cliente[]> {
    return this.clienteService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Cliente | null> {
    return this.clienteService.findOne(Number(id));
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() data: Partial<{ nome: string; cpf: string; telefone: string }>
  ): Promise<Cliente> {
    return this.clienteService.update(Number(id), data);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Cliente> {
    return this.clienteService.remove(Number(id));
  }
}
