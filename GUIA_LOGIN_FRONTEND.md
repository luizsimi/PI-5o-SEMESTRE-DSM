# 🔐 Guia de Login - Frontend Flutter

## ✅ **O QUE JÁ ESTÁ IMPLEMENTADO**

### 1. **AuthService Completo** (`lib/services/auth_service.dart`)
- ✅ Conexão com backend NestJS
- ✅ Login com email e senha
- ✅ Salvamento de tokens (access_token + refresh_token)
- ✅ Salvamento de dados do usuário
- ✅ Verificação de login (isLoggedIn)
- ✅ Logout
- ✅ Tratamento de erros específicos
- ✅ Timeout de 10 segundos

### 2. **Tela de Login Premium** (`lib/screens/login_screen.dart`)
- ✅ Design moderno com Material Design 3
- ✅ Validação em tempo real
- ✅ Mensagens de erro inline
- ✅ Navegação de teclado (Tab, Enter)
- ✅ Auto-focus no email
- ✅ Animação shake em erro
- ✅ Feedback tátil (haptic)
- ✅ Checkbox "Lembrar-me"
- ✅ Link "Esqueci minha senha"
- ✅ Loading overlay
- ✅ Transições suaves
- ✅ SnackBars coloridos

### 3. **Verificação de Autenticação** (`lib/main.dart`)
- ✅ AuthChecker que verifica se usuário está logado
- ✅ Redireciona para Home se autenticado
- ✅ Mostra Login se não autenticado

---

## 🚀 **COMO USAR**

### **Backend já está rodando:**
```
✅ URL: http://localhost:3000
✅ Endpoint Login: POST /auth/login
```

### **Credenciais de Teste:**
```
Email: jonathan@example.com
Senha: 123456
```

### **Para Rodar o App:**

```bash
# 1. Certifique-se de estar na pasta frontend
cd frontend

# 2. Execute o app
flutter run
```

### **Configuração de URL por Plataforma:**

Abra `lib/services/auth_service.dart` e ajuste a URL conforme necessário:

```dart
// EMULADOR ANDROID (Padrão atual)
static const String baseUrl = 'http://10.0.2.2:3000/auth';

// WEB / DESKTOP
static const String baseUrl = 'http://localhost:3000/auth';

// EMULADOR iOS
static const String baseUrl = 'http://localhost:3000/auth';

// DISPOSITIVO FÍSICO (substitua pelo IP da sua máquina)
static const String baseUrl = 'http://192.168.1.100:3000/auth';
```

**Para descobrir seu IP local:**
- Windows: `ipconfig` (procure IPv4)
- Mac/Linux: `ifconfig` ou `ip addr`

---

## 📱 **FLUXO DE USO**

### **1. Primeira Vez (Sem Lembrar-me)**
1. App abre na tela de login
2. Campo email recebe foco automaticamente
3. Digite: `jonathan@example.com`
4. Pressione Tab ou clique no campo senha
5. Digite: `123456`
6. Pressione Enter ou clique em "Entrar"
7. Loading overlay aparece
8. SnackBar verde: "Login realizado com sucesso!"
9. Navega para HomeScreen com animação

### **2. Com "Lembrar-me" Ativado**
1. Marque checkbox "Lembrar-me" antes de fazer login
2. Faça login normalmente
3. Feche o app completamente
4. Abra o app novamente
5. Email estará pré-preenchido automaticamente
6. Digite apenas a senha

### **3. Esqueci Minha Senha**
1. Clique em "Esqueci minha senha"
2. Modal aparece
3. Digite seu email
4. Clique em "Enviar"
5. SnackBar confirma envio

---

## 🧪 **CENÁRIOS DE TESTE**

### ✅ **Login Bem-Sucedido**
```
Email: jonathan@example.com
Senha: 123456
Resultado: Login com sucesso, navega para Home
```

### ❌ **Credenciais Inválidas**
```
Email: teste@teste.com
Senha: senha_errada
Resultado: SnackBar vermelho "Email ou senha incorretos" + shake
```

### ❌ **Campos Vazios**
```
Email: (vazio)
Senha: (vazio)
Resultado: Bordas vermelhas + mensagens de erro inline
```

### ❌ **Email Inválido**
```
Email: email_sem_arroba
Senha: 123456
Resultado: Borda vermelha + "Por favor, digite um email válido"
```

### ❌ **Senha Curta**
```
Email: jonathan@example.com
Senha: 123
Resultado: "A senha deve ter no mínimo 6 caracteres"
```

### ❌ **Sem Internet**
```
Desative Wi-Fi/dados móveis
Tente fazer login
Resultado: SnackBar "Sem conexão com a internet"
```

### ❌ **Timeout**
```
Backend offline
Tente fazer login
Aguarde 10 segundos
Resultado: SnackBar "Tempo de conexão esgotado"
```

---

## 📊 **DADOS SALVOS APÓS LOGIN**

Após login bem-sucedido, o app salva no `SharedPreferences`:

```dart
{
  "access_token": "eyJhbGci...",      // Token JWT (válido por 1 hora)
  "refresh_token": "eyJhbGci...",     // Token de refresh (válido por 7 dias)
  "user_data": {                      // Dados completos do usuário
    "id": 1,
    "firstName": "Jonathan",
    "lastName": "Santana",
    "email": "jonathan@example.com",
    "phoneNumber": "11999999999",
    "cpf": "12345678900",
    "storeId": 1,
    "store": {
      "id": 1,
      "name": "Loja Principal",
      "imagePath": "/uploads/store-logo.png"
    }
  }
}
```

