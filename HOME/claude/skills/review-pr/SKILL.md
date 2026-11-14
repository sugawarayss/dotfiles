---
name: review-pr
description: プルリクエストのコードレビューを支援する。PRの品質・セキュリティ・パフォーマンス・テスト・ドキュメントの観点から分析し、構造化されたレビューコメントを生成する。技術スタック不問。
argument-hint: "[PR番号 or PRのURL（省略時はカレントブランチのPR）]"
allowed-tools: Agent, Bash(gh *), Bash(crit:*), AskUserQuestion, Read, Grep, Glob, mcp__context7__*, mcp__*
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

ステップ5で各専門subagentが既存コメントを読めるよう、分析より前にcritのPRレビューセッションを起動し、セッションID `<session>` を確保しておく。

### 4-1. critを仮起動し、既存コメントを取り込む

reviewファイルを作る前に、まず `--no-open` で仮起動する。Bashツールで `run_in_background: true` と `timeout: 86400000` を指定する。

```bash
crit --pr <PR> --no-open
```

`crit pr <PR>` は引数を1つしか受け付けず `--no-open` を渡せないため、同じ処理になる `crit --pr` を使う。

`crit status --json` の `sessions` が出るまで1〜2秒待って再確認し（最大5回）、対象PRのセッションIDを `<session>` として控える。続けて、**必ず** GitHub上の既存レビューコメントを取り込む。`crit --pr` だけではGitHub上のコメントはcritに表示されず、人間もsubagentも他のレビュワーのコメントを見られない。取り込んだコメントはGitHubのIDを持つため、ステップ8の push で重複投稿されることもない。

```bash
crit pull --session '<session>' <PR>
```

### 4-2. critを起動し直してPRフォーカスを記録させる

reviewファイルがまだ無いPRでは、`crit pull`（または `crit comment`）がreviewファイルを新規作成し、そのとき `active_diff_scope` を記録しない。サーバーは起動時にしか書き込まないため、そのまま進めるとPR上で付けたコメントがすべて full-stack-only 扱いになり、ステップ8の `crit push` で送信されない。サーバーを止めて起動し直すと、既存のreviewファイルに `layer` が記録される。

4-1のバックグラウンドタスクをTaskStopで止め、`crit stop` でサーバーを止めてから起動し直す（`run_in_background: true`、`timeout: 86400000`。ユーザーが Finish Review を押すまでブロックし、完了はステップ8で受け取る）。サーバーが動いたまま `crit --pr` を再実行しても既存のサーバーに接続するだけで、スコープは記録されない。

```bash
crit --pr <PR> --no-open
```

スコープが `layer` になったことを確認する（未反映なら1〜2秒待って再確認、最大5回）。`<session>` は4-1と同じ値のまま変わらない。

```bash
jq -r '.active_diff_scope // empty' "$(crit status --json | jq -r '.review_file')"
```

起動出力（バックグラウンドタスクの出力ファイル）からレビューURL（`http://localhost:<port>`）を取得する（ポートは4-1と変わる）。`ardia tabs open "<url>" --activate` でArdiaの前面タブに開く（失敗した場合はURLをユーザーに伝える）。

以降、この `<session>` をステップ5の各subagentに渡す。

## ステップ5: 専門subagentによる並列分析

Agentツールを使用し、以下5つの専門subagent_typeを**1回のメッセージで並列**に起動して観点ごとの分析を分担すること。それぞれ新規に起動される（会話コンテキストを持たない）ため、各agentのpromptには必ず次を含めること:

