---
name: coding-rules
description: Apply shared design principles and path-specific conventions when creating, modifying, reviewing, or testing code.
---

# Coding Rules

コードを作成・変更・レビュー・テストする場合は、作業前に[設計原則](references/design-principles.md)を全文読む。
対象ファイルのリポジトリルートからの相対パスを確認し、一致する参照ファイルも作業前に全文読む。
複数の条件に一致する場合は、該当する参照をすべて適用する。
対象ファイルが作業中に増えた場合は、新たに一致した参照をそのファイルの編集前に読む。

## ルーティング

- `**/*.py`: [Python](./references/python.md)
- `tests/**/test_*.py`: [pytest](./references/pytest.md)
- `**/*.ts`、`**/*.tsx`: [TypeScript](./references/typescript.md)
- `**/*.tsx`、`**/*.jsx`: [React](./references/react.md)および[アクセシビリティ](./references/accessibility.md)
- `**/api/**/*.ts`、`**/api/**/*.tsx`、`**/routers/**/*.py`、`**/api/**/*.py`: [REST API](./references/api-design.md)
- `**/Dockerfile`、`**/Dockerfile.*`、`**/docker-compose.yml`、`**/docker-compose.*.yml`: [Docker](./references/docker.md)

一致する参照がない場合は、設計原則のみを適用する。
リポジトリ内の指示が参照内容と競合する場合は、より具体的なリポジトリ内の指示を優先する。
