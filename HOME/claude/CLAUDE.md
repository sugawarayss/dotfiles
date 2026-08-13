# グローバル設定について

このファイルは プロジェクトを問わず全セッションで読み込まれる。
プロジェクト固有の事項は各リポジトリの `CLAUDE.md` に書き、ここには環境・作業環境・全般的な振る舞いなど横断的な内容のみを記載する。

## rules/ ディレクトリとの関係

`rules/` にはタスク固有のルールを記載する。

- [design_principles.md](rules/design_principles.md) — KISS/DRY/YAGNI/SOLID/早期リターン/命名規則/PoLA。コード実装時の設計方針。
- [cross_project_memory.md](rules/cross_project_memory.md) — Obsidian vault (`obsidian_notes/ClaudeCode/`) へのプロジェクト横断メモリの書き出し方針。
- [pytest_coding.md](rules/pytest_coding.md) — `**/test_*.py` に対してのみ適用されるテストコード実装ルール（frontmatterの `paths` でスコープ指定）。

新しい横断ルールを追加する場合は、この一覧にも追記すること。

## 環境・ツール

- OS: macOS / Shell: fish
- Python: `uv` を使用（pip/venvの直接操作はしない）
- Node: `pnpm` を使用（npm/yarnは使わない）
- バージョン管理・タスク実行: `mise run`, `task`, `just`
- ファイル閲覧・検索・差分: `bat`, `eza`, `fd`, `sd`, `colordiff`, `jq` を標準ツールより優先してよい
- GitHub操作: `gh` CLI
- Obsidian vault操作: `obsidian` CLI（vault名 `obsidian_notes`）。[[cross_project_memory]] 参照
- 作業の計画や、実装が完了した時は `crit`を使いユーザにreviewしてもらうこと

### 破壊的操作の扱い

以下は `settings.json` の `permissions.deny` によりBashから直接実行できない設定になっている。実行が必要な場合はコマンド内容を提示し、ユーザー自身に `! <command>` で実行してもらうこと。

- `git push` / `git rebase` / `git reset`
- `rm` / `rmdir` / `rsync --delete`
- `sudo` / `ssh` / `scp`

また `cat` / `find` / `head` / `tail` もBash実行が拒否される設定なので、代わりに `Read` / `Glob` / `Grep` ツールを使う。

`/tmp`（`/private/tmp`含む）配下に作成した検証用ディレクトリ・ファイルの削除に限っては、`~/.claude/bin/rm-tmp` が使える（`rm` のラッパーで、対象パスが `/tmp` 配下でなければ拒否する）。それ以外のパスの削除は引き続きユーザー確認が必要。

## コミュニケーションの好み

- 簡潔・直接的な応答を優先する（[[design_principles]] のKISSと同じ考え方）。
- 大きな変更や複数の選択肢がある設計判断は、実装前に方針を確認する。
- 計画や作業が完了した場合は `/crit:crit` を必ず使用して、ユーザにreviewしてもらう。
