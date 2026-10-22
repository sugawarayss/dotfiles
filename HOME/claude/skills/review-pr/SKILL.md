---
name: review-pr
description: プルリクエストのコードレビューを支援する。PRの品質・セキュリティ・パフォーマンス・テスト・ドキュメントの観点から分析し、構造化されたレビューコメントを生成する。技術スタック不問。
argument-hint: "[PR番号 or PRのURL（省略時はカレントブランチのPR）]"
allowed-tools: Agent, Bash(gh *), Bash(crit:*), Bash(terminal-browser:*), AskUserQuestion, Read, Grep, Glob, mcp__context7__*, mcp__*
user-invocable: true
---

# PRレビュー

# MCPツールの活用

指摘がライブラリ/フレームワーク固有のAPI仕様・推奨パターンに依存し、その内容に確信が持てない場合は、`mcp__context7__query-docs` で最新ドキュメントを確認してから指摘する。

**プロジェクトのインフラストラクチャがAWSを利用している場合**

1. **AWSのナレッジを取得**: `mcp__aws-*`の利用してプロジェクトに最適なナレッジを取得する。(リージョンは指定されない限り`ap-northeast-1`であると解釈する)

## ステップ1: レビュー対象のPRを特定

引数の有無で対象PRを判別すること。

### 引数ありの場合

`$ARGUMENTS` をPR番号またはURLとしてそのまま使用する。

### 引数なしの場合

カレントブランチに紐づくPRを自動検出する。以下のコマンドを実行すること：

```bash
gh pr view --json number,title,url
```

- PRが見つかった場合: そのPR番号を使って以降のステップを進める。
- PRが見つからなかった場合: 「カレントブランチに紐づくPRが見つかりませんでした。PR番号を指定して `/review-pr 123` のように実行してください。」と表示して終了する。

## ステップ2: PRの情報取得

ステップ1で特定したPR（以下 `<PR>` と表記）の情報を取得すること：

```bash
gh pr view <PR>
gh pr diff <PR>
gh pr diff <PR> --name-only
gh pr view <PR> --comments
```

## ステップ3: プロジェクトの技術スタックを把握

変更されたファイルの拡張子・ディレクトリ構造・設定ファイル（package.json, Cargo.toml, go.mod, pyproject.toml, Gemfile, pom.xml, build.gradle 等）から、使用されている言語・フレームワーク・ライブラリを特定すること。

特定した技術スタックに応じて、ステップ5の各観点で注目すべきポイントを適切に調整すること。

他のレビュワーのコメントも考慮に入れ、反論や意見がある場合はコメントすること。

## ステップ4: critセッションを用意する

ステップ5で各専門subagentが指摘を**直接**投稿できるよう、分析より前にcritのPRレビューセッションを起動し、セッションID `<session>` を確保しておく。

### 4-1. 開き方を確認する

AskUserQuestionで、レビュー画面の開き方をユーザーに確認する。

- ① `--no-open` でブラウザの自動起動を止め、レビューURLを `terminal-browser open <url> --split right` でherdr内のペインに開く
- ② `--no-open` を付けず、crit標準のブラウザ起動に任せる

### 4-2. critを起動する

Bashツールで `run_in_background: true` と `timeout: 86400000` を指定して起動する（ユーザーが Finish Review を押すまでブロックするため。完了はステップ9で受け取る）。

```bash
crit --pr <PR> --no-open   # ①の場合
crit --pr <PR>             # ②の場合
```

`crit pr <PR>` は引数を1つしか受け付けず `--no-open` を渡せないため、同じ処理になる `crit --pr` を使う。

起動出力（バックグラウンドタスクの出力ファイル）からレビューURL（`http://localhost:<port>`）を取得する。まだ出力されていなければ1〜2秒待って再確認する（最大5回）。①の場合は `terminal-browser open <url> --split right` で開く。

