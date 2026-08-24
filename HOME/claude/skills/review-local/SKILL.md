---
name: review-local
description: >
  ローカルブランチとベースブランチの diff を取得し、正確性・バグを中心にコードレビューを行います。
  ロジック誤り、エッジケースの考慮漏れ、エラーハンドリング不備、意図しない副作用、既存コードとの整合性、テスト不足などを検出します。
  ユーザーが「ローカルの変更をレビューして」「この diff をチェックして」「マージ前にレビューして」「review-local」「/review-local」と入力した場合に使用します。
  complexity-review（過剰設計の検出）・audit-review（リポジトリ全体の過剰設計監査）を補完する立ち位置で、こちらは正確性・バグに特化します。
allowed-tools: Agent Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git merge-base:*) Bash(git rev-list:*) Bash(hunk:*) Bash(herdr:*) Read Grep mcp__context7__*
---

ベースブランチとの diff を取得し、正確性・バグの観点でレビューします。
発見事項ごとに1行、行番号・タグ・問題点・修正案を記述します。

diffが大きい場合（目安: 変更300行以上、または5ファイル以上）は、Agentツールで `code-reviewer` にdiff全体（後述の `hunk session review --include-patch` の出力）と下記のレビュー観点・タグ定義を渡して正確性・バグ観点の分析を委譲してよい。読み取り専用で分析させ、返却された指摘を下記のフォーマットに整形してhunkへ投稿する。diffが小さい場合は直接分析してよい。

## ベースブランチの決定

1. ユーザーが比較対象のブランチを明示していれば、それを使う（例:「develop と比較して」→ `develop`）。
2. 指定がなければ、リモートのデフォルトブランチを自動検出する。
   `git symbolic-ref refs/remotes/origin/HEAD --short` でデフォルトブランチ（例: `origin/main`）を取得する。
3. リモート HEAD が取得できない場合は、現在のブランチの upstream 追跡ブランチ（`git rev-parse --abbrev-ref --symbolic-full-name @{u}`）をベースにする。

## Diffの対象範囲を決める（merge-base）

```bash
git merge-base <base> HEAD
```

**ブランチ名（`<base>`）そのものを対象にしない。** `hunk diff <base>` のように単一ターゲットへブランチ名を渡すと、baseブランチが自分より先に進んでいた場合その変更までノイズとして混ざる（三点記法`<base>...HEAD`が必要な理由と同じ）。加えて **三点記法自体はコミット済みの範囲しか見ず、作業ツリーの未コミット変更を含められない**（実機確認済み: `hunk diff main...HEAD` はfileCount 0、`hunk diff main`単体だと未コミット変更を含んだfileCount 2になった）。

解決策は上記コマンドで得た **merge-baseのコミットSHA自体を単一ターゲットとして渡す**こと。`hunk diff <merge-base-sha>` は「そのコミットから現在の状態（作業ツリー含む）まで」を比較するため、(a) baseブランチの独自の進行はノイズに入らず、(b) コミット済みの変更と未コミットの変更の両方を1つのdiffでレビューできる。以降、この節で得た `<merge-base-sha>` を対象rangeとして使う。

baseブランチの独自進行そのものは、レビュー対象からは除外するが無視はしない。件数だけ数えておく:

```bash
git rev-list --count <merge-base-sha>..<base>
```

0件より多ければ、最後のスコア報告で「baseからN件遅れているのでrebase推奨」と一言添える（差分レビュー自体には混ぜない）。

## Hunkセッションを用意する

diffの取得（分析用）とコメントの投稿先を、同じHunkのライブセッションに一本化する。`hunk-review` スキルと同じ「TUIは人間、専用サブコマンドはエージェント」という設計に従い、Hunkの対話TUI自体は起動しない。

### Herdr環境の場合（`test "${HERDR_ENV:-}" = 1`）

ユーザーに確認や依頼をせず自動で用意する。

```bash
hunk session list --json
```

このリポジトリ（`repoRoot`）を指すセッションが既にあれば、新規ペインは開かず対象rangeへreloadするだけにする:

```bash
hunk session reload --repo . -- diff <merge-base-sha>
```

