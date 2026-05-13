# Jogo de Adivinhação com Docker Compose

Este repositório contém uma aplicação de jogo de adivinhação com infraestrutura Docker Compose completa.
O sistema usa um backend Flask, um banco de dados PostgreSQL e um frontend React servido por NGINX.

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

