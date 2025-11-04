# StarBank

StarBank é um projeto a fim de estudo. A ideia é criar uma API onde temos cadastro de usuário, uma conta com saldo e poder realizar transferências entre contas.

Como projeto é afim de estudo, ele é bem simples em regra de negócio, mais informações em [status](#status)

Apesar de já ter experiência com Elixir + Phoenix, resolvi fazer um curso para reciclar meu conhecimento e deixar o projeto como portifólio.

## Setup

[Status](#status)
[Como executar](#como-executar)

## Status

O curso já concluído trouxe alguns tópicos:
- **Fundamentos do Elixir**: Aqui recapitulando como funciona os tipos básicos, listas, tuplas, maps, Enum, pattern matcing e pipe operator
- **Projeto FizzBuzz**: Projeto simples onde seu foco foi em reforçar o conhecimento do primeiro tópico.
- **Projeto jogo EXmon**: Projeto a parte que simula uma batalha, onde, além de reforçar os dois primeiros módulos, apresentou também o uso do Agent
- **Introdução Phoenix**: Etapa simples para conhecer a estrutura do phoenix (sem LiveView). A partir daqui, começou a estruturar o projeto
- **CRUD  de Usuários**: Criação de todo o crud do usuário, tendo as migrações, changeset, lidando com erros e adicionando testes.
- **Realizandop requisições externas**: Tópico que apresentou o uso das libs [Tesla](https://hexdocs.pm/tesla/Tesla.html), [Bypass](https://hexdocs.pm/bypass/Bypass.html) e [Mox](https://hexdocs.pm/mox/Mox.html). Com isso, construído consulta externa para validar o campo cep do usuário.
- **Criando transferências**: Criamos a parte da conta, entendendo um pouco da lib Decimal e as regras de negócio, explorando o uso do Multi e Repo.transaction
- **Autenticando nossa aplicação**: Explicado sobre a estrutura de tokens, Plugs e o uso de argon2_elixir.
- **Deploy da Aplicação**: Aqui é sobre o uso do [fly.io](https://fly.io/). Infelizmente, uma atualização recente trouxe somente a versão paga do postgres. Como o foco do projeto é aprendizado, tomei a decisão de não pagar por ele. Talvez decida sobre usar um banco de outra sistema para a fins de estudo.
- **Bônus: Um pouco sobre Processos e OTP**: Aqui uma parte interessante para conhecer sobre como funciona o processo elixir na prática, Tasks (start, async stream), Genservers e Supervisionando os genserver

🪧 A princípio, segue o [certificado expedido pela plataforma Udemy](https://www.udemy.com/certificate/UC-abbce423-3836-47d7-8e4a-d91b6d7d39e2)

Ao concluir o curso, alguns testes quebraram e precisei ajustar algumas coisas, onde entro com outros tópicos:

- 🐛 **Teste quebrado por causa de autenticação**: Arrumei os testes adicionando o token
- 🐛 **Qualquer usuário podendo executar alterações de outros usuários**: Utilizei o [Bodyguard](https://hexdocs.pm/bodyguard/) para gerenciar as permissões do usuário

A partir daqui, resolvi colocar o projeto no github (por isso do primeiro commit ser grande 🫠)
Outras pontos de melhoria pode ver em [Próximos passos](#próximos-passos)

## Como executar

### 🐳 Executando com Docker (Recomendado)

### 💧 Executando sem Docker

## Como testar

## Atalhos mix

## Próximos passos

Buscando melhorar o projeto em alguns pontos que senti falta, segue os planos de atualização:

- Adicionar .env.example e atualizar .gitignore
<br> Para os próximos pontos, precisei adicionar .env e ajustar as variáveis de ambiente das configs;

- Adicionar Docker
<br>Aqui deu um pouco de trabalho, revisitei alguns projetos antigos para lembrar um pouco da estrutura. Não deu para fugir do entrypoints no primeiro momento. Adicionado o compose para subir com o bd também

- Adicionar CI
- Atualizar o README com todos os tópicos
- Criar histórico de transferências


## Outros projetos

Apesar de me empolgar com os próximos passos desse projeto, devo dar uma atenção em outros dois projetos:

- Criar uma API de acervo digital em python, como menciona [aqui](https://fastapidozero.dunossauro.com/estavel/15/)
- Criar uma [Leilão online](https://github.com/danielmsilverio/auction_app) em Elixir - só criei o repositório, ainda estou escrevendo os entregáveis

Além de que já possuo um projeto de estudo em Python que realizei recentemente: [To-Do com FastAPI](https://github.com/danielmsilverio/fast-zero)