- レビュー対象PR番号 `<PR>` と、diff取得コマンド（`gh pr diff <PR>`、`gh pr diff <PR> --name-only`）
- ステップ3で把握した技術スタックと、そのスタック固有のベストプラクティス・落とし穴に注目してほしい旨
- 下表の担当観点とその着眼点
- コメントの読み手は、このコードベースや担当観点の専門知識に詳しくないジュニアエンジニアであること。専門用語（例: N+1、TOCTOU、XSS）は初出で1文の説明を添え、必要なら理解の助けになる参考リンク（公式ドキュメント等）を1つ付けること
- ステップ4で確保した **critのセッションID `<session>`**（複数のcritセッションがあると `--session` なしの `crit comments` は対象を決められずエラーになるため、必ず渡す）
- 分析の前に `crit comments --session '<session>' --json --all` で既存のレビューコメント（GitHubから取り込んだ他のレビュワーのコメント、resolve済み・返信を含む）を読み、次のとおり扱うこと
  - 既存コメントと同じ内容の指摘は新規に挙げない
  - 既存コメントへの同意・反論・補足は、返信として `comments` に入れる（返信も `crit push` でGitHubに送信される）
  - 作成者が回答済み・resolve済みのものは、その回答自体に新たな問題がある場合だけ返信する
- **critへの投稿（`crit comment`）は実行しない。** 指摘・返信はすべて下記の出力フォーマットで返し、ステップ6でメインエージェントがまとめて投稿する
- 出力フォーマット: `comments`（新規の指摘 `{"file": <path>, "line": <line または "start-end">, "body": <本文>}` と、既存コメントへの返信 `{"reply_to": <id>, "body": <本文>}` の配列）・`summary`（新規の指摘それぞれの1行要約の配列。例: `"src/auth.go:42 [must] nullチェック漏れでTypeErrorが発生する"`）を持つJSONオブジェクトで返すこと。指摘も返信も無ければ `{"comments": [], "summary": []}` を返すこと
- **コードの変更やファイル作成は行わない**（読み取り専用の分析のみ許可される）
- 必要であれば `mcp__context7__*`（技術スタックの最新ドキュメント）や `mcp__aws-*`（AWS利用時）を使ってよいこと

| 観点 | subagent_type | 着眼点 |
| --- | --- | --- |
| 品質 | `code-reviewer` | コードの可読性、命名の適切さ／設計・責務分離（関数やクラスが大きすぎないか）／重複コードの有無／エラーハンドリングの適切さ／そのプロジェクトの既存コードとの一貫性 |
| セキュリティ | `security-auditor` | ユーザー入力のバリデーション・サニタイズ／認証・認可の漏れ／シークレットや機密情報のハードコード／依存ライブラリの既知の脆弱性／技術スタック特有のリスク（SQLインジェクション, XSS, CSRF, デシリアライズ脆弱性, パストラバーサル 等）（詳細基準は `~/.claude/skills/security-checklist/SKILL.md` をReadして参照） |
| パフォーマンス | `performance-engineer` | 不要なループやネスト、計算量の問題／I/O・ネットワーク呼び出しの効率性／キャッシュやメモ化の活用余地／メモリ使用量・リソースリーク／技術スタック特有の懸念（N+1クエリ, 不要な再レンダリング, GCプレッシャー 等） |
| テスト | `qa-expert` | 変更に対するテストが追加・更新されているか／エッジケースや異常系のカバー／テストの可読性と保守性／テストが実装の詳細に依存しすぎていないか |
| ドキュメント | `technical-writer` | 変更に伴いREADMEやAPIドキュメントの更新が必要か／複雑なロジックに対するコード内コメントの有無／型定義やインターフェースの変更がドキュメントに反映されているか |

各agentが投稿する際のコメント本文の形式:

`````markdown
<コメント種別タグ> 【<対応区分>】問題の概要
**[重要度: 高/中/低] [緊急度: 高/中/低]**   ← must / should のときだけ書く

**何が問題か:**
どのコードが、どんな状態になるか

**なぜ問題か:**
どんな入力・操作で何が壊れるか（放置した場合の影響）

**修正案:**
```<言語>
修正後のコード
```

**補足:**（任意）専門用語の説明や参考リンク
`````

- 「なぜ問題か」は省略しない。ジュニアが修正の必要性を判断できる根拠になる。
- 修正案は文章だけで済ませず、コードで示す。`question` / `fyi` など修正を求めないコメントでは「修正案」を省略してよい。

