# 🔗 Guia de Integração Frontend → Backend

## Status Atual

### ✅ Implementado
- [x] AuthService (login/logout)
- [x] Backend API completo
- [x] Telas do frontend

### ❌ Faltando
- [ ] Services para buscar dados reais
- [ ] Substituir dados mockados
- [ ] Tratamento de erros de API
- [ ] Loading states

---

## 📋 Tarefas de Integração

### 1. Criar Services

#### **OrcamentoService** (`lib/services/orcamento_service.dart`)
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class OrcamentoService {
  static const String baseUrl = 'http://10.0.2.2:3000/orcamentos';

  Future<List<dynamic>> getAllOrcamentos() async {
    final token = await AuthService().getToken();
    
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar orçamentos');
    }
  }

  Future<dynamic> getOrcamento(int id) async {
    final token = await AuthService().getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar orçamento');
    }
  }

  Future<dynamic> createOrcamento(Map<String, dynamic> data) async {
    final token = await AuthService().getToken();
    
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao criar orçamento');
    }
  }
}
```

#### **ClienteService** (`lib/services/cliente_service.dart`)
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ClienteService {
  static const String baseUrl = 'http://10.0.2.2:3000/clientes';

  Future<List<dynamic>> getAllClientes() async {
    final token = await AuthService().getToken();
    
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar clientes');
    }
  }
}
```

---

### 2. Atualizar HomeScreen

**Substituir:**
```dart
// ANTES (mockado)
final List<Map<String, dynamic>> _services = [
  {'id': '233', 'title': 'ARGO TRACKER', ...},
];
```

**Por:**
```dart
// DEPOIS (real)
class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrcamentos();
  }

  Future<void> _loadOrcamentos() async {
    try {
      final orcamentos = await OrcamentoService().getAllOrcamentos();
      setState(() {
        _services = orcamentos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return ServiceCard(
          id: service['id'].toString(),
          title: service['modelo'],
          subtitle: service['cliente']['nome'],
          // ... mapear campos do backend
        );
      },
    );
  }
}
```

---

### 3. Atualizar SearchScreen

```dart
Future<void> _searchClientes(String query) async {
  try {
    setState(() => _isLoading = true);
    
    final allClientes = await ClienteService().getAllClientes();
    
    final filtered = allClientes.where((cliente) {
      return cliente['nome'].toLowerCase().contains(query.toLowerCase()) ||
             cliente['cpf'].contains(query);
    }).toList();
    
    setState(() {
      _filteredClientes = filtered;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    // Tratar erro
  }
}
```

---

### 4. Atualizar MeusDadosScreen

```dart
class _MeusDadosScreenState extends State<MeusDadosScreen> {
  Map<String, dynamic>? _userData;
  Map<String, int> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStats();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService().getUserData();
    setState(() => _userData = userData);
  }

  Future<void> _loadStats() async {
    final orcamentos = await OrcamentoService().getAllOrcamentos();
    
    setState(() {
      _stats = {
        'pendentes': orcamentos.where((o) => o['status'] == 'AGUARDANDO').length,
        'emAndamento': orcamentos.where((o) => o['status'] == 'EM_MANUTENCAO').length,
        'finalizados': orcamentos.where((o) => o['status'] == 'FINALIZADO').length,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatCard(
      value: '${_stats['pendentes'] ?? 0}',
      label: 'Pendentes',
    );
  }
}
```

---

### 5. Salvar Check-in e Itens Auditados

#### **CheckinScreen**
```dart
Future<void> _proximo() async {
  // ... validações ...

  try {
    // Upload das fotos
    final fotosUrls = await _uploadFotos();

    // Salvar check-in
    await http.post(
      Uri.parse('http://10.0.2.2:3000/checkin'),
      headers: {
        'Authorization': 'Bearer ${await AuthService().getToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'orcamentoId': widget.orcamentoId,
        'quilometragem': _kmController.text,
        'fotos': fotosUrls,
        'dataCheckin': DateTime.now().toIso8601String(),
      }),
    );

    // Navegar para próxima tela
  } catch (e) {
    // Tratar erro
  }
}
```

#### **ItensAuditadosScreen**
```dart
Future<void> _proximo() async {
  // ... validações ...

  try {
    await http.post(
      Uri.parse('http://10.0.2.2:3000/itens-auditados'),
      headers: {
        'Authorization': 'Bearer ${await AuthService().getToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'orcamentoId': widget.orcamentoId,
        'itens': _itensAuditados,
      }),
    );

    // Sucesso
  } catch (e) {
    // Tratar erro
  }
}
```

---

## 🔄 Mapeamento Backend ↔ Frontend

### Orçamento (Backend)
```typescript
{
  id: number
  clienteId: number
  placa: string
  modelo: string
  status: 'AGUARDANDO' | 'EM_MANUTENCAO' | 'REJEITADO' | 'FINALIZADO' | 'CANCELADO'
  dataCriacao: DateTime
  cliente: Cliente
  orcamentoItem: OrcamentoItem
}
```

### Service Card (Frontend)
```dart
ServiceCard(
  id: orcamento['id'].toString(),
  title: orcamento['modelo'],
  subtitle: orcamento['cliente']['nome'],
  phone: orcamento['cliente']['telefone'],
  status: _mapStatus(orcamento['status']),
  statusColor: _getStatusColor(orcamento['status']),
)
```

---

## 📝 Checklist de Integração

### Prioridade Alta
- [ ] Criar OrcamentoService
- [ ] Criar ClienteService
- [ ] Atualizar HomeScreen com dados reais
- [ ] Atualizar SearchScreen com busca real
- [ ] Salvar check-in no backend

### Prioridade Média
- [ ] Atualizar MeusDadosScreen com stats reais
- [ ] Salvar itens auditados no backend
- [ ] Implementar upload de fotos
- [ ] Adicionar pull-to-refresh

### Prioridade Baixa
- [ ] Cache de dados localmente
- [ ] Modo offline
- [ ] Sincronização automática

---

## 🚨 Observações Importantes

1. **Todas as rotas do backend precisam de autenticação** (exceto `/auth/login`)
2. **Adicionar interceptor** para renovar token automaticamente
3. **Tratar erros 401** (não autenticado) redirecionando para login
4. **Loading states** em todas as telas que fazem requisições
5. **Feedback visual** para o usuário (SnackBars, dialogs)

---

## 🎯 Próximo Passo Recomendado

**Começar por:**
1. Criar `OrcamentoService`
2. Atualizar `HomeScreen` para usar dados reais
3. Testar se os orçamentos aparecem corretamente

Isso vai validar que a integração está funcionando antes de fazer o resto.

