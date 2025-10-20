import { OrcamentoService } from './orcamento.service';
import { OrcamentoController } from './orcamento.controller';
import { PrismaService } from '../database/prisma/prisma.service';
import { JwtStrategy } from '../auth/strategies/jwt.strategy';
import { forwardRef, Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [
      forwardRef(() => AuthModule),
      PassportModule.register({ defaultStrategy: 'jwt' }),
      JwtModule.register({
        secret: process.env.JWT_SECRET || 'secretKey',
        signOptions: { expiresIn: '15s' },
      }),
    ],
  providers: [OrcamentoService, PrismaService, JwtStrategy],
  controllers: [OrcamentoController],
})
export class OrcamentoModule {}
