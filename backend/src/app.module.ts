import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';

import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { ClienteModule } from './cliente/cliente.module';
import { OrcamentoModule } from './orcamento/orcamento.module';
import { OrcamentoItemModule } from './orcamento_item/orcamento_item.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    AuthModule,
    UserModule,
    ClienteModule,
    OrcamentoModule,
    OrcamentoItemModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

