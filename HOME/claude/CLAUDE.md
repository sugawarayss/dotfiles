# グローバル設定について

このファイルは プロジェクトを問わず全セッションで読み込まれる。
プロジェクト固有の事項は各リポジトリの `CLAUDE.md` に書き、ここには環境・作業環境・全般的な振る舞いなど横断的な内容のみを記載する。

## rules/ ディレクトリとの関係

`rules/` にはタスク固有のルールを記載する。

- [design_principles.md](rules/design_principles.md) — KISS/DRY/YAGNI/SOLID/早期リターン/命名規則/PoLA。コード実装時の設計方針。
- [cross_project_memory.md](rules/cross_project_memory.md) — Obsidian vault (`obsidian_notes/ClaudeCode/`) へのプロジェクト横断メモリの書き出し方針。
- [python.md](rules/python.md) — `**/*.py`に対して適用されるPythonコード実装ルール（frontmatterの `paths` でスコープ指定）。
- [pytest_coding.md](rules/pytest_coding.md) — `tests/**/test_*.py` に対してのみ適用されるテストコード実装ルール（frontmatterの `paths` でスコープ指定）。
- [use_cli.md](rules/use_cli.md) — `bat`/`eza`/`fd`/`sd`/`ripgrep`/`pandoc`/`jq`/`yq` など、積極的に使ってよいCLIツール一覧。
- [git_workflow.md](rules/git_workflow.md) — ブランチ命名・コミットメッセージ・PR/コミットの粒度・マージ方針に関するGitワークフロー規約（全体適用）。
- [accessibility.md](rules/accessibility.md) — `**/*.tsx`/`**/*.jsx`に対して適用されるアクセシビリティ実装ルール（frontmatterの `paths` でスコープ指定）。
- [api_design.md](rules/api_design.md) — APIルート/ルーター実装（Next.js API Routes・FastAPIルーター等）に対して適用されるREST API設計ルール（frontmatterの `paths` でスコープ指定）。

新しい横断ルールを追加する場合は、この一覧にも追記すること。

## 環境・ツール

- OS: macOS / Shell: fish
- Python: `uv` を使用（pip/venvの直接操作はしない）
- Node: `pnpm` を使用（npm/yarnは使わない）
- バージョン管理・タスク実行: `mise run`, `task`, `just`
- ファイル閲覧・検索・差分: `bat`, `eza`, `fd`, `sd`, `rg`, `jq`, `yq` を標準ツールより優先してよい
- GitHub操作: `gh` CLI
- Obsidian vault操作: `obsidian` CLI（vault名 `obsidian_notes`）。[[cross_project_memory]] 参照
- プランレビュー: `crit`（`/crit` スキル経由。critセッションがなければ起動する）。起動する際は、①`--no-open` を付けてブラウザの自動起動を止め、出力されるレビューURL（`http://localhost:<port>`）を `terminal-browser open <url> --split right` でherdr内のペインに開く、②`--no-open` を付けずにcrit標準のブラウザ起動に任せる、のどちらで開くかをユーザーに確認してから実行すること。
    - `terminal-browser`のリファレンスは `/terminal-browser`で参照できる。
- コード差分レビュー: `hunk`（`hunk-review` スキル経由。ユーザーがターミナルでセッションを起動している前提）
- PRレビュー: `tuicr`（`review-pr` スキル経由。Herdr環境では右にペインを割いて `tuicr pr <PR>` を自動起動、それ以外はユーザーに起動を依頼する。コメント追加後、GitHubへの送信はユーザーがTUI内で `:submit` を実行する手動操作）

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
- 実装プランなど **非コードの成果物** をレビューしてもらう場合は、必ず `/crit` を自動的に実行する。
- コードの差分を変更・実装した後は、Hunk（`hunk-review` スキル）でレビューしてもらう。ライブセッションが無ければユーザーに起動を依頼してから進める。