無ければ右側に新規ペインを割いて起動する:

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
# → .result.pane.pane_id を取得
herdr pane run <pane_id> "hunk diff <merge-base-sha>"
```

### Herdr環境でない場合

`hunk session list --json` で確認し、このリポジトリのセッションが無ければユーザーに「`hunk diff <merge-base-sha>` を実行してください」と伝えて起動を依頼し、実行完了の報告を待つ。既にセッションがある場合は同様に `reload` で対象rangeに揃える。

## Diff の取得（分析用）

セッションが対象rangeを表示していることを確認したら、そのセッションから分析対象のdiffを取得する。

```bash
hunk session review --repo . --json              # まずファイル/hunk構造とサイズ（additions/deletions/fileCount）を把握
hunk session review --repo . --include-patch --json  # 本当に生diffのテキストが必要な時だけ追加取得
```

`git diff` を別途実行する必要はない（セッションが同じ対象rangeを表示しているため内容は同一）。

## レビュー観点

詳細な観点は [references/review-criteria.md](./references/review-criteria.md) を参照する。
ロジック誤り、エッジケースの考慮漏れ、エラーハンドリング不備、意図しない副作用、既存コードとの整合性、テストの欠如を中心に見る。

## 報告方法

発見事項はテキストで一覧表示せず、`hunk session comment add`/`comment apply` でファイルの該当行にインラインコメントとして投稿する。

1. 対象ファイルパスは diff のパス（リポジトリルートからの相対パス）をそのまま使う。
2. 行番号は diff の new-side（`+`側、現在のファイル内容に対応する行番号）を使う。`comment add` は `--new-line`、`comment apply` は `newLine` フィールドを使う。
3. コメント本文（`--summary` / `summary`）は `<タグ> <何が問題か>. <修正案>.` の形式（タグは下記）。
4. `--author 'review-local'` を必ず付与する。
5. 3件以上ある場合は `comment apply --stdin` で一括投稿する（1プロセスで検証してから反映される）。

```bash
printf '%s\n' '{"comments":[
  {"filePath": "src/auth.go", "newLine": 42, "summary": "BUG: user が null の場合に user.name へアクセスして TypeError が発生する. 早期リターンでガード節を追加.", "author": "review-local"},
  {"filePath": "api.py", "newLine": 88, "summary": "EDGE: 空配列を渡した場合に IndexError が発生する. 空配列チェックを先頭に追加.", "author": "review-local"}
]}' | hunk session comment apply --repo . --stdin --json
```

投稿するとライブセッションに即座に反映される（再起動不要）。crit方式のような「Finish Review待ち」の処理は行わない。投稿件数をユーザーに報告し、Hunk上で確認・対応してもらう。

### タグ

- `BUG:` 明確なロジック誤り。実際に問題が発生するシナリオが想定できるもの。
- `EDGE:` 境界値・特殊入力（null、空配列、0、負数等）の考慮漏れ。
- `ERR:` 例外・エラーハンドリングの不備（握りつぶし、リソース解放漏れ、ログ不足等）。
- `RISK:` 名前から予測できない副作用や意図しない状態変更（PoLA違反）。
- `INCONSISTENT:` 既存コードとの命名・パターンの不一致。
- `TEST:` 変更されたロジックに対応するテストの欠如。

## スコア

最後に `net: <N>件をhunkにコメントとして投稿。` で締めくくる。
指摘がない場合はコメントを投稿せず、チャットで `LGTM` と伝えるだけにする（hunkにはcrit/tuicrのような「レビュー全体コメント」の概念が無いため）。
baseからの遅れが1件以上あれば、続けて `baseからN件遅れています。rebase推奨。` と一言添える。

## 境界

スコープは正確性・バグのみ。過剰設計や複雑性は complexity-review / audit-review の対象であり、ここでは扱わない。セキュリティ脆弱性は security-review の対象であり、ここでは扱わない（明確なバグに起因する場合を除く）。
指摘はコメント投稿のみで、修正の適用・返信・解決（resolve）は行わない。1回限りの実行。
「stop review-local」または「normal mode」と言われたら中断し、通常のレビュースタイルに戻る。