### コメント種別タグと対応区分

指摘事項の冒頭に付与するタグ。
レビュワーの意図をレビュイーに伝える目的で必ず付与する。バッジは英語のため、直後に日本語の対応区分（【必須】【推奨】【任意】【質問】）を必ず併記し、対応が必要かどうかを1行目だけで判断できるようにする。

| バッジ | 対応区分 | 意味 |
| --- | --- | --- |
| `![must-badge](https://img.shields.io/badge/review-Must-red.svg)` | 【必須】 | 修正しなければ approve しない |
| `![should-badge](https://img.shields.io/badge/review-Should_Change-important.svg)` | 【推奨】 | **強い提案** 修正すべき |
| `![suggest-badge](https://img.shields.io/badge/review-Suggest_Change-yellowgreen.svg)` | 【推奨】 | **提案** 修正した方が良い |
| `![nitpick-badge](https://img.shields.io/badge/review-Nitpick-orange.svg)` | 【任意】 | 重箱の隅をつつくような細かい点 |
| `![imo-badge](https://img.shields.io/badge/review-In_My_Opinion-orange.svg)` | 【任意】 | 個人的な意見や主張 |
| `![norush-badge](https://img.shields.io/badge/review-No_Rush-purple.svg)` | 【任意】 | 将来的には修正したいが、今でなくても良い |
| `![fiy-badge](https://img.shields.io/badge/review-For_Your_Information-green.svg)` | 【任意】 | 参考情報の提示 |
| `![question-badge](https://img.shields.io/badge/review-Question-yellowgreen.svg)` | 【質問】 | 質問や疑問（回答を求める） |

### 重要度と緊急度

`must` / `should` の指摘にだけ付ける、レビュイーが修正の優先順位を決めるための指標。それ以外は対応区分だけで足りるため付けない（指標が多いと、どれから直すべきか判断しづらくなる）。

#### 重要度

指摘点が、機能や処理の根幹に関わる問題(バグ、セキュリティリスク)であるほど重要である

#### 緊急度

指摘点が、アプリケーションの利用上支障となるような発生頻度、回避する操作が存在しない問題であるほど緊急である

### 各agentが返す `comments` の要素

```json
{"file": "src/auth.ts", "line": 42, "body": "![must-badge](https://img.shields.io/badge/review-Must-red.svg) 【必須】null チェック漏れ\n**[重要度: 高] [緊急度: 高]**\n\n**何が問題か:** 未ログイン時は `getUser()` が `null` を返すが、42行目でそのまま `user.id` を参照している。\n\n**なぜ問題か:** ログインセッションが切れた状態でこの画面を開くと TypeError で500エラーになる。セッション切れは日常的に起きるため、多くのユーザーが踏む。\n\n**修正案:**\n```ts\nconst user = getUser()\nif (!user) return redirect('/login')\n```\n\n**補足:** このように関数の冒頭で異常系を先に return する書き方を「ガード節（早期リターン）」と呼ぶ。後続の処理で null を気にせずに済む。"}
```

- `file` はgit toplevel相対（`gh pr diff` が出力するパスそのまま）、範囲指定は `"line": "40-45"` の形式にする。
- **行番号はPRのhead側（diffの `+` 側）の行番号で、diffに実際に現れる行を指すこと。** diffの範囲外の行はGitHubのレビューAPIで受け付けられない。
- ファイル全体への指摘（行番号なし）は使わない（GitHubのインラインコメントとして送信できないため）。最も関連する変更行に付ける。

全agentの完了通知を待ってから、次のステップに進む。

## ステップ6: 全体像の作成とcritへの一括投稿

各agentが返した `summary`（指摘の1行要約群）を俯瞰し、PRの全体像をメインエージェント自身が作成する：

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

他のレビュワーのコメントも考慮に入れ、反論や意見がある場合は全体像に含めること。

全agentの `comments` と全体像を、次の手順で**1回のBash呼び出しで**critに投稿する。