### 4-3. セッションIDを取得し、既存コメントを取り込む

```bash
crit status --json
```

`sessions` から対象PRのセッションIDを `<session>` として控える。続けて、**必ず** GitHub上の既存レビューコメントを取り込む。`crit --pr` だけではGitHub上のコメントはcritに表示されず、人間もsubagentも他のレビュワーのコメントを見られない。取り込んだコメントはGitHubのIDを持つため、ステップ9の push で重複投稿されることもない。

```bash
crit pull --session '<session>' <PR>
```

以降、この `<session>` をステップ5の各subagentに渡す。

## ステップ5: 専門subagentによる並列分析＋critへの直接投稿

Agentツールを使用し、以下5つの専門subagent_typeを**1回のメッセージで並列**に起動して観点ごとの分析を分担すること。それぞれ新規に起動される（会話コンテキストを持たない）ため、各agentのpromptには必ず次を含めること:

- レビュー対象PR番号 `<PR>` と、diff取得コマンド（`gh pr diff <PR>`、`gh pr diff <PR> --name-only`）
- ステップ3で把握した技術スタックと、そのスタック固有のベストプラクティス・落とし穴に注目してほしい旨
- 下表の担当観点とその着眼点
- ステップ4で確保した **critのセッションID `<session>`**（複数のcritセッションがあると `--session` なしの `crit comment` は投稿先を決められずエラーになるため、必ず渡す）
- 分析の前に `crit comments --session '<session>' --json --all` で既存のレビューコメント（GitHubから取り込んだ他のレビュワーのコメント、resolve済み・返信を含む）を読み、次のとおり扱うこと
  - 既存コメントと同じ内容の指摘は新規投稿しない
  - 既存コメントへの同意・反論・補足は `crit comment --session '<session>' --author 'review-pr' --reply-to <id> '<本文>'` で返信する（返信も `crit push` でGitHubに送信される）
  - 作成者が回答済み・resolve済みのものは、その回答自体に新たな問題がある場合だけ返信する
- 指摘を見つけたら、その場で下記の投稿コマンドを**自分で実行してcritに直接投稿すること**（メインエージェントには投稿を依頼しない）
- 出力フォーマット: 投稿がすべて終わったら、`posted`（投稿できた件数）・`replied`（既存コメントへ返信した件数）・`failed`（投稿コマンドがエラーになった指摘。`file`/`line`/`body` を持つJSON配列。無ければ空配列）・`summary`（投稿した指摘それぞれの1行要約の配列。例: `"src/auth.go:42 [must] nullチェック漏れでTypeErrorが発生する"`）を持つJSONオブジェクトで返すこと。指摘が無ければ `{"posted": 0, "replied": 0, "failed": [], "summary": []}` を返すこと
- **コードの変更やファイル作成は行わない**（読み取り専用の分析と、critへの投稿コマンド実行のみ許可される）
- 必要であれば `mcp__context7__*`（技術スタックの最新ドキュメント）や `mcp__aws-*`（AWS利用時）を使ってよいこと

| 観点 | subagent_type | 着眼点 |
| --- | --- | --- |
| 品質 | `code-reviewer` | コードの可読性、命名の適切さ／設計・責務分離（関数やクラスが大きすぎないか）／重複コードの有無／エラーハンドリングの適切さ／そのプロジェクトの既存コードとの一貫性 |
| セキュリティ | `security-auditor` | ユーザー入力のバリデーション・サニタイズ／認証・認可の漏れ／シークレットや機密情報のハードコード／依存ライブラリの既知の脆弱性／技術スタック特有のリスク（SQLインジェクション, XSS, CSRF, デシリアライズ脆弱性, パストラバーサル 等）（詳細基準は `~/.claude/skills/security-checklist/SKILL.md` をReadして参照） |
| パフォーマンス | `performance-engineer` | 不要なループやネスト、計算量の問題／I/O・ネットワーク呼び出しの効率性／キャッシュやメモ化の活用余地／メモリ使用量・リソースリーク／技術スタック特有の懸念（N+1クエリ, 不要な再レンダリング, GCプレッシャー 等） |
| テスト | `qa-expert` | 変更に対するテストが追加・更新されているか／エッジケースや異常系のカバー／テストの可読性と保守性／テストが実装の詳細に依存しすぎていないか |
| ドキュメント | `technical-writer` | 変更に伴いREADMEやAPIドキュメントの更新が必要か／複雑なロジックに対するコード内コメントの有無／型定義やインターフェースの変更がドキュメントに反映されているか |

