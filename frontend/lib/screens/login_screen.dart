import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  AnimationController? _shakeController;
  Animation<double>? _shakeAnimation;
  
  AnimationController? _carController;
  Animation<double>? _carAnimation;

  @override
  void initState() {
    super.initState();
    _setupShakeAnimation();
    _setupCarAnimation();
    _loadRememberMe();
    
    // Auto-focus no email após build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  void _setupShakeAnimation() {
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController!);
  }
  
  void _setupCarAnimation() {
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _carAnimation = Tween<double>(begin: -30, end: 30)
      .chain(CurveTween(curve: Curves.easeInOut))
      .animate(_carController!);
  }

  Future<void> _loadRememberMe() async {
    // Carregar email salvo se "lembrar-me" estava ativo
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      final rememberMe = prefs.getBool('remember_me') ?? false;
      
      if (rememberMe && savedEmail != null) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
      }
    } catch (e) {
      // Silenciosamente falha se SharedPreferences não estiver disponível
    }
  }

  Future<void> _saveRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_email', _emailController.text);
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('saved_email');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      // Silenciosamente falha
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _shakeController?.dispose();
    _carController?.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Por favor, digite um email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _triggerShakeAnimation() {
    _shakeController?.forward(from: 0);
  }

  Future<void> _handleLogin() async {
    // Validar form
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      _triggerShakeAnimation();
      return;
    }

    // Fechar teclado
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
    final success = await _authService.login(
        _emailController.text.trim(),
      _passwordController.text,
    );

      if (!mounted) return;

    if (success) {
        // Salvar "lembrar-me"
        await _saveRememberMe();
        
        // Feedback de sucesso
        HapticFeedback.lightImpact();
        _showSuccessSnackBar('Login realizado com sucesso!');
        
        // Aguardar um pouco para mostrar o feedback
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!mounted) return;
        
        // Navegar com transição suave
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              
              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
      );
    } else {
        // Erro de autenticação
        HapticFeedback.heavyImpact();
        _triggerShakeAnimation();
        _showErrorSnackBar('Email ou senha incorretos');
      }
    } catch (e) {
      if (!mounted) return;
      
      HapticFeedback.heavyImpact();
      _triggerShakeAnimation();
      
      // Tratamento específico de erros
      String errorMessage = 'Erro ao fazer login';
      
      if (e.toString().contains('SocketException') || 
          e.toString().contains('NetworkException')) {
        errorMessage = 'Sem conexão com a internet';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tempo de conexão esgotado';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Erro ao processar resposta do servidor';
      }
      
      _showErrorSnackBar(errorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.lock_reset, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              'Recuperar Senha',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite seu email para receber instruções de recuperação de senha.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'seu@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                _showErrorSnackBar('Por favor, digite um email válido');
                return;
              }
              
              Navigator.pop(context);
              _showSuccessSnackBar('Instruções enviadas para ${emailController.text}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
          ),
          
          // Content
          SafeArea(
          child: Center(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: AnimatedBuilder(
                    animation: _shakeAnimation ?? const AlwaysStoppedAnimation(0),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation?.value ?? 0, 0),
                        child: child,
                      );
                    },
                    child: Form(
                      key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          // Logo com fade in
                          Hero(
                            tag: 'logo',
                            child: Image.asset(
                      'assets/images/logo.png',
                      width: 300,
                      height: 300,
                            ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Email field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                      style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey[700],
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                            width: 2,
                          ),
                        ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  height: 0.8,
                                ),
                              ),
                              validator: _validateEmail,
                              onFieldSubmitted: (_) {
                                _passwordFocus.requestFocus();
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                    
                    // Password field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                      controller: _passwordController,
                              focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              enabled: !_isLoading,
                      style: const TextStyle(
                        fontSize: 16,
                                color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        hintStyle: TextStyle(
                                  color: Colors.grey[600],
                          fontSize: 16,
                        ),
                                prefixIcon: Icon(
                                  Icons.lock_outlined,
                                  color: Colors.grey[700],
                                  size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                                    _obscurePassword 
                                      ? Icons.visibility_outlined 
                                      : Icons.visibility_off_outlined,
                                    color: Colors.grey[700],
                                    size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  height: 0.8,
                                ),
                              ),
                              validator: _validatePassword,
                              onFieldSubmitted: (_) {
                                _handleLogin();
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Lembrar-me e Esqueci senha
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Checkbox Lembrar-me
                              Expanded(
                                child: InkWell(
                                  onTap: _isLoading ? null : () {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                    HapticFeedback.selectionClick();
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: _isLoading ? null : (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                              HapticFeedback.selectionClick();
                                            },
                                            activeColor: AppColors.white,
                                            checkColor: AppColors.primary,
                                            side: const BorderSide(
                                              color: AppColors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Lembrar-me',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Link Esqueci senha
                              TextButton(
                                onPressed: _isLoading ? null : _showForgotPasswordDialog,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Botão Entrar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                        ),
                              disabledBackgroundColor: Colors.white.withOpacity(0.7),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                                    width: 24,
                                    height: 24,
                              child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                              ),
                            ),
                    ),
                          
                          // Botão de teste - apenas em desenvolvimento
                          if (const bool.fromEnvironment('dart.vm.product') == false) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                              onPressed: _isLoading ? null : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.white,
                                  width: 1.5,
                                ),
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                                'Entrar (modo teste)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Loading overlay com animação de carro
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animação de carro
                        AnimatedBuilder(
                          animation: _carAnimation ?? const AlwaysStoppedAnimation(0),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_carAnimation?.value ?? 0, 0),
                              child: const Icon(
                                Icons.directions_car,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Indicador de progresso linear
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const LinearProgressIndicator(
                              backgroundColor: Color(0xFFE0E0E0),
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Autenticando...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
