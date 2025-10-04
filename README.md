# PI-5o-SEMESTRE-DSM
Plataforma pare gestão de serviços de manutenção de automóveis :
Projeto com frontend Flutter e backend NestJS (Node.js)

Estrutura
- `frontend/`: Aplicação Flutter criada com `flutter create`
- `backend/`: API NestJS criada com `npx @nestjs/cli new`

Pré-requisitos
- Flutter SDK instalado e configurado (`flutter --version`)
- Node.js (v22+) e npm (`node -v`, `npm -v`)

Documentação oficial (mais recente)
- Flutter: https://docs.flutter.dev/
- NestJS: https://docs.nestjs.com/
- Node.js: https://nodejs.org/en/docs

Configuração e execução

Frontend (Flutter)
1. `cd frontend`
2. `flutter pub get`
3. `flutter run`

Backend (NestJS)
1. `cd backend`
2. `npm install`
3. Desenvolvimento: `npm run start` (ou Hot-Reload: `npm run start:dev`)
4. Testes: `npm test`

Observações
- Para executar o Flutter em dispositivos/simuladores, verifique `flutter doctor`.
- Ajuste variáveis de ambiente do backend conforme necessário (por exemplo, porta `process.env.PORT`).

    A ideia é a construção de uma plataforma de gestão de manutenção que 
    informe ao cliente o status do serviço, realize o orçamento e auxilie
    O manutentor na comunicação clara entre ele o cliente, 
    Além da facilidade em registrar checklists e poder se
    lembrar das necessidades do cliente e a ordem de serviço.

Ferramentas :

    Linguagem Dart = Tratativas simples com cyódigo limpo e legível para velocidade, 
    melhor legibilidade e manutenção de código 

    Framework Flutter = Construção da interface mobile de maneira responsiva e limpa, 
    U.I mais simples e interativa para fácil acesso do usuário.

    Banco de dados Postgrees = Para Queries e tratativas de dados mais
    legíveis devido ao suporte á JSON e tipos de dados mais flexiveís.

    API Própria = Para registro de modelos de carro para puxada simples

    Kanban = Para gestão do projeto e Sprints do desenvolvimento do grupo.
