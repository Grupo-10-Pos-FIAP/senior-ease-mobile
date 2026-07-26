# SeniorEASE — Mobile

⚠️ **Projeto em construção** ⚠️

Aplicativo mobile em Flutter para acompanhamento de atividades de cursos voltado
a um público idoso, com foco em acessibilidade: modos de navegação simples/avançado,
níveis de contraste, escala de fonte/espaçamento e feedback visual configurável.

## Stack

- **Flutter** (Dart SDK `^3.10.7`)
- **Firebase**: Auth (e-mail/senha + Google Sign-In), Cloud Firestore, Storage
- **Gerenciamento de estado**: `ChangeNotifier` + `provider`
- **Injeção de dependência**: `get_it`
- **Testes**: `flutter_test`, `mocktail`, `integration_test`

O projeto segue Clean Architecture por módulo de feature
(`domain/ → data/ → presentation/`). Detalhes completos das camadas, regras de
import e decisões de design estão em [ARCHITECTURE.md](ARCHITECTURE.md).

## Funcionalidades

- **Login**: e-mail/senha e Google Sign-In (`features/auth`)
- **Painel (Dashboard)**: lista de atividades do curso matriculado, com status
  ativo/concluído/expirado (`features/dashboard`)
- **Tarefas**: execução passo-a-passo de uma atividade, com retomada de onde
  parou (`features/tasks`)
- **Perfil**: visualização e edição das informações do usuário (`features/profile`)
- **Configurações**: personalização de tamanho de fonte, contraste, espaçamento,
  modo de navegação (básico/avançado) e feedback visual (`features/settings`)

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e no `PATH`
  (rode `flutter doctor` para validar)
- Um projeto Firebase configurado com Authentication (e-mail/senha e Google),
  Cloud Firestore e Storage habilitados
- Xcode (para rodar em iOS) e/ou Android Studio (para rodar em Android)

## Configuração do Firebase

Os arquivos abaixo contêm chaves reais, por isso são ignorados pelo Git
(`.gitignore`) e não estão versionados. Você precisa gerá-los para o seu
próprio projeto Firebase antes de rodar o app:

- `lib/firebase_options.dart` — gerado via [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup):

  ```sh
  dart pub global activate flutterfire_cli
  flutterfire configure
  ```

- `android/app/google-services.json` — baixado do console do Firebase (app Android)
- `ios/Runner/GoogleService-Info.plist` — baixado do console do Firebase (app iOS)

## Rodando o projeto

```sh
flutter pub get
flutter run
```

## Testes

```sh
flutter test
```

A cobertura de testes está concentrada no módulo `dashboard` como referência
de padrão; a extensão para os demais módulos é um follow-up proposital (ver
[ARCHITECTURE.md](ARCHITECTURE.md)).

## Lint

```sh
flutter analyze
```