1. 全agentの `comments` を1つのJSON配列にまとめ、末尾に全体像を `{"body": <全体像Markdown全文>, "scope": "review"}`（パス・行番号を付けない**レビューコメント**）として加える。
2. Writeツールでスクラッチパッドのファイルに書き出す。
3. 投稿する。`--author 'review-pr'` は人間のコメントと区別するため必ず付ける（GitHubへは本文だけが送られ、投稿者はpushしたユーザー本人になる）。

```bash
crit comment --session '<session>' --author 'review-pr' --json --file <スクラッチパッドのJSONファイル>
```

本文をBashのコマンド文字列（heredoc・引用符）に埋め込まない。数KBの複数heredocを含むBashコマンドで、Claude Code（2.1.319で確認）が実行前のコマンド解析中にCPU 100%のまま5〜30分固まる。ファイル経由ならBashコマンドは短いまま済む。

`--json` は全件を1回で書き込み、途中まで投稿された状態を残さない。エラーになった場合は、メッセージから原因の要素（diff範囲外の行番号など）を特定してファイルを直し、再実行する。

critのレビューコメントは `crit push` のインラインコメントとしては送信されない（インラインコメントのAPIに対応する形がないため）。全体像はcrit上で人間がレビューするためのガイドとして使い、ステップ8でレビュー本文（`--message`）としてGitHubに送る。

指摘が1件も無い場合（全agentの `comments` が空）も、全体像のレビューコメントは必ず投稿する。

チャットにも同じ全体像を出力する。個別の指摘（critに投稿済み）はチャットに列挙しない。

## ステップ7: ユーザーにレビューを依頼する

投稿件数（新規の指摘 = `file` を持つ要素の数 + 全体像1件）、既存コメントへの返信件数（`reply_to` を持つ要素の数）とレビューURLをユーザーに伝える。

> "critにN件のコメント（全体像1件＋個別指摘N-1件）を追加し、既存コメントにM件返信しました（<url>）。不要な指摘はresolveしてください（resolveした指摘はGitHubに送信されません）。編集・追加が済んだら Finish Review を押してください。"

その後、ステップ4-2のバックグラウンドタスクの完了通知を待つ。出力ファイルをポーリングしない。

## ステップ8: GitHubへ送信する

critの `approved` は「未resolveのコメントが0件」という意味しか持たない。送信したい指摘を残すと常に `approved: false` になるため、`approved` の値では送信するかどうかを判断しない。Finish Review が押されたら、次の手順で送信する。

0. reviewファイルがPRフォーカスのままか確認する。

   ```bash
   jq -r '.active_diff_scope // empty' "$(crit status --json | jq -r '.review_file')"
   ```

   `crit push` は `active_diff_scope` が空だと、PR上で付けたコメント（`diff_scope: "layer"`）をすべて full-stack-only 扱いにして送信しない。reviewファイルはcwd＋カレントブランチ単位で共有されるため、crit画面でWorking treeに切り替えたり、同じブランチで `--pr` なしのcritを起動したりすると空になる（ステップ4-2を飛ばした場合も空のまま）。空の場合は、`crit stop` でサーバーを止めてから `crit --pr <PR> --no-open` を `run_in_background: true` で起動し直す（サーバーが動いたままの再実行は既存のサーバーに接続するだけで、スコープは戻らない）。上のコマンドで `layer` に戻ったことを確認してから（未反映なら1〜2秒待って再確認、最大5回）次へ進む。このバックグラウンドタスクは手順3の送信が終わるまで止めない（止めるとサーバーも止まり、`crit push` がreviewファイルを見つけられなくなる）。送信後にTaskStopで止める。

1. 送信内容をプレビューし、送信予定の件数と内容をユーザーに示す。

   ```bash
   crit push --session '<session>' --dry-run <PR>
   ```

   dry-runの「Review-level (not pushable)」に並ぶレビューコメントは、手順3でレビュー本文として送る内容である旨もあわせて伝える。

