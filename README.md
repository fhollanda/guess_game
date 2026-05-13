# Jogo de Adivinhação com Docker Compose

Este repositório contém uma aplicação de jogo de adivinhação com infraestrutura Docker Compose completa.
O sistema usa um backend Flask, um banco de dados PostgreSQL e um frontend React servido por NGINX.

## Funcionalidades

- Criação de um novo jogo com uma senha fornecida pelo usuário.
- Adivinhe a senha e receba feedback se as letras estão corretas e/ou em posições corretas.
- As senhas são armazenadas  utilizando base64.
- As adivinhações incorretas retornam uma mensagem com dicas.

## Como Jogar

### 1. Criar um novo jogo

Acesse a url do frontend http://localhost

Digite uma frase secreta

Envie

Salve o game-id


### 2. Adivinhar a senha

Acesse a url do frontend http://localhost

Vá para o endponint breaker

entre com o game_id que foi gerado pelo Creator

Tente adivinhar

## Estrutura do Código

### Rotas:

- **`/create`**: Cria um novo jogo. Armazena a senha codificada em base64 e retorna um `game_id`.
- **`/guess/<game_id>`**: Permite ao usuário adivinhar a senha. Compara a adivinhação com a senha armazenada e retorna o resultado.

### Classes Importantes:

- **`Guess`**: Classe responsável por gerenciar a lógica de comparação entre a senha e a tentativa do jogador.
- **`WrongAttempt`**: Exceção personalizada que é levantada quando a tentativa está incorreta.

## Arquitetura

- `postgres`
  - usa a imagem oficial `postgres:15-alpine`
  - dados armazenados em volume persistente `postgres_data`
  - reinício automático configurado com `restart: always`
- `backend`
  - container Python/Flask construído a partir de `Dockerfile.backend`
  - usa variáveis de ambiente para conectar ao Postgres
  - expõe internamente a porta `5000`
  - pode ser escalado com `docker compose up --scale backend=2`
- `frontend`
  - container NGINX construído a partir de `Dockerfile.frontend`
  - serve os arquivos React e faz proxy reverso ao backend
  - balanceia carga para múltiplas instâncias do backend via `nginx.conf`
  - expõe a aplicação em `http://localhost`

## Como rodar

1. Ajuste as variáveis em `.env` se necessário.
2. Execute:

   ```bash
   docker compose up --build --scale backend=2
   ```

3. Acesse a aplicação em:

   ```text
   http://localhost
   ```

## Opção de escala do backend

O projeto já suporta `docker compose up --scale backend=2`.
O NGINX usa `upstream backend` em `nginx.conf` com `server backend:5000 resolve;`, permitindo que múltiplas instâncias do backend sejam balanceadas.

## Resiliência e persistência

- todos os serviços têm `restart: always`
- o banco PostgreSQL armazena dados em volume separado `postgres_data`
- o backend e o frontend podem ser reiniciados automaticamente em caso de falha

## Atualização de componentes

A estrutura permite atualizar cada parte do sistema com pouca complexidade:

- backend: modifique `Dockerfile.backend` ou mude a imagem/base e execute `docker compose up --build`
- frontend: modifique `frontend/` ou `Dockerfile.frontend` e execute `docker compose up --build`
- banco: mude a versão da imagem Postgres em `docker-compose.yml` e execute `docker compose up`

## Serviços e endereços

- Frontend: `http://localhost`
- Backend (via proxy NGINX): `/create`, `/guess`, `/health`

## Pré-requisitos

- Docker Engine instalado
- Docker Compose v2 (`docker compose`)

## Licença

Este projeto está licenciado sob MIT.

