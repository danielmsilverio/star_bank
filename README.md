# StarBank

StarBank é um projeto para fins de estudo. A ideia é criar uma API com cadastro de usuários, contas com saldo e transferências entre contas.

Como é um projeto de aprendizado, as regras de negócio são simples. Mais detalhes em [Status](#status).

Apesar de já ter experiência com Elixir + Phoenix, resolvi fazer um curso para reciclar o conhecimento e deixar o projeto como portfólio.

## Sumário

- 🚦 [Status](#status)
- ▶️ [Como executar](#como-executar)
	- 🐳 [Com Docker (recomendado)](#-com-docker-recomendado)
	- 💧 [Sem Docker](#-sem-docker)
	- 🧩 [Somente Postgres no Docker + app local](#-somente-postgres-no-docker--app-local)
- 🧪 [Como testar](#como-testar)
	- 🐳 [Testando com Docker](#testando-com-docker)
	- 💧 [Testando sem Docker](#testando-sem-docker)
- 🧰 [Atalhos Mix](#atalhos-mix)
- 📌 [Próximos passos](#próximos-passos)
- 🔗 [Outros projetos](#outros-projetos)

## Status

O curso concluído abordou os seguintes tópicos:
- **Fundamentos do Elixir**: Revisão de tipos básicos, listas, tuplas, maps, `Enum`, pattern matching e pipe operator.
- **Projeto FizzBuzz**: Projeto simples para reforçar os fundamentos.
- **Projeto EXMon (jogo)**: Batalha simulada que reforça os tópicos anteriores e apresenta uso de `Agent`.
- **Introdução ao Phoenix**: Estrutura do Phoenix (sem LiveView) e início do projeto.
- **CRUD de Usuários**: Migrações, changesets, tratamento de erros e testes.
- **Requisições externas**: Uso de [Tesla](https://hexdocs.pm/tesla/Tesla.html), [Bypass](https://hexdocs.pm/bypass/Bypass.html) e [Mox](https://hexdocs.pm/mox/Mox.html) para validar CEP via serviço externo.
- **Transferências**: Módulo de contas, uso da lib `Decimal`, regras de negócio, `Ecto.Multi` e `Repo.transaction/1`.
- **Autenticação**: Estrutura de tokens, `Plug`s e uso de `argon2_elixir`.
- **Deploy**: Uso do [fly.io](https://fly.io/). Houve mudança de planos devido ao Postgres pago; para estudo, preferi não usar a versão paga. Avalio alternativas para estudos.
- **Bônus: Processos e OTP**: Conceitos práticos de processos, `Task` (inclusive `async_stream`), `GenServer` e supervisão.

🪧 Certificado: [Udemy](https://www.udemy.com/certificate/UC-abbce423-3836-47d7-8e4a-d91b6d7d39e2)

Após o curso, ajustei alguns pontos:
- 🐛 Testes quebrando por autenticação: corrigi adicionando token nos testes.
- 🐛 Qualquer usuário alterando dados de outros: adotei [Bodyguard](https://hexdocs.pm/bodyguard/) para autorização.

Decidi colocar o projeto no GitHub (daí o primeiro commit grande 🫠). Outros pontos de melhoria estão em [Próximos passos](#próximos-passos).

## Como executar

Antes de tudo, copie o arquivo de exemplo de variáveis de ambiente e ajuste conforme seu ambiente:

```bash
cp .env.example .env
```

### 🐳 Com Docker (recomendado)

Usando Docker Compose (sobe app + Postgres, aplica migrações automaticamente via entrypoint):

```bash
docker compose up --build -d
docker compose logs -f starbank
```

Acesse: http://localhost:4000

Notas:
- O serviço `postgres` do Compose usa as variáveis do `.env` para usuário/senha/banco.
- O app (`starbank`) também lê `.env`. O entrypoint espera o Postgres e roda `mix ecto.setup` antes de iniciar.

### 💧 Sem Docker

Pré-requisitos:
- Elixir/Erlang compatíveis (ex.: Elixir 1.18.x, OTP 27.x)
- Postgres em execução local (ou em outro host acessível)

Instalação e execução:

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

Usando `.env` localmente (opcional):

```bash
set -a; source .env; set +a
mix phx.server
```

### 🧩 Somente Postgres no Docker + app local

Se preferir rodar apenas o banco no Docker e o app localmente:

```bash
docker compose up -d postgres

# No seu terminal local (app), aponte o host para o serviço do Compose
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_USER=postgres           # ou conforme seu .env/.compose
export POSTGRES_PASSWORD=postgres       # ou conforme seu .env/.compose
export POSTGRES_DB=star_bank_dev        # ou conforme seu .env/.compose

mix ecto.setup
mix phx.server
```

## Como testar

### Testando com Docker

Rodando testes dentro do serviço do app, compartilhando a rede com o Postgres do Compose:

```bash
docker compose run --rm \
	-e MIX_ENV=test \
	-e POSTGRES_HOST=postgres \
	-e POSTGRES_DB=star_bank_test \
	starbank mix test
```

Observações:
- O `config/test.exs` aceita sobrescrever `POSTGRES_*`. Por padrão, usa `hostname: "localhost"` quando rodando fora do Docker.
- O banco de teste é criado automaticamente pelos aliases do Mix.

### Testando sem Docker

Com Postgres local ou o Postgres do Compose mapeado para 5432:

```bash
export MIX_ENV=test
export POSTGRES_HOST=localhost
export POSTGRES_DB=star_bank_test

mix test
```

## Atalhos Mix

Do arquivo `mix.exs`:

- `mix setup` — instala deps e prepara o banco: `deps.get` + `ecto.setup`.
- `mix ecto.setup` — cria, migra e roda seeds: `ecto.create` + `ecto.migrate` + `run priv/repo/seeds.exs`.
- `mix ecto.reset` — derruba e recria o banco: `ecto.drop` + `ecto.setup`.
- `mix test` — cria e migra banco de teste (silencioso) e roda testes: `ecto.create --quiet` + `ecto.migrate --quiet` + `test`.
- `mix precommit` — compila com warnings como erro, remove deps não usadas, formata e roda testes:
	`compile --warning-as-errors` + `deps.unlock --unused` + `format` + `test`.

## Próximos passos

Buscando melhorar o projeto em alguns pontos:

- Adicionar `.env.example` e atualizar `.gitignore` — feito ✅
- Adicionar Docker — feito ✅ (com entrypoint e `docker compose`)
- Adicionar CI — feito ✅ (GitHub Actions com Postgres de serviço)
- Atualizar o README com todos os tópicos — feito ✅
- Criar histórico de transferências — em progresso 🔄

## Outros projetos

Apesar de empolgado com os próximos passos, também devo dar atenção a outros projetos:

- Criar uma API de acervo digital em Python (referência [aqui](https://fastapidozero.dunossauro.com/estavel/15/)).
- Criar um [Leilão online](https://github.com/danielmsilverio/auction_app) em Elixir — repositório criado, escrevendo entregáveis.
- Projeto recente em Python: [To-Do com FastAPI](https://github.com/danielmsilverio/fast-zero).
