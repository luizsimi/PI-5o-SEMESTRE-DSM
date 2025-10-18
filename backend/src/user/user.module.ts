import { forwardRef, Module } from '@nestjs/common';
import { UserService } from './user.service';
import { PrismaModule } from '../database/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  imports: [forwardRef(() => AuthModule), PrismaModule],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