2. AskUserQuestionで、送信方法をユーザーに選んでもらう。
   - `comment`
   - `approve`
   - `request-changes`
   - 送信しない

3. 「送信しない」以外を選んだ場合は、critの未resolveのレビューコメント（全体像や、ユーザーがcrit上で書いたレビューコメント）をそのままレビュー本文として `--message` に渡して送信する。`request-changes` は `--message` が無いと `--event request-changes requires --message` で失敗するため、どのeventでも必ず渡す。

   送信の直前に、GitHubへ送信済みの返信をreviewファイルから除く。`crit push` は送った返信に GitHub の ID を記録しないため、前回以前のラウンドで送った返信も毎回送り直してしまう（dry-runには返信が出ないので気づけない）。動いているサーバーがメモリの内容でreviewファイルを書き戻すことがあり、除いた返信が次のラウンドで復活する。そのため、除くのは毎回 push の直前に行う。GitHub 上の返信と「親スレッドの ID と本文」が一致するものだけを除くので、未送信の返信は残る。

   ```bash
   review_file="$(crit status --json | jq -r '.review_file')"
   sent="$(mktemp)"
   gh api 'repos/{owner}/{repo}/pulls/<PR>/comments' --paginate \
     | jq -s '[add[] | select(.in_reply_to_id != null) | {parent: .in_reply_to_id, body: (.body | gsub("\\s+$"; ""))}]' > "$sent"
   cp "$review_file" "$review_file.bak"
   jq --slurpfile sent "$sent" '
     .files[].comments[]? |= (
       if .github_id == null then . else
         .github_id as $p
         | .replies |= map(select(
             .github_id != null
             or ((.body | gsub("\\s+$"; "")) as $b | $sent[0] | any(.parent == $p and .body == $b) | not)))
       end)' "$review_file.bak" > "$review_file"
   # 送信される返信（親の GitHub ID と1行目）。ここに前回以前の返信が残っていないことを確かめてから push する
   jq -r '.files[].comments[]? | select(.github_id != null) | . as $c | .replies[]? | select(.github_id == null) | "\($c.github_id) \(.body | split("\n")[0])"' "$review_file"
   crit push --session '<session>' -e <event> \
     -m "$(jq -r '[.review_comments[] | select(.resolved != true) | .body] | join("\n\n---\n\n")' "$review_file")" <PR>
   ```

   未resolveのレビューコメントが0件で本文が空になる場合、`request-changes` では送信前に本文をユーザーに確認する。

   手順1の dry-run が `0 postable`（新規の行コメントが0件）だった場合、`crit push` は返信だけを送り、`-e` の event と `-m` の本文を送らずに終わる（エラーにもならない）。そのときは、push の後で event と本文を `gh pr review` で送る。本文はヒアドキュメントを通さずファイルから渡す（[[git_workflow]] の Tirith フック対策と同じ理由）。

   ```bash
   body_file="$(mktemp)"
   jq -r '[.review_comments[] | select(.resolved != true) | .body] | join("\n\n---\n\n")' "$review_file.bak" > "$body_file"
   gh pr review <PR> --approve --body-file "$body_file"   # comment は --comment、request-changes は --request-changes
   ```

   どちらの場合も、送信後に、本文のある最新のレビューが選んだ event の state（`APPROVED` / `COMMENTED` / `CHANGES_REQUESTED`）になっていることを確認する。返信は本文なしの別のレビュー（`COMMENTED`）として本体の後に作られるため、本文のないレビューは除いて見る。

   ```bash
   gh api 'repos/{owner}/{repo}/pulls/<PR>/reviews' --jq '[.[] | select(.body != "")] | .[-1] | {state, submitted_at, url: .html_url}'
   ```

   未resolveのコメントが0件で終えた場合、critのデーモンが停止していて `--session` でセッションが見つからないことがある。そのときは `--session` を外して再実行する。

4. 送信結果（送信件数とPRのURL）をユーザーに報告して完了する。
