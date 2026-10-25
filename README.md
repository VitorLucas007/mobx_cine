<p align="center">
  <img src="docs/icon.png" alt="Ícone do MobxCine" width="140">
</p>

# MobxCine 🎬

App em Flutter para ver os filmes em cartaz e comprar ingressos escolhendo o horário e os assentos. Foi feito para estudar **MobX** (gerenciamento de estado) e **Clean Architecture**.

## O que o app faz

1. **Cadastro e login** com nome, e-mail e senha. A sessão fica salva e o app reabre já logado.
2. **Lista de filmes em cartaz** vindos da API do TMDB, com busca por título.
3. **Detalhes do filme** (pôster, sinopse e nota).
4. **Escolha de horário e assentos** numa sala com 8 fileiras (A–H) e 10 assentos por fileira.
5. **Compra do ingresso** e tela de resultado com o resumo.
6. **Tema claro e escuro**, que também fica salvo.

> Só a lista de filmes usa a internet. Login, assentos e ingressos são **simulados** e ficam salvos no próprio aparelho (`shared_preferences`).

## Como rodar

### 1. Pegar a chave da API

Crie uma conta grátis em [themoviedb.org](https://www.themoviedb.org), vá em **Settings → API** e copie a **API Key (v3)**.

### 2. Instalar e gerar o código do MobX

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3. Rodar passando a chave

```bash
flutter run --dart-define=TMDB_API_KEY=SUA_CHAVE_AQUI
```

No VS Code, você pode colocar o mesmo argumento em `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "mobx_cine",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=TMDB_API_KEY=SUA_CHAVE_AQUI"]
    }
  ]
}
```

> ⚠️ Nunca coloque a chave direto no código nem suba o `launch.json` com ela para o GitHub. Se a chave não for passada, o app mostra o erro *"Chave da API não configurada"*.

## Como funciona a chamada de API

Arquivo: [movie_remote_datasource.dart](lib/features/movies/data/datasources/movie_remote_datasource.dart)

```
GET https://api.themoviedb.org/3/movie/now_playing
    ?api_key=...&language=pt-BR&region=BR&page=1
```

- A chave vem de `AppConfig.tmdbApiKey`, lida com `String.fromEnvironment('TMDB_API_KEY')` ([app_config.dart](lib/core/config/app_config.dart)).
- A chamada usa o pacote `http`, com **timeout de 15 segundos**.
- A resposta JSON é lida em `results` e cada item vira um `MovieModel`.
- Os erros viram `AppException` com mensagem amigável: sem chave, status diferente de 200, timeout e sem internet.
- As imagens vêm de `https://image.tmdb.org/t/p/w500` + o caminho do pôster.

## Arquitetura

O projeto é dividido por **funcionalidade** (`auth`, `movies`, `tickets`). Cada uma tem três camadas, e as dependências sempre apontam **para dentro**: `presentation → domain ← data`.

```
lib/
├── core/                  # Código compartilhado
│   ├── config/            # AppConfig (URL e chave da API)
│   ├── di/                # Injeção de dependências (get_it)
│   ├── errors/            # AppException
│   ├── routes/            # Rotas nomeadas
│   ├── theme/             # Tema claro/escuro (ThemeStore)
│   ├── utils/             # Validators, formatters, ViewState
│   └── widgets/           # Widgets reutilizáveis
├── features/
│   ├── auth/
│   ├── movies/
│   └── tickets/
│       ├── domain/        # Regras do negócio
│       ├── data/          # De onde vêm os dados
│       └── presentation/  # Telas e estado
└── main.dart
```

### Camada por camada

| Camada | O que tem | Responsabilidade |
|---|---|---|
| **Domain** | `entities`, `repositories` (interfaces), `usecases` | O **coração do app**. Não depende de Flutter, de API nem de banco. Define *o que* o app faz. |
| **Data** | `models`, `datasources`, `repositories` (implementação) | Busca e salva os dados: API do TMDB (`MovieRemoteDataSource`) e `shared_preferences` (`AuthLocalDataSource`, `TicketLocalDataSource`). Converte JSON em entidades. |
| **Presentation** | `pages`, `widgets`, `stores` | Telas e o estado delas. As **stores MobX** chamam os casos de uso e a tela reage às mudanças. |

### Como os dados andam

Exemplo: abrir a Home.

```
HomePage ──► MoviesStore ──► GetNowPlayingMoviesUseCase ──► MovieRepository (interface)
 (tela)      (estado)         (regra)                            │
                                                                 ▼
                              MovieRepositoryImpl ──► MovieRemoteDataSource ──► API TMDB
                                          (data)
```

- A **tela** só observa a store e desenha. Ela não conhece a API.
- A **store** guarda o estado (carregando, sucesso, erro) e chama o caso de uso.
- O **caso de uso** tem uma única tarefa e valida as regras.
- O **repositório** é uma interface no domain, e a implementação fica no data. Dá para trocar a API sem mexer nas telas.

### MobX em 30 segundos

- `@observable`: um valor que, ao mudar, avisa quem o usa.
- `@computed`: um valor calculado a partir de outros, que se atualiza sozinho (ex.: `filteredMovies`, `total`).
- `@action`: o único jeito de alterar os observables.
- `Observer`: o widget que se redesenha quando o que ele observa muda.
- Os arquivos `*.g.dart` são **gerados** pelo `build_runner`. Não edite à mão.

### Injeção de dependências

Em [injection.dart](lib/core/di/injection.dart), o `get_it` monta tudo na inicialização:

- **Singleton**: um único objeto no app inteiro (`AuthStore`, repositórios, `ThemeStore`).
- **Factory**: um objeto novo a cada uso (`MoviesStore`, casos de uso).
- **FactoryParam**: um objeto novo que recebe um parâmetro (`SeatSelectionStore` recebe o filme escolhido).

## Regras de negócio

**Cadastro e login** ([auth_repository_impl.dart](lib/features/auth/data/repositories/auth_repository_impl.dart))
- Nome com pelo menos 2 letras, e-mail válido e senha com pelo menos 6 caracteres ([validators.dart](lib/core/utils/validators.dart)).
- O e-mail é normalizado (minúsculo e sem espaços) e não pode ser cadastrado duas vezes.
- A senha **nunca** é salva em texto puro: guardamos só o hash SHA-256.
- Erro de login mostra sempre *"E-mail ou senha incorretos"*, sem dizer qual dos dois errou.

**Filmes** ([movies_store.dart](lib/features/movies/presentation/stores/movies_store.dart))
- A busca filtra a lista já carregada pelo título, sem chamar a API de novo.
- A tela mostra os estados `loading`, `success` e `error` (enum `ViewState`).

**Ingressos** ([cinema_room.dart](lib/features/tickets/domain/entities/cinema_room.dart), [seat_selection_store.dart](lib/features/tickets/presentation/stores/seat_selection_store.dart))
- Sala com 80 assentos, 4 horários (14:00, 16:30, 19:00 e 21:30), ingresso a R$ 32,00.
- Máximo de **6 assentos por compra**.
- Não dá para selecionar um assento ocupado.
- Ao **trocar de horário**, os assentos escolhidos são limpos, porque não valem mais.
- Se o usuário trocar de horário enquanto os assentos carregam, a resposta antiga é descartada.
- O total é calculado automaticamente (`assentos × preço`).
- O botão **Comprar** só fica ativo se houver assentos escolhidos, os assentos tiverem carregado e nenhuma compra estiver em andamento.

**Simulações** ([ticket_repository_impl.dart](lib/features/tickets/data/repositories/ticket_repository_impl.dart))
- Cerca de 25% dos assentos aparecem como "já vendidos". Eles são sempre os mesmos para o mesmo filme e horário.
- Os assentos que você compra também passam a aparecer como ocupados.
- A compra tem **15% de chance de ser recusada** ("pagamento recusado"), para testar o tratamento de erro. Ajuste em `_simulatedFailureRate`.
- Antes de salvar, o app confere de novo se algum assento foi ocupado nesse meio tempo.

## Tecnologias

| Pacote | Para quê |
|---|---|
| `mobx`, `flutter_mobx`, `mobx_codegen` | Estado reativo |
| `get_it` | Injeção de dependências |
| `http` | Chamadas à API |
| `shared_preferences` | Salvar sessão, usuários, ingressos e tema |
| `crypto` | Hash da senha (SHA-256) |
| `cached_network_image` | Cache dos pôsteres |
| `intl` | Formatação de datas e moeda |