各agentが投稿する際のコメント本文の形式:

````markdown
<コメント種別タグ>
**[重要度: 高/中/低] [緊急度: 高/中/低]** 問題の概要

**問題:**
具体的な問題の説明

**修正案:**
修正後のコード例
````

### コメント種別タグ

指摘事項の冒頭に付与するタグ。
レビュワーの意図をレビュイーに伝える目的で必ず付与する。

- `![question-badge](https://img.shields.io/badge/review-Question-yellowgreen.svg)` : 質問や疑問のコメントであることを示す
- `![imo-badge](https://img.shields.io/badge/review-In_My_Opinion-orange.svg)` : 個人的な意見や主張のコメントであることを示す
- `![fiy-badge](https://img.shields.io/badge/review-For_Your_Information-green.svg)` : 参考情報を提示するコメントであることを示す
- `![nitpick-badge](https://img.shields.io/badge/review-Nitpick-orange.svg)` : 重箱の隅をつつくような、細かい点の指摘コメントであることを示す
- `![norush-badge](https://img.shields.io/badge/review-No_Rush-purple.svg)` : 将来的には修正したいが、今でなくても良い内容のコメントであることを示す
- `![suggest-badge](https://img.shields.io/badge/review-Suggest_Change-yellowgreen.svg)` : **提案**  修正した方が良い内容の指摘コメントであることを示す
- `![should-badge](https://img.shields.io/badge/review-Should_Change-important.svg)` : **強い提案** 修正すべき内容の指摘コメントであることを示す
- `![must-badge](https://img.shields.io/badge/review-Must-red.svg)` : 修正しなければ approve しないという意思が篭っている指摘コメントであることを示す

### 重要度と緊急度

レビュイーが指摘点のトリアージの目安として利用する指標

#### 重要度

指摘点が、機能や処理の根幹に関わる問題(バグ、セキュリティリスク)であるほど重要である

#### 緊急度

指摘点が、アプリケーションの利用上支障となるような発生頻度、回避する操作が存在しない問題であるほど緊急である

### 各agentが実行する投稿コマンド

```bash
crit comment --session '<session>' --author 'review-pr' 'src/auth.go:42' "$(cat <<'EOF'
![must-badge](https://img.shields.io/badge/review-Must-red.svg)

**[重要度: 高] [緊急度: 高]** null チェック漏れ

**問題:** userがnullの場合にTypeErrorが発生する

**修正案:** 早期リターンでガード節を追加
EOF
)"
```

パスはgit toplevel相対（`gh pr diff` が出力するパスそのまま）で、範囲指定は `src/auth.go:40-45` の形式で渡す。

- **必ず `--author 'review-pr'` を付ける**（人間のコメントと区別するため）。GitHubへは本文だけが送られ、投稿者はpushしたユーザー本人になる。
- **行番号はPRのhead側（diffの `+` 側）の行番号で、diffに実際に現れる行を指すこと。** diffの範囲外の行はGitHubのレビューAPIで受け付けられない。
- ファイル全体への指摘（行番号なし）は使わない（GitHubのインラインコメントとして送信できないため）。最も関連する変更行に付ける。
- 投稿コマンドが失敗した場合（session未検出、権限エラー等）はリトライせず、その指摘を `failed` に積んで次の指摘に進む。

