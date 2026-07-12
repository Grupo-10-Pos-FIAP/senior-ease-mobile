# Arquitetura

Este app segue Clean Architecture com separação por módulo de feature, alinhado ao
rubric do curso: "camada de domínio isolada; casos de uso independentes de UI;
adaptadores e interfaces bem definidos" e "separação clara entre módulos (painel,
tarefas, perfil, configurações)". Pastas e arquivos usam nomes em inglês; o
mapeamento para os termos do rubric (em português) é: painel → `dashboard`,
tarefas → `tasks`, perfil → `profile`, configurações → `settings`.

## Estrutura

```text
lib/
  app/        # composition root: MainApp, rotas, DI, telas de composição (sem
              # regra de negócio própria) — splash e o shell de tabs do profile
  core/       # zero dependências para fora: UseCase<R, Params> base, nomes de rota
  shared/     # UI kit multiplataforma (design tokens + widgets genéricos)
  features/
    dashboard/  # painel de atividades (era HomeScreen)
    tasks/      # tarefas: passo-a-passo + etapa de uma atividade
    profile/    # perfil: aba "Informações"
    settings/   # configurações: aba "Personalização"
```

Cada módulo em `features/` segue `domain/ → data/ → presentation/`:

- `domain/`: entidades, `abstract class` de repositório (a interface/"adaptador"
  do rubric) e casos de uso (`UseCase<R, Params>`). Dart puro, zero import de
  Flutter/UI.
- `data/`: implementação concreta do repositório + data source. Hoje só existe
  `*_local_data_source.dart` (mock em memória).
- `presentation/`: controllers (`ChangeNotifier`), screens e widgets. Só pode
  importar o `domain/` do próprio módulo — nunca o `data/` do próprio módulo
  (só o `<modulo>_injection.dart`, ex. `dashboard_injection.dart`, conhece as
  implementações concretas). Nunca importa outro `features/*`.

## Regras

1. `presentation/` → só `domain/` (nunca `data/` do mesmo módulo).
2. Sem imports cruzados entre módulos de `features/`.
3. `core/` não depende de nada fora dele. `app/` é o único lugar autorizado a
   enxergar tudo (composition root: DI + rotas).

Nenhuma dessas regras é garantida por lint automático — são convenção de
projeto, verificadas manualmente/por revisão de código.

**Exceção deliberada**: `core/app_mode/app_mode_controller.dart` é um
`ChangeNotifier` singleton (registrado no GetIt) que guarda `isSimpleMode`,
derivado do "Modo de navegação" salvo em `configuracoes`/`settings`. Como o
Simple mode precisa esconder elementos em telas de módulos diferentes
(`dashboard` hoje; potencialmente outros no futuro), ele vive em `core/` — o
único lugar de onde qualquer `features/*` pode importar sem virar um import
cruzado feature-a-feature. `SettingsController` escreve nele ao
carregar/salvar; `DashboardController` só lê (`isSimpleMode` getter) e escuta
mudanças para recalcular as abas visíveis.

## Simplificações deliberadas

1. **Sem camada de Model (`fromMap`/`toMap`).** Os data sources são mocks em
   memória; um `Model` seria código morto sem nada real para parsear. Deve ser
   introduzido quando um data source remoto (Firestore, já declarado no
   `pubspec.yaml` mas não usado) for implementado.
2. **Sem `Failure`/`Either`.** Casos de uso/repositórios retornam `Future<T>` e
   deixam exceções propagarem; controllers capturam e expõem um
   `String? errorMessage` quando necessário. Os data sources mock nunca lançam
   hoje, então um tipo funcional de erro (dartz/fpdart) não traria benefício
   ainda.
3. **Gerenciamento de estado**: `ChangeNotifier` simples + `provider` (ambos já
   declarados no `pubspec.yaml`, mas não usados antes desta reestruturação).
   `state_notifier`/`flutter_state_notifier` continuam declarados e não usados.
4. **Testes**: só o módulo `dashboard` (painel) tem um conjunto representativo de
   testes (`test/features/dashboard/`: caso de uso, repositório, controller e um
   teste de "fumaça" de DI via `GetIt.asNewInstance()`), usando `mocktail`.
   Replicar o mesmo padrão para `tasks`/`profile`/`settings` é um follow-up
   proposital, não um esquecimento.

## Decisão de comportamento: "Salvar mudanças"

Antes da reestruturação, o botão "Salvar mudanças" (aba Personalização) era um
no-op puro — não existia nenhum estado persistido para salvar, e o clique não
tinha efeito visual algum (sem diálogo, sem confirmação). Agora ele chama
`SettingsController.save()` → caso de uso `SaveSettings` → persiste no data
source em memória pelo resto da sessão do app (ainda reseta ao reiniciar o
app, igual a antes). Isso é indistinguível visualmente do comportamento
anterior, mas dá um caso de uso real para o botão em vez de ficar sem nenhuma
chamada de verdade. "Retornar configurações padrão" continua resetando só o
rascunho exibido em tela (`draft`), sem persistir — igual ao `setState` de
antes.
