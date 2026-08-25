---
name: review-local
description: >
  ローカルブランチとベースブランチの diff を取得し、品質・セキュリティ・パフォーマンス・テスト・ドキュメントの
  5観点で専門subagentに分析を並列委譲してコードレビューを行います（review-pr と同じ観点構成をローカルdiff向けに適用）。
  ユーザーが「ローカルの変更をレビューして」「この diff をチェックして」「マージ前にレビューして」「review-local」「/review-local」と入力した場合に使用します。
  complexity-review（差分の過剰設計検出）・audit-review（リポジトリ全体の過剰設計監査）を補完する立ち位置です。
allowed-tools: Agent Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git merge-base:*) Bash(git rev-list:*) Bash(git diff:*) Bash(tuicr:*) Bash(herdr:*) Read Grep Glob mcp__context7__* mcp__*
---

ベースブランチとの diff を取得し、品質・セキュリティ・パフォーマンス・テスト・ドキュメントの5観点で専門subagentに分析を並列委譲してレビューします。発見事項ごとに行番号・タグ・問題点・修正案を tuicr へインラインコメントとして投稿します。

## ベースブランチの決定

1. ユーザーが比較対象のブランチを明示していれば、それを使う（例:「develop と比較して」→ `develop`）。
2. 指定がなければ、リモートのデフォルトブランチを自動検出する。
   `git symbolic-ref refs/remotes/origin/HEAD --short` でデフォルトブランチ（例: `origin/main`）を取得する。
3. リモート HEAD が取得できない場合は、現在のブランチの upstream 追跡ブランチ（`git rev-parse --abbrev-ref --symbolic-full-name @{u}`）をベースにする。

## Diffの対象範囲を決める（merge-base）

```bash
git merge-base <base> HEAD
```

**ブランチ名（`<base>`）そのものを対象にしない。** `tuicr -r <base>..HEAD -w` のようにブランチ名を渡すと、baseブランチが自分より先に進んでいた場合その変更までノイズとして混ざる。加えて **`-r <range>` だけではコミット済みの範囲しか見ず、作業ツリーの未コミット変更を含められない**（実機確認済み: `tuicr -r <sha>..HEAD` 単体はコミット済み変更のみ、`-w` を併用した `tuicr -r <sha>..HEAD -w` で初めて未コミット変更も含んだ表示になった）。

解決策は上記コマンドで得た **merge-baseのコミットSHA自体をrevsetの起点として使い、`-w` を必ず併用する**こと。`tuicr -r <merge-base-sha>..HEAD -w` は「そのコミットから現在の状態（作業ツリー含む）まで」を比較するため、(a) baseブランチの独自の進行はノイズに入らず、(b) コミット済みの変更と未コミットの変更の両方を1つのセッションでレビューできる。以降、この節で得た `<merge-base-sha>` を対象rangeとして使う。

baseブランチの独自進行そのものは、レビュー対象からは除外するが無視はしない。件数だけ数えておく:

```bash
git rev-list --count <merge-base-sha>..<base>
```

0件より多ければ、最後のスコア報告で「baseからN件遅れているのでrebase推奨」と一言添える（差分レビュー自体には混ぜない）。

## tuicrセッションを用意する

コメントの投稿先となる、対象range（`<merge-base-sha>..HEAD` を `-w` 付き）のtuicrライブセッションを用意する。`review-pr` スキルと同じ「TUIは人間、専用サブコマンドはエージェント」という設計に従い、tuicrの対話TUI自体（Herdr環境で開く新規ペインを除く）は自分では操作しない。

### セッションの有無を確認

```bash
tuicr review list --repo .
```

`kind: "local"` で、対象range（mode: `staged-and-unstaged-and-commits`、sha部分が `<merge-base-sha 7桁>..<HEAD 7桁>`）に対応するセッションの `slug` があれば再利用する。無ければ以下の通り起動する。

**tuicrはヘッドレスにセッションを新規作成できない（TTY付きでTUIを実際に開いた時にだけセッションが永続化される）。**

### Herdr環境の場合（`test "${HERDR_ENV:-}" = 1`）

