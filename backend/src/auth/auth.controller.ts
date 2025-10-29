import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpException,
  HttpStatus,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { JwtRefreshGuard } from './guards/jwt-refresh.guard';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { IsEmail, IsNotEmpty } from 'class-validator';
import { User } from '@prisma/client';

export class LoginDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsNotEmpty()
  password: string;
}

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @HttpCode(200)
  async login(@Body() loginDto: LoginDto) {
    const user: User = await this.authService.validateUser(
      loginDto.email,
      loginDto.password,
    );

    return this.authService.login(user);
  }

  @UseGuards(JwtRefreshGuard)
  @Post('refresh')
  @HttpCode(200)
  async refresh(@Req() req) {
    return this.authService.refreshAccessToken(
      req.user.sub,
      req.user.refreshToken,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('hello')
  getHello(): string {
    return "{ message: 'Hello World!' }";
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  @HttpCode(200)
  async logout(@Req() req) {
    const user = req.user as { userId?: number };

    if (!user?.userId) {
      throw new HttpException(
        'User ID not found in request',
        HttpStatus.UNAUTHORIZED,
      );
    }
    await this.authService.logout(user.userId);

    return { message: 'Logged out successfully' };
  }
}
