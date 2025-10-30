// 📱 EXEMPLOS PRÁTICOS DE USO DO LOGIN

import 'package:flutter/material.dart';
import 'services/auth_service.dart';

// ==========================================
// EXEMPLO 1: MOSTRAR NOME DO USUÁRIO NA APPBAR
// ==========================================

class ExemploAppBarComUsuario extends StatefulWidget {
  const ExemploAppBarComUsuario({super.key});

  @override
  State<ExemploAppBarComUsuario> createState() => _ExemploAppBarComUsuarioState();
}

class _ExemploAppBarComUsuarioState extends State<ExemploAppBarComUsuario> {
  String _userName = 'Carregando...';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService().getUserData();
    if (userData != null) {
      setState(() {
        _userName = '${userData['firstName']} ${userData['lastName']}';
        _userEmail = userData['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_userName, style: const TextStyle(fontSize: 16)),
            Text(_userEmail, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Center(
        child: Text('Bem-vindo, $_userName!'),
      ),
    );
  }
}

// ==========================================
// EXEMPLO 2: TELA DE PERFIL COM DADOS DO USUÁRIO
// ==========================================

class ExemploPerfilScreen extends StatefulWidget {
  const ExemploPerfilScreen({super.key});

  @override
  State<ExemploPerfilScreen> createState() => _ExemploPerfilScreenState();
}

class _ExemploPerfilScreenState extends State<ExemploPerfilScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService().getUserData();
    setState(() {
      _userData = userData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar dados')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Nome', '${_userData!['firstName']} ${_userData!['lastName']}'),
            _buildInfoCard('Email', _userData!['email']),
            _buildInfoCard('Telefone', _userData!['phoneNumber']),
            _buildInfoCard('CPF', _userData!['cpf']),
            _buildInfoCard('Loja', _userData!['store']['name']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// EXEMPLO 3: FAZER REQUISIÇÃO COM TOKEN
// ==========================================

import 'dart:convert';
import 'package:http/http.dart' as http;

class ExemploRequisicaoComToken {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Buscar todos os clientes (endpoint protegido)
  static Future<List<dynamic>> buscarClientes() async {
    try {
      final token = await AuthService().getToken();

      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/clientes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido ou expirado');
      } else {
        throw Exception('Erro ao buscar clientes: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }

  // Criar novo cliente
  static Future<Map<String, dynamic>> criarCliente({
    required String nome,
    required String cpf,
    required String telefone,
  }) async {
    try {
      final token = await AuthService().getToken();

      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/clientes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nome': nome,
          'cpf': cpf,
          'telefone': telefone,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao criar cliente: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }
}

// ==========================================
// EXEMPLO 4: BOTÃO DE LOGOUT FUNCIONAL
// ==========================================

class Exemplo LoutWidget extends StatelessWidget {
  const ExemploLogoutWidget({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Mostrar dialog de confirmação
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      // Fazer logout
      await AuthService().logout();

      // Navegar para tela de login
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove todas as rotas anteriores
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleLogout(context),
      icon: const Icon(Icons.logout),
      label: const Text('Sair'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// ==========================================
// EXEMPLO 5: GUARD PARA PROTEGER ROTAS
// ==========================================

class ExemploGuardRoute extends StatelessWidget {
  final Widget child;

  const ExemploGuardRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        // Ainda carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Usuário logado
        if (snapshot.data == true) {
          return child;
        }

        // Usuário não logado - redireciona para login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

// USO:
// 
// class MinhaTelaProtegida extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ExemploGuardRoute(
//       child: Scaffold(
//         appBar: AppBar(title: Text('Tela Protegida')),
//         body: Center(child: Text('Conteúdo protegido')),
//       ),
//     );
//   }
// }

// ==========================================
// EXEMPLO 6: SERVICE GENÉRICO COM TOKEN
// ==========================================

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // GET genérico
  static Future<dynamic> get(String endpoint) async {
    final token = await AuthService().getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  // POST genérico
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final token = await AuthService().getToken();
    
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  // PUT genérico
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final token = await AuthService().getToken();
    
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  // DELETE genérico
  static Future<dynamic> delete(String endpoint) async {
    final token = await AuthService().getToken();
    
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }
}

// USO:
//
// // Buscar clientes
// final clientes = await ApiService.get('/clientes');
//
// // Criar cliente
// final novoCliente = await ApiService.post('/clientes', {
//   'nome': 'João Silva',
//   'cpf': '12345678900',
//   'telefone': '11999999999',
// });
//
// // Atualizar cliente
// final clienteAtualizado = await ApiService.put('/clientes/1', {
//   'nome': 'João Silva Atualizado',
// });
//
// // Deletar cliente
// await ApiService.delete('/clientes/1');

// ==========================================
// EXEMPLO 7: INTERCEPTOR PARA REFRESH TOKEN AUTOMÁTICO
// ==========================================

class ApiServiceComRefresh {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<dynamic> get(String endpoint) async {
    try {
      return await _makeRequest('GET', endpoint);
    } on Exception catch (e) {
      if (e.toString().contains('401')) {
        // Tentar refresh do token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Tentar novamente
          return await _makeRequest('GET', endpoint);
        }
      }
      rethrow;
    }
  }

  static Future<dynamic> _makeRequest(String method, String endpoint, [Map<String, dynamic>? body]) async {
    final token = await AuthService().getToken();
    
    late http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        break;
      case 'POST':
        response = await http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );
        break;
      // ... outros métodos
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('401');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  static Future<bool> _refreshToken() async {
    try {
      // Implementar lógica de refresh token
      // Chamar endpoint /auth/refresh
      // Salvar novo access_token
      return true;
    } catch (e) {
      return false;
    }
  }
}

// ==========================================
// RESUMO DE USO
// ==========================================

/*

1. VERIFICAR SE ESTÁ LOGADO:
   final isLoggedIn = await AuthService().isLoggedIn();

2. OBTER DADOS DO USUÁRIO:
   final userData = await AuthService().getUserData();
   final nome = userData?['firstName'];

3. OBTER TOKEN:
   final token = await AuthService().getToken();

4. FAZER LOGOUT:
   await AuthService().logout();

5. FAZER REQUISIÇÃO COM TOKEN:
   final response = await http.get(
     Uri.parse('http://10.0.2.2:3000/clientes'),
     headers: {
       'Authorization': 'Bearer $token',
       'Content-Type': 'application/json',
     },
   );

6. USAR APISERVICE:
   final clientes = await ApiService.get('/clientes');

7. PROTEGER ROTA:
   return ExemploGuardRoute(child: MinhaTelaProtegida());

*/

