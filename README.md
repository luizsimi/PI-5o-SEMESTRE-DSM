# Projeto Mobile App - Flutter + NestJS

Este projeto consiste em uma aplicação mobile desenvolvida com Flutter para o frontend e NestJS com TypeORM para o backend.

## Estrutura do Projeto

```
├── frontend/          # Aplicação Flutter
│   ├── lib/
│   │   ├── screens/   # Telas da aplicação
│   │   ├── services/  # Serviços para comunicação com API
│   │   ├── models/    # Modelos de dados
│   │   ├── utils/     # Utilitários e helpers
│   │   └── widgets/   # Componentes reutilizáveis
│   └── pubspec.yaml   # Dependências Flutter
│
└── backend/           # API NestJS
    ├── src/
    │   ├── modules/   # Módulos da aplicação
    │   ├── common/    # Código compartilhado
    │   ├── config/    # Configurações
    │   └── database/  # Configurações de banco
    ├── .env           # Variáveis de ambiente
    └── package.json   # Dependências Node.js
```

## Tecnologias Utilizadas

### Frontend (Flutter)
- **Flutter SDK**: Framework para desenvolvimento mobile
- **HTTP**: Cliente para requisições API
- **Provider**: Gerenciamento de estado
- **SharedPreferences**: Armazenamento local
- **GoRouter**: Navegação
- **JSON Annotation**: Serialização JSON

### Backend (NestJS)
- **NestJS**: Framework Node.js
- **TypeORM**: ORM para banco de dados
- **MySQL**: Banco de dados
- **Class Validator**: Validação de dados
- **Class Transformer**: Transformação de dados

## Configuração do Ambiente

### Pré-requisitos
- Flutter SDK (versão mais recente)
- Node.js (versão 18+)
- MySQL Server
- Git

### Backend Setup

1. Navegue para a pasta do backend:
```bash
cd backend
```

2. Instale as dependências:
```bash
npm install
```

3. Configure o banco de dados:
   - Copie `.env.example` para `.env`
   - Configure as credenciais do MySQL no arquivo `.env`

4. Execute o servidor:
```bash
npm run start:dev
```

O servidor estará rodando em `http://localhost:3000`

### Frontend Setup

1. Navegue para a pasta do frontend:
```bash
cd frontend
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute a aplicação:
```bash
flutter run
```

## Scripts Disponíveis

### Backend
- `npm run start`: Inicia o servidor em produção
- `npm run start:dev`: Inicia o servidor em modo desenvolvimento
- `npm run build`: Compila o projeto
- `npm run test`: Executa os testes

### Frontend
- `flutter run`: Executa a aplicação
- `flutter build`: Compila a aplicação
- `flutter test`: Executa os testes
- `flutter pub get`: Instala dependências

## Configuração do Banco de Dados

O projeto está configurado para usar MySQL. As configurações padrão são:

- Host: localhost
- Porta: 3306
- Usuário: root
- Senha: (vazia)
- Database: app_database

Modifique o arquivo `.env` no backend para alterar essas configurações.

## Desenvolvimento

### Estrutura de Desenvolvimento
- O backend roda na porta 3000
- O frontend se conecta ao backend via HTTP
- CORS está configurado para permitir requisições do frontend
- Validação global está habilitada no backend
- TypeORM está configurado com sincronização automática em desenvolvimento

### Próximos Passos
1. Implementar autenticação JWT
2. Criar módulos específicos da aplicação
3. Desenvolver telas do Flutter
4. Implementar testes unitários e de integração
5. Configurar CI/CD

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request