---

## 🔧 **MÉTODOS DISPONÍVEIS NO AUTHSERVICE**

```dart
// Fazer login
final success = await AuthService().login(email, password);

// Verificar se está logado
final isLoggedIn = await AuthService().isLoggedIn();

// Obter dados do usuário
final userData = await AuthService().getUserData();
// Retorna: Map<String, dynamic>? com todos os dados

// Obter token
final token = await AuthService().getToken();
// Retorna: String? com o access_token

// Fazer logout
await AuthService().logout();
// Remove todos os dados salvos
```

---

## 🎨 **CUSTOMIZAÇÕES DISPONÍVEIS**

### **Mudar Cores** (`lib/theme/colors.dart`)
```dart
static const Color primary = Color(0xFF000000);    // Cor principal (preto)
static const Color secondary = Color(0xFFF5F5F5);  // Cor secundária (cinza claro)
static const Color accent = Color(0xFF4CAF50);     // Cor de destaque (verde)
```

### **Desabilitar "Lembrar-me"**
Remova o bloco do checkbox em `login_screen.dart` (linhas ~560-600)

### **Desabilitar "Esqueci Senha"**
Remova o TextButton "Esqueci minha senha" (linhas ~600-620)

### **Remover Animação Shake**
Comente ou remova:
```dart
_triggerShakeAnimation();  // Linha ~177
```

### **Mudar Timeout**
Em `auth_service.dart`, linha ~24:
```dart
.timeout(
  const Duration(seconds: 10),  // Mude para 5, 15, 30, etc.
)
```

---

## 🐛 **PROBLEMAS COMUNS E SOLUÇÕES**

### **Erro: "Sem conexão com a internet"**
**Causa:** App não consegue alcançar o backend

**Soluções:**
1. Verifique se o backend está rodando: `http://localhost:3000`
2. Se estiver usando emulador Android, use `http://10.0.2.2:3000`
3. Se dispositivo físico, use IP local: `http://192.168.X.X:3000`
4. Desative firewall temporariamente

### **Erro: "Tempo de conexão esgotado"**
**Causa:** Backend não responde em 10 segundos

**Soluções:**
1. Verifique se o backend está rodando
2. Aumente o timeout em `auth_service.dart`
3. Verifique logs do backend

### **Erro: "Email ou senha incorretos"**
**Causa:** Credenciais inválidas ou usuário não existe

**Soluções:**
1. Use as credenciais de teste: `jonathan@example.com` / `123456`
2. Execute o seed do backend: `npm run seed`
3. Verifique se há usuários no banco

### **Email não é pré-preenchido com "Lembrar-me"**
**Causa:** SharedPreferences não está salvando

**Soluções:**
1. Certifique-se de marcar o checkbox antes de fazer login
2. Verifique permissões do app
3. Teste em dispositivo real (não apenas emulador)

### **Campos de input não aparecem corretamente**
**Causa:** Falta de contraste com background

**Soluções:**
1. Ajuste opacidade do container branco (linha ~381):
```dart
color: Colors.white.withOpacity(0.95),  // Era 0.9
```

---

## 📱 **PRÓXIMOS PASSOS**

Agora que o login está funcionando, você pode:

1. **Usar os dados do usuário nas outras telas:**
```dart
final userData = await AuthService().getUserData();
final userName = userData?['firstName'];
final userEmail = userData?['email'];
```

2. **Adicionar interceptor HTTP para enviar token:**
```dart
final token = await AuthService().getToken();
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
}
```

3. **Implementar logout funcional:**
```dart
await AuthService().logout();
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => LoginScreen()),
);
```

4. **Conectar outras telas ao backend:**
- Clientes
- Orçamentos
- Itens de orçamento
- Perfil do usuário

---

## ✨ **FEATURES PREMIUM IMPLEMENTADAS**

- ✅ Validação em tempo real
- ✅ Mensagens de erro específicas
- ✅ Navegação inteligente de teclado
- ✅ Auto-focus
- ✅ Animações suaves (shake, fade, slide)
- ✅ Feedback tátil (vibração)
- ✅ Loading overlay com mensagem
- ✅ SnackBars customizados (erro e sucesso)
- ✅ "Lembrar-me" com persistência
- ✅ "Esqueci minha senha" com modal
- ✅ Tratamento de erros por tipo
- ✅ Timeout configurável
- ✅ Botão de teste (apenas em debug)
- ✅ Hero animation na logo
- ✅ Transições de página customizadas
- ✅ Estados visuais dos campos (normal, focused, error)
- ✅ Desabilitar campos durante loading
- ✅ Prevenção de múltiplos cliques

---

## 🎯 **RESUMO**

**Status:** ✅ **100% FUNCIONAL E PRONTO PARA USO**

**Teste agora:**
```bash
flutter run
```

**Use as credenciais:**
- Email: `jonathan@example.com`
- Senha: `123456`

**Resultado esperado:**
- Login bem-sucedido
- Transição suave para HomeScreen
- Tokens e dados salvos localmente

---

## 📞 **SUPORTE**

Se encontrar problemas:
1. Verifique os logs do Flutter (terminal)
2. Verifique os logs do backend (terminal do backend)
3. Teste com as credenciais corretas
4. Verifique a URL do backend no `auth_service.dart`

**Logs úteis:**
- Flutter: Procure por `print()` statements
- Backend: Procure por `[Nest]` logs
- AuthService: Procure por `✅` e `❌` nos logs

---

**Desenvolvido com ❤️ para o PI-5o-SEMESTRE-DSM**

