import { ClienteService } from './cliente.service';
import { ClienteController } from './cliente.controller';
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
  controllers: [ClienteController],
  providers: [ClienteService, JwtStrategy],
})
export class ClienteModule {}