全agentの完了通知を待ってから、次のステップに進む。

## ステップ6: 全体像の作成・投稿

各agentが返した `summary`（投稿済み指摘の1行要約群）を俯瞰し、PRの全体像をメインエージェント自身が作成する：

````markdown
## コードレビュー: [PR タイトル]

### 📋 PRの概要

[このPRの目的と実装内容を2-3文で簡潔に説明]

### 🛠 技術スタック

[このPRで使われている主要な言語・フレームワーク・ライブラリ]

### このPRの背景知識として抑えておくべきコードの知識

[このPRを理解するために必要なコードの知識や背景情報]

### 人間が重点的にチェックする場所

- [人間がチェックすべきポイント1（ファイルのパスも含めて）]
- [人間がチェックすべきポイント2（ファイルのパスも含めて）]

### 分かりづらい箇所の解説

- [分かりづらい箇所1の説明(ファイルのパスも含めて)]
- [分かりづらい箇所2の説明(ファイルのパスも含めて)]

````

この全体像を、メインエージェント自身が `crit comment`（パス・行番号を付けない、**レビューコメント**）で投稿する。他のレビュワーのコメントも考慮に入れ、反論や意見がある場合はコメントすること。

```bash
crit comment --session '<session>' --author 'review-pr' "$(cat <<'EOF'
## コードレビュー: ...(上記の全体像Markdown全文)
EOF
)"
```

critのレビューコメントは `crit push` でGitHubに送信されない（インラインコメントのAPIに対応する形がないため）。全体像はcrit上で人間がレビューするためのガイドとして使う。

指摘が1件も無い場合（全agentの `posted` が0）も、全体像のレビューコメントは必ず投稿する。

チャットにも同じ全体像を出力する。個別の指摘（ステップ5で各agentが投稿済み）はチャットに列挙しない。

## ステップ7: 投稿に失敗した指摘のフォールバック

各agentの `failed` 配列を集約する。1件でもあれば、メインエージェントが代わりにステップ5と同じコメントフォーマット・タグ・`--author 'review-pr'` で `crit comment` を実行して投稿する。全て成功していれば（全agentの `failed` が空配列）このステップは何もしない。

## ステップ8: ユーザーにレビューを依頼する

投稿件数（ステップ5の各agentの `posted` 合計 + ステップ7のフォールバック分 + ステップ6の全体像1件）、既存コメントへの返信件数（各agentの `replied` 合計）とレビューURLをユーザーに伝える。

> "critにN件のコメント（全体像1件＋個別指摘N-1件）を追加し、既存コメントにM件返信しました（<url>）。不要な指摘はresolveしてください（resolveした指摘はGitHubに送信されません）。編集・追加が済んだら Finish Review を押してください。"

その後、ステップ4-2のバックグラウンドタスクの完了通知を待つ。出力ファイルをポーリングしない。

## ステップ9: GitHubへ送信する

critの `approved` は「未resolveのコメントが0件」という意味しか持たない。送信したい指摘を残すと常に `approved: false` になるため、`approved` の値では送信するかどうかを判断しない。Finish Review が押されたら、次の手順で送信する。

1. 送信内容をプレビューし、送信予定の件数と内容をユーザーに示す。

   ```bash
   crit push --session '<session>' --dry-run <PR>
   ```

2. AskUserQuestionで、送信方法をユーザーに選んでもらう。
   - `comment`
   - `approve`
   - `request-changes`
   - 送信しない

3. 「送信しない」以外を選んだ場合は、次のコマンドで送信する。

   ```bash
   crit push --session '<session>' -e <event> <PR>
   ```

   未resolveのコメントが0件で終えた場合、critのデーモンが停止していて `--session` でセッションが見つからないことがある。そのときは `--session` を外して再実行する。

4. 送信結果（送信件数とPRのURL）をユーザーに報告して完了する。
