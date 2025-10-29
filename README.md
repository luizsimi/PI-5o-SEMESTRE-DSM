# 📱 RBS App - Sistema de Gestão de Serviços

<div align="center">
  <img src="frontend/assets/images/logo.png" alt="RBS App Logo" width="120" height="120">
  
  **Uma aplicação mobile completa para gestão de serviços desenvolvida com Flutter + NestJS**
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com)
  [![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)
</div>

---

## 🚀 Sobre o Projeto

O **RBS App** é uma solução completa para gestão de serviços, permitindo o controle de orçamentos, clientes e status de serviços de forma intuitiva e eficiente. A aplicação oferece uma interface moderna e responsiva, com funcionalidades avançadas para otimizar o fluxo de trabalho.

### ✨ Principais Funcionalidades

- 🏠 **Dashboard Principal** - Visualização geral dos serviços com filtros por status
- 🔍 **Sistema de Busca** - Pesquisa avançada de serviços e clientes
- 💰 **Gestão de Orçamentos** - Criação e gerenciamento de orçamentos detalhados
- 👤 **Perfil do Usuário** - Gerenciamento de dados pessoais
- 📊 **Relatórios** - Estatísticas e métricas de desempenho
- ✅ **Modais de Confirmação** - Interface intuitiva para ações importantes
- 🎯 **Status de Serviços** - Controle completo do ciclo de vida dos serviços

## 🏗️ Arquitetura do Projeto

```
📦 RBS App
├── 📱 frontend/              # Aplicação Flutter
│   ├── 📂 lib/
│   │   ├── 🖥️ screens/       # Telas da aplicação
│   │   │   ├── home_screen.dart
│   │   │   ├── search_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── meus_dados_screen.dart
│   │   ├── 🧩 components/     # Componentes reutilizáveis
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── custom_bottom_navigation.dart
│   │   │   ├── budget_modal.dart
│   │   │   ├── success_modal.dart
│   │   │   └── confirmation_modal.dart
│   │   └── 🎨 assets/        # Recursos visuais
│   │       └── images/
│   └── 📄 pubspec.yaml       # Dependências Flutter
│
└── 🖥️ backend/               # API NestJS
    ├── 📂 src/
    │   ├── 📦 modules/       # Módulos da aplicação
    │   ├── 🔧 common/        # Código compartilhado
    │   ├── ⚙️ config/        # Configurações
    │   └── 🗄️ database/      # Configurações de banco
    ├── 🔐 .env               # Variáveis de ambiente
    └── 📦 package.json       # Dependências Node.js
```

## 🛠️ Tecnologias Utilizadas

### 📱 Frontend (Flutter)
- **Flutter SDK** - Framework multiplataforma para desenvolvimento mobile
- **Material Design 3** - Sistema de design moderno e responsivo
- **Custom Components** - Componentes personalizados reutilizáveis
- **State Management** - Gerenciamento de estado eficiente
- **Navigation** - Sistema de navegação intuitivo
for
### 🖥️ Backend (NestJS)
- **NestJS** - Framework Node.js escalável e modular
- **TypeORM** - ORM robusto para banco de dados
- **MySQL** - Sistema de gerenciamento de banco de dados
- **Class Validator** - Validação de dados em tempo real
- **JWT Authentication** - Sistema de autenticação seguro

### 🎨 Design & UX
- **Interface Moderna** - Design clean e intuitivo
- **Responsividade** - Adaptação perfeita a diferentes tamanhos de tela
- **Modais Interativos** - Experiência de usuário fluida
- **Feedback Visual** - Indicadores de status e confirmações

## 📱 Capturas de Tela

### 🏠 Tela Principal
A tela principal oferece uma visão geral de todos os serviços com filtros por status:
- **TODOS** - Visualização completa
- **PENDENTES** - Serviços aguardando aprovação
- **APROVADOS** - Serviços confirmados

### 💰 Modal de Orçamento
Sistema completo de criação de orçamentos com:
- Dados do cliente (nome, telefone)
- Informações do veículo (modelo, placa)
- Detalhes do serviço e peças
- Cálculo automático de valores
- Modal de confirmação para fechamento
- Modal de sucesso "Orçamento Realizado"

### 🔍 Sistema de Busca
Funcionalidade avançada de pesquisa para localizar rapidamente:
- Serviços por cliente
- Filtros por status
- Histórico de atendimentos

## 🚀 Funcionalidades Implementadas

### ✅ Modais Interativos
- **Modal de Confirmação** - Confirma ações importantes como fechamento de orçamentos
- **Modal de Sucesso** - Feedback visual para ações concluídas com sucesso
- **Modal de Detalhes** - Visualização completa de informações do serviço

### 🎯 Gestão de Status
- **Pendente** - Serviços aguardando aprovação
- **Aprovado** - Serviços confirmados pelo cliente
- **Em Andamento** - Serviços sendo executados
- **Concluído** - Serviços finalizados

### 📊 Dashboard Intuitivo
- Cards de serviços com informações essenciais
- Navegação por abas para filtrar por status
- Interface responsiva e moderna
- Indicadores visuais de status

## ⚙️ Configuração do Ambiente

### 📋 Pré-requisitos
- **Flutter SDK** (versão mais recente) - [Instalar Flutter](https://flutter.dev/docs/get-started/install)
- **Node.js** (versão 18+) - [Instalar Node.js](https://nodejs.org/)
- **MySQL Server** - [Instalar MySQL](https://dev.mysql.com/downloads/)
- **Git** - [Instalar Git](https://git-scm.com/)
- **Android Studio** ou **VS Code** com extensões Flutter

### 🖥️ Configuração do Backend

1. **Clone o repositório e navegue para o backend:**
```bash
git clone <repository-url>
cd backend
```

2. **Instale as dependências:**
```bash
npm install
```

3. **Configure o banco de dados:**
```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Configure as credenciais do MySQL no arquivo .env
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USERNAME=root
DATABASE_PASSWORD=sua_senha
DATABASE_NAME=rbs_app
```

4. **Execute o servidor:**
```bash
# Modo desenvolvimento
npm run start:dev

# Modo produção
npm run start
```

🌐 **Servidor rodando em:** `http://localhost:3000`

### 📱 Configuração do Frontend

1. **Navegue para a pasta do frontend:**
```bash
cd frontend
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Configure um emulador ou conecte um dispositivo físico**

4. **Execute a aplicação:**
```bash
# Executar no emulador/dispositivo
flutter run

# Executar no Chrome (web)
flutter run -d chrome
```

## 🔧 Scripts Disponíveis

### 🖥️ Backend
```bash
npm run start          # Inicia o servidor em produção
npm run start:dev      # Inicia o servidor em modo desenvolvimento
npm run build          # Compila o projeto TypeScript
npm run test           # Executa os testes unitários
npm run test:e2e       # Executa os testes end-to-end
npm run lint           # Verifica a qualidade do código
```

### 📱 Frontend
```bash
flutter run            # Executa a aplicação
flutter build apk      # Gera APK para Android
flutter build ios      # Gera build para iOS
flutter test           # Executa os testes
flutter pub get        # Instala dependências
flutter clean          # Limpa o cache de build
flutter doctor         # Verifica a configuração do ambiente
```

## 🗄️ Configuração do Banco de Dados

O projeto utiliza **MySQL** como sistema de gerenciamento de banco de dados. 

### 📊 Configurações Padrão
```env
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USERNAME=root
DATABASE_PASSWORD=sua_senha
DATABASE_NAME=rbs_app
```

### 🔧 Configuração Personalizada
Modifique o arquivo `.env` no backend para alterar essas configurações conforme seu ambiente.

## 🚀 Desenvolvimento

### 🏗️ Arquitetura de Desenvolvimento
- **Backend** roda na porta `3000`
- **Frontend** se conecta ao backend via HTTP/HTTPS
- **CORS** configurado para permitir requisições do frontend
- **Validação global** habilitada no backend
- **TypeORM** configurado com sincronização automática em desenvolvimento
- **Hot Reload** habilitado no Flutter para desenvolvimento ágil

### 🎯 Próximas Implementações
- [ ] 🔐 Sistema de autenticação JWT completo
- [ ] 📊 Dashboard com métricas avançadas
- [ ] 📱 Notificações push
- [ ] 💾 Sincronização offline
- [ ] 📈 Relatórios em PDF
- [ ] 🔍 Busca avançada com filtros
- [ ] 👥 Sistema multi-usuário
- [ ] 🌐 API REST completa
- [ ] 🧪 Testes automatizados
- [ ] 🚀 CI/CD Pipeline


## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Equipe de Desenvolvimento

Desenvolvido com ❤️ por estudantes do 5º semestre de Desenvolvimento de Software Multiplataforma.

---

<div align="center">
  <p>⭐ Se este projeto te ajudou, considere dar uma estrela!</p>
  
  **[⬆ Voltar ao topo](#-rbs-app---sistema-de-gestão-de-serviços)**
</div>