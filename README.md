# SeniorEase — Mobile

Aplicativo mobile de acessibilidade digital para idosos — parte da entrega do
Hackathon FIAP (Pós-Tech — Front-end), complementar ao
[SeniorEase Web](https://github.com/Grupo-10-Pos-FIAP/senior-ease-web).

Facilita a vida acadêmica de pessoas idosas com atividades guiadas
passo-a-passo, personalização de acessibilidade (contraste, fonte,
espaçamento, feedback visual) e feedback claro em cada ação.

**Sem versão publicada** — o app é executado localmente a partir do
código-fonte (veja abaixo).

---

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.10.7`)
- Projeto **Firebase** com Authentication (e-mail/senha + Google), Cloud
  Firestore e Storage habilitados
- Xcode (para rodar em iOS) e/ou Android Studio (para rodar em Android)

---

## Passo a passo — executar o app

1. Clone o repositório e entre na pasta do projeto.
2. Crie um projeto no [console do Firebase](https://console.firebase.google.com)
   com Authentication (e-mail/senha e Google), Cloud Firestore e Storage
   habilitados.
3. Baixe os arquivos nativos abaixo do console do Firebase (ignorados pelo
   Git, pois contêm chaves reais; cada pessoa que roda o projeto precisa da
   própria cópia):

   - `android/app/google-services.json` (app Android)
   - `ios/Runner/GoogleService-Info.plist` (app iOS)

4. Copie `.env.example` para `.env` na raiz do projeto e preencha com os
   valores dos arquivos baixados acima (`lib/firebase_options.dart` — já
   versionado — lê tudo daqui, então não precisa rodar o FlutterFire CLI):

   ```sh
   cp .env.example .env
   ```

   | Variável                       | De onde vem                                                                                                        |
   | ------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
   | `GOOGLE_SERVER_CLIENT_ID`      | `google-services.json` → `client_type: 3` (Web client) — `serverClientId` exigido pelo `google_sign_in` no Android |
   | `FIREBASE_ANDROID_API_KEY`     | `google-services.json` → `api_key`                                                                                 |
   | `FIREBASE_ANDROID_APP_ID`      | `google-services.json` → `mobilesdk_app_id`                                                                        |
   | `FIREBASE_IOS_API_KEY`         | `GoogleService-Info.plist` → `API_KEY`                                                                             |
   | `FIREBASE_IOS_APP_ID`          | `GoogleService-Info.plist` → `GOOGLE_APP_ID`                                                                       |
   | `FIREBASE_MESSAGING_SENDER_ID` | `GoogleService-Info.plist` → `GCM_SENDER_ID` (mesmo valor nos dois arquivos)                                       |
   | `FIREBASE_PROJECT_ID`          | `GoogleService-Info.plist` → `PROJECT_ID` (mesmo valor nos dois arquivos)                                          |
   | `FIREBASE_STORAGE_BUCKET`      | `GoogleService-Info.plist` → `STORAGE_BUCKET`                                                                      |
   | `FIREBASE_IOS_BUNDLE_ID`       | `GoogleService-Info.plist` → `BUNDLE_ID`                                                                           |
   | `FIREBASE_IOS_CLIENT_ID`       | `GoogleService-Info.plist` → `CLIENT_ID`                                                                           |

5. Instale as dependências e rode:

   ```sh
   flutter pub get
   flutter run
   ```

6. Na primeira tela, crie uma conta nova (e-mail/senha ou Google) — não há
   conta de teste pré-cadastrada.

7. Comandos úteis:

   ```sh
   flutter test       # testes (flutter_test + mocktail)
   flutter analyze    # lint (flutter_lints)
   ```

## Stack

| Área                    | Tecnologia                                             |
| ----------------------- | ------------------------------------------------------ |
| Framework               | Flutter, Dart `^3.10.7`                                |
| UI                      | Material 3, design tokens próprios (`AppDesignTokens`) |
| Gerenciamento de estado | `ChangeNotifier` + `provider`                          |
| Injeção de dependência  | `get_it`                                               |
| Auth / dados            | Firebase Auth (e-mail/senha + Google), Cloud Firestore |
| Storage                 | Firebase Storage                                       |
| Vídeo                   | `youtube_player_iframe` (via WebView)                  |
| Testes                  | `flutter_test` + `mocktail`                            |
| Lint                    | `flutter_lints`                                        |

---

## Arquitetura

Clean Architecture por módulo de feature, com regra de dependência:

```text
presentation → domain ← data
```

**Regras:**

- `domain/` — Dart puro: entidades, `abstract class` de repositório (o
  "port"/adaptador) e casos de uso (`UseCase<R, Params>`). Zero import de
  Flutter/UI.
- `data/` — implementação concreta do repositório + data source Firestore.
- `presentation/` — controllers (`ChangeNotifier`), screens e widgets. Só
  importa o `domain/` do próprio módulo — nunca o `data/` do próprio módulo
  (só o `<módulo>_injection.dart` conhece as implementações concretas). Nunca
  importa outro módulo de `features/`.
- `core/` não depende de nada fora dele; `app/` é o composition root (o
  único lugar autorizado a enxergar tudo: DI + rotas).

Nenhuma dessas regras é garantida por lint automático — são convenção de
projeto. Decisões e simplificações deliberadas (histórico) estão em
[ARCHITECTURE.md](ARCHITECTURE.md).

**Exceção deliberada**: o módulo `auth` não segue o layering completo — é um
wrapper fino direto sobre `firebase_auth`/`cloud_firestore`
(`core/auth/auth_controller.dart`), sem `domain/`/`data/` próprios, já que
não há regra de negócio para isolar além do que o SDK do Firebase já expõe.

---

## Estrutura de pastas

```text
lib/
├── app/                  # Composition root: MainApp, rotas, DI, splash,
│                         # shell de tabs do profile (sem regra de negócio)
├── core/                 # Zero dependências para fora: UseCase<R, Params>,
│                         # AuthController, nomes de rota, AppModeController
├── shared/               # UI kit: design tokens + widgets genéricos
│                         # (AppButton, AppCard, AppDialog, AppTextField...)
└── features/
    ├── auth/             # login/cadastro (thin wrapper, ver exceção acima)
    ├── dashboard/        # painel de atividades do curso matriculado
    ├── tasks/            # atividade passo-a-passo + tutorial guiado
    ├── profile/          # perfil: dados da conta + matrícula
    └── settings/         # personalização de acessibilidade
```

Cada módulo em `features/` (exceto `auth`) segue `domain/ → data/ → presentation/`.

---

## Camadas — responsabilidades

| Camada       | Pasta           | Pode importar             | Não pode                                     |
| ------------ | --------------- | ------------------------- | -------------------------------------------- |
| Domain       | `domain/`       | — (núcleo)                | Flutter, `data/`                             |
| Data         | `data/`         | `domain/` do mesmo módulo | `presentation/`                              |
| Presentation | `presentation/` | `domain/` do mesmo módulo | `data/` do mesmo módulo, outros `features/*` |
| Core         | `core/`         | nada fora dele            | `features/*`                                 |
| App          | `app/`          | tudo (composition root)   | regra de negócio própria                     |
| Shared       | `shared/`       | Flutter/Material          | `domain/`, `data/`, use cases                |

---

## Módulos de domínio

| Módulo        | Repositório (port)   | Entidades                       | Casos de uso                                                           |
| ------------- | -------------------- | ------------------------------- | ---------------------------------------------------------------------- |
| **Dashboard** | `ActivityRepository` | `Activity`                      | `GetActivities`, `CompleteActivity`                                    |
| **Tasks**     | `TaskRepository`     | `TaskStep` (+ `TaskStepOption`) | `GetSteps`, `CompleteStep`, `CompleteGuideStep`, `MarkActivityStarted` |
| **Profile**   | `ProfileRepository`  | `UserProfile`                   | `GetUserProfile`, `UpdateUserProfile`                                  |
| **Settings**  | `SettingsRepository` | `AppSettings`                   | `GetSettings`, `SaveSettings`                                          |

`auth` não tem repositório/entidade próprios — ver exceção na seção
Arquitetura.

**Rotas (`lib/core/routes/route_names.dart`):**

| Rota            | Tela                                        |
| --------------- | ------------------------------------------- |
| `/login`        | Login / cadastro (e-mail ou Google)         |
| `/home`         | Dashboard (lista de atividades)             |
| `/steps`        | Lista de passos de uma atividade            |
| `/tutorial`     | Tutorial guiado de um passo                 |
| `/stage`        | Execução de um passo da atividade           |
| `/profile`      | Perfil (tabs: Personalização / Informações) |
| `/edit-profile` | Edição dos dados da conta                   |

---

## Persistência

Firebase Auth cuida da sessão; os dados ficam no Cloud Firestore, sempre
escopados ao usuário autenticado (sem `userId` fixo):

- `users/{uid}` — perfil, preferências de acessibilidade, matrícula, flag de
  conta desativada
- `users/{uid}/activityProgress/{activityId}` — progresso do usuário em cada
  atividade (passos concluídos, passos do tutorial concluídos)
- `courses/{courseId}/activities/{activityId}` — catálogo de atividades do
  curso (somente leitura no client)

Conta: desativação com retenção de 90 dias + reativação automática ao
entrar de novo (e-mail ou Google) dentro do prazo.

---

## Práticas do projeto

### Clean Architecture

- **SRP** — 1 caso de uso = 1 ação; controllers finos delegando pros use cases
- **DIP** — `presentation/` depende da interface de repositório
  (`domain/repositories/`), nunca da implementação Firestore direto
- **ISP** — um repositório por módulo, enxuto pro que aquele módulo precisa

### Estado

| Tipo                                           | Onde                                                                                                             |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Estado por feature                             | Controller `ChangeNotifier` do módulo, injetado via `get_it`                                                     |
| Modo simples/avançado                          | `AppModeController` (`core/app_mode/`) — singleton compartilhado entre módulos, ver exceção na seção Arquitetura |
| Tokens de design (fonte/contraste/espaçamento) | `AppDesignTokens` (`shared/theme/`), reconfigurado a cada mudança de preferência                                 |

### Acessibilidade

- 6 níveis de contraste (Padrão, Suave, Conforto, Alto, Máximo, Escuro), cada
  um com paleta própria em `AppDesignTokens`
- Escala de fonte e espaçamento configuráveis, aplicadas globalmente
- "Feedback visual reforçado": contorno extra de foco (`ReinforcedFocusRing`)
  e haptics em botões/cards quando ativado
- "Confirmação em ações críticas": exige diálogo de confirmação antes de
  ações destrutivas (ex.: desativar conta) quando ativado

### Testes

- Co-localização em `test/`, espelhando a estrutura de `lib/`
- `domain`/`data`/`presentation` cobertos com `mocktail` para os módulos
  `auth`, `dashboard`, `tasks`, `profile` e `settings` (33 arquivos de teste)
- Rodar com `flutter test`

### CI/CD

Ainda não há pipeline configurado (diferente do projeto web). Localmente, o
equivalente ao gate de qualidade é rodar `flutter analyze` e `flutter test`
antes de subir mudanças.

### Segurança

- **Secrets** — `lib/firebase_options.dart`, `android/app/google-services.json`,
  `ios/Runner/GoogleService-Info.plist` e `.env` são todos ignorados pelo Git
  (contêm chaves reais)
- **Firestore** — cada usuário autenticado só lê/escreve o próprio documento
  em `users/{uid}` (e subcoleções); consultas (`where`/`list`) mais amplas na
  coleção `users` são negadas pelas regras do projeto
- **Matrícula** — ID sequencial amigável `SE#####` alocado atomicamente via
  contador Firestore (`counters/matriculas`); imutável após a criação. O UID
  do Firebase continua sendo o identificador real internamente

---

## Onde colocar código novo

| O quê                                               | Onde                                        |
| --------------------------------------------------- | ------------------------------------------- |
| Entidade, repositório (interface), caso de uso      | `features/<módulo>/domain/`                 |
| Data source Firestore, implementação de repositório | `features/<módulo>/data/`                   |
| Controller, screen, widget de uma feature           | `features/<módulo>/presentation/`           |
| Wiring de DI do módulo                              | `features/<módulo>/<módulo>_injection.dart` |
| Rota, composition root, telas sem regra própria     | `app/`                                      |
| Algo usado por mais de um módulo, sem UI            | `core/`                                     |
| Widget/token de UI reutilizável                     | `shared/`                                   |
