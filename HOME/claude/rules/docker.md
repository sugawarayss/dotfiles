---
paths:
  - "**/Dockerfile"
  - "**/Dockerfile.*"
  - "**/docker-compose.yml"
  - "**/docker-compose.*.yml"
---

## Docker実装のルール

### マルチステージビルドでビルド依存を最終イメージに含めない

```dockerfile
# BAD
FROM node:20
COPY . .
RUN npm install && npm run build
CMD ["node", "dist/index.js"]

# GOOD
FROM node:20 AS build
COPY . .
RUN npm install && npm run build

FROM node:20-slim
COPY --from=build /dist ./dist
CMD ["node", "dist/index.js"]
```

### rootユーザーでコンテナを実行しない

```dockerfile
# BAD
FROM node:20-slim
CMD ["node", "index.js"]

# GOOD
FROM node:20-slim
USER node
CMD ["node", "index.js"]
```

### ベースイメージ・依存関係のバージョンは固定する

```dockerfile
# BAD
FROM node:latest

# GOOD
FROM node:20.11-slim
```

### 依存関係のインストールをソースコードのCOPYより先に行う

ソースコードだけが変わる変更で依存関係インストールのレイヤーキャッシュが無効化されるのを防ぐ。

```dockerfile
# BAD
COPY . .
RUN npm install

# GOOD
COPY package.json package-lock.json ./
RUN npm install
COPY . .
```

### `.dockerignore`でビルドコンテキストを最小化する

`node_modules`、`.git`、テストファイルなど、イメージに不要なものは`.dockerignore`に含める。