ユーザーに確認や依頼をせず、右側に新規ペインを割いて自動的に起動する。`tuicr` スキル付属の `tuicr-wrapper-herdr.sh` はtuicrが閉じるまでブロックする設計のため、ここでは使わない（このスキルはセッションを開いたまま裏でsubagent分析・コメント投稿を進める必要があり、ユーザーの操作待ちでブロックされると先に進めない）。

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
# → .result.pane.pane_id を取得
herdr pane run <pane_id> "tuicr -r <merge-base-sha>..HEAD -w"
```

セッションの永続化には少し時間がかかることがある。`tuicr review list --repo .` に対象slugが現れるまで1〜2秒待って再試行する（最大5回程度）。5回試しても現れない場合はエラーとしてユーザーに報告し中断する。

### Herdr環境でない場合

ユーザーに「`tuicr -r <merge-base-sha>..HEAD -w` を実行してください」と伝えて起動を依頼し、実行完了の報告を待ってから次に進む。

## Diff の取得（分析用）

tuicrにはセッション内容をJSONで取り出すコマンドが無いため、各subagentへ渡す生diffは `git diff` で別途取得する。対象rangeはセッションと同じ `<merge-base-sha>` を使う（作業ツリーの未コミット変更も含まれる）。

```bash
git diff <merge-base-sha>
```

## 技術スタックの把握

変更されたファイルの拡張子・ディレクトリ構造・設定ファイル（package.json, Cargo.toml, go.mod, pyproject.toml, Gemfile, pom.xml, build.gradle 等）から、使用されている言語・フレームワーク・ライブラリを特定すること。特定した技術スタックに応じて、次のステップの各観点で注目すべきポイントを適切に調整すること。

## 専門subagentによる並列分析

Agentツールを使用し、以下5つの専門subagent_typeを**1回のメッセージで並列**に起動して観点ごとの分析を分担すること。それぞれ新規に起動される（会話コンテキストを持たない）ため、各agentのpromptには必ず次を含めること:

- 分析対象range（merge-baseのコミットSHA）と、diff取得コマンド（`git diff <merge-base-sha>`）
- 把握した技術スタックと、そのスタック固有のベストプラクティス・落とし穴に注目してほしい旨
- 下表の担当観点とその着眼点
- 出力フォーマット: 指摘ごとに `file`（diffに現れるパス。リポジトリルートからの相対パス）・`line`（diffのnew-side行番号。範囲があれば `"<start>-<end>"`）・`tag`（下記タグ定義から該当するもの）・`summary`（`<タグ> <何が問題か>. <修正案>.` の形式）を持つJSON配列で返すこと。指摘が無ければ空配列を返すこと
- **読み取り専用で分析すること**（コードの変更やファイル作成は行わない）
- 必要であれば `mcp__context7__*`（技術スタックの最新ドキュメント）を使ってよいこと

| 観点 | subagent_type | 着眼点 |
|---|---|---|
| 品質 | `code-reviewer` | コードの可読性、命名の適切さ／設計・責務分離（関数やクラスが大きすぎないか）／重複コードの有無／エラーハンドリングの適切さ／ロジック誤り・エッジケースの考慮漏れ／既存コードとの一貫性（詳細は [references/review-criteria.md](./references/review-criteria.md)） |
| セキュリティ | `security-auditor` | ユーザー入力のバリデーション・サニタイズ／認証・認可の漏れ／シークレットや機密情報のハードコード／依存ライブラリの既知の脆弱性／技術スタック特有のリスク（SQLインジェクション, XSS, CSRF, デシリアライズ脆弱性, パストラバーサル 等） |
| パフォーマンス | `performance-engineer` | 不要なループやネスト、計算量の問題／I/O・ネットワーク呼び出しの効率性／キャッシュやメモ化の活用余地／メモリ使用量・リソースリーク／技術スタック特有の懸念（N+1クエリ, 不要な再レンダリング, GCプレッシャー 等） |
| テスト | `qa-expert` | 変更に対するテストが追加・更新されているか／エッジケースや異常系のカバー／テストの可読性と保守性／テストが実装の詳細に依存しすぎていないか |
| ドキュメント | `technical-writer` | 変更に伴いREADMEやAPIドキュメントの更新が必要か／複雑なロジックに対するコード内コメントの有無／型定義やインターフェースの変更がドキュメントに反映されているか |

全agentの完了通知を待ってから、返却されたJSON配列を1つの `comments` 配列に統合すること。

### タグ

- `BUG:` 明確なロジック誤り。実際に問題が発生するシナリオが想定できるもの。
- `EDGE:` 境界値・特殊入力（null、空配列、0、負数等）の考慮漏れ。
- `ERR:` 例外・エラーハンドリングの不備（握りつぶし、リソース解放漏れ、ログ不足等）。
- `RISK:` 名前から予測できない副作用や意図しない状態変更（PoLA違反）。
- `INCONSISTENT:` 既存コードとの命名・パターンの不一致。
- `TEST:` 変更されたロジックに対応するテストの欠如。
- `SEC:` セキュリティ脆弱性・機密情報の扱いの不備。
- `PERF:` パフォーマンス上の懸念。
- `DOC:` ドキュメント・コメントの更新漏れ。

## 報告方法（tuicrへ投稿）

発見事項はテキストで一覧表示せず、`tuicr review add` でファイルの該当行にインラインコメントとして投稿する。

1. 対象ファイルパスは diff のパス（リポジトリルートからの相対パス）をそのまま `--target-file` に渡す。
2. 行番号は diff の new-side（`+`側、現在のファイル内容に対応する行番号）を `--line`（範囲があれば `--end-line` も）に渡す。`--side` は省略時 `new` になるため指定不要。
3. コメント本文は各subagentが返した `<タグ> <何が問題か>. <修正案>.` 形式をそのまま使う。
4. **必ず `--username 'review-local'` を付ける**（人間のコメントと視覚的に区別するため）。
5. `tuicr review add` は1回につき1件しか投稿できない（複数件をまとめて渡すオプションは無い）ため、統合した `comments` 配列を指摘の数だけループして呼び出す。

```bash
tuicr review add --session '<slug>' --repo . --target-file src/auth.go --line 42 --username 'review-local' "BUG: user が null の場合に user.name へアクセスして TypeError が発生する. 早期リターンでガード節を追加."

tuicr review add --session '<slug>' --repo . --target-file api.py --line 12 --username 'review-local' "SEC: APIキーがハードコードされている. 環境変数から読み込むよう変更."
```

投稿するとライブセッションに即座に反映される（再起動不要）。crit方式のような「Finish Review待ち」の処理は行わない。投稿件数をユーザーに報告し、tuicr上で確認・対応してもらう。

## スコア

最後に `net: <N>件をtuicrにコメントとして投稿。` で締めくくる。
指摘がない場合はコメントを投稿せず、チャットで `LGTM` と伝えるだけにする（review-localでは個別指摘のインラインコメントのみを扱い、review-prのようなPR概要相当の全体コメントは投稿しない）。
baseからの遅れが1件以上あれば、続けて `baseからN件遅れています。rebase推奨。` と一言添える。

## 境界

過剰設計や複雑性は complexity-review / audit-review の対象であり、ここでは扱わない。
指摘はコメント投稿のみで、修正の適用・返信・解決（resolve）は行わない。1回限りの実行。
「stop review-local」または「normal mode」と言われたら中断し、通常のレビュースタイルに戻る。
