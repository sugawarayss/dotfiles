---
name: review-local
description: >
  ローカルブランチとベースブランチの diff を取得し、正確性・バグを中心にコードレビューを行います。
  ロジック誤り、エッジケースの考慮漏れ、エラーハンドリング不備、意図しない副作用、既存コードとの整合性、テスト不足などを検出します。
  ユーザーが「ローカルの変更をレビューして」「この diff をチェックして」「マージ前にレビューして」「review-local」「/review-local」と入力した場合に使用します。
  complexity-review（過剰設計の検出）・audit-review（リポジトリ全体の過剰設計監査）を補完する立ち位置で、こちらは正確性・バグに特化します。
allowed-tools: Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git diff:*) Bash(crit:*) Read Grep mcp__context7__*
---

ベースブランチとの diff を取得し、正確性・バグの観点でレビューします。
発見事項ごとに1行、行番号・タグ・問題点・修正案を記述します。

## ベースブランチの決定

1. ユーザーが比較対象のブランチを明示していれば、それを使う（例:「develop と比較して」→ `develop`）。
2. 指定がなければ、リモートのデフォルトブランチを自動検出する。
   `git symbolic-ref refs/remotes/origin/HEAD --short` でデフォルトブランチ（例: `origin/main`）を取得する。
3. リモート HEAD が取得できない場合は、現在のブランチの upstream 追跡ブランチ（`git rev-parse --abbrev-ref --symbolic-full-name @{u}`）をベースにする。

## Diff の取得

`git diff <base>...HEAD` で取得する。二点ではなく三点記法を使うことで、ベースブランチとの共通の祖先（merge-base）以降にローカルブランチだけが加えた変更に絞り込む。GitHub の PR diff と同じ範囲になる。

## レビュー観点

詳細な観点は [references/review-criteria.md](./references/review-criteria.md) を参照する。
ロジック誤り、エッジケースの考慮漏れ、エラーハンドリング不備、意図しない副作用、既存コードとの整合性、テストの欠如を中心に見る。

## 報告方法

発見事項はテキストで一覧表示せず、`crit comment` でファイルの該当行にインラインコメントとして投稿する。

1. 対象ファイルパスは diff のパス（リポジトリルートからの相対パス）をそのまま使う。
2. 行番号は diff の new-side（`+`側、現在のファイル内容に対応する行番号）を使う。範囲があれば `"<start>-<end>"` を使う。
3. コメント本文は `<タグ> <何が問題か>. <修正案>.` の形式（タグは下記）。
4. `--base-branch <base>` を付け、Diff取得時に使ったベースブランチとレビューのスコープを一致させる。
5. `--author 'review-local'` を必ず付与する。
6. 3件以上ある場合は `--json` で一括投稿する（1プロセスで原子的に書き込まれる）。

```bash
echo '[
  {"file": "src/auth.go", "line": 42, "body": "BUG: user が null の場合に user.name へアクセスして TypeError が発生する. 早期リターンでガード節を追加."},
  {"file": "api.py", "line": "88", "body": "EDGE: 空配列を渡した場合に IndexError が発生する. 空配列チェックを先頭に追加."}
]' | crit comment --json --base-branch <base> --author 'review-local'
```

投稿が終わったら `crit` を `run_in_background: true` で起動する。出力される `Started crit daemon at http://localhost:<port>` の URL をそのままユーザーに伝え、バックグラウンドタスクの完了（ユーザーによる `Finish Review`）を待つ。

### タグ

- `BUG:` 明確なロジック誤り。実際に問題が発生するシナリオが想定できるもの。
- `EDGE:` 境界値・特殊入力（null、空配列、0、負数等）の考慮漏れ。
- `ERR:` 例外・エラーハンドリングの不備（握りつぶし、リソース解放漏れ、ログ不足等）。
- `RISK:` 名前から予測できない副作用や意図しない状態変更（PoLA違反）。
- `INCONSISTENT:` 既存コードとの命名・パターンの不一致。
- `TEST:` 変更されたロジックに対応するテストの欠如。

## スコア

最後に `net: <N>件をcritにコメントとして投稿。` で締めくくる。
指摘がない場合はインラインコメントは投稿せず、 `crit`を起動し、 `LGTM` とだけコメント。

## 境界

スコープは正確性・バグのみ。過剰設計や複雑性は complexity-review / audit-review の対象であり、ここでは扱わない。セキュリティ脆弱性は security-review の対象であり、ここでは扱わない（明確なバグに起因する場合を除く）。
指摘はコメント投稿のみで、修正の適用・返信・解決（resolve）は行わない。1回限りの実行。
「stop review-local」または「normal mode」と言われたら中断し、通常のレビュースタイルに戻る。
