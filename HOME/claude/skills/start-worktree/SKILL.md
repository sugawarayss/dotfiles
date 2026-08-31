---
name: start-worktree
description: >
  GitHub issue番号（またはURL）、またはClickUpタスクID（またはURL）を起点に、wtp（Worktree Plus）+ herdr の
  worktreeワークフローを開始します。issue/タスクの情報を取得し、命名規則に沿ったブランチ名で `wtp add` を実行して
  worktreeを作成すると、post_createフック経由でherdrワークスペースが自動的に開きます。
  ユーザーが「issue #123からworktree作って」「ClickUpタスク<ID>からworktree始めて」「start-worktree」
  「/start-worktree」と入力した場合に使用します。
argument-hint: "[GitHub issue番号/URL または ClickUpタスクID/URL] [任意: ベースブランチ]"
allowed-tools: Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git branch:*) Bash(wtp *) Bash(herdr *) Bash(jq:*) Bash(gh issue view:*) Bash(/Users/sugawarayss/.claude/skills/start-worktree/scripts/wtp-herdr-start.sh *) mcp__github__get_issue mcp__claude_ai_ClickUp__clickup_get_task
user-invocable: true
model: haiku
---

GitHub issue または ClickUp タスクを起点に、wtp + herdr のworktreeワークフロー（Obsidian vault `ClaudeCode/Knowledge/wtp-herdr-worktree-workflow`）を開始します。
このスキルの責務は **worktreeの作成とherdrワークスペースを開くところまで**。完了後は `plan-and-review` スキルに引き継ぎ、実装プランの検討からPull Request作成までを担当してもらう。
`Agent(model="haiku")` でモデルを切り替えてから実施します。

## 前提条件の確認

1. リポジトリルートに `.wtp.yml` があり、`post_create` フックで `herdr worktree open` を呼ぶ設定になっているか確認する。**`cat`/`head`/`tail`/`find` は権限で拒否されるため、内容確認には `Read` ツール（一覧確認には `fd`/`Glob`）を使う**（`Bash(cat ...)` は毎回1回分の拒否往復を無駄にする）。
   - 無い、またはherdr連携が設定されていない場合: その旨をユーザーに伝え、`wtp-herdr-worktree-workflow` の「1. リポジトリでwtpを初期化」「2. post_createフックにherdr連携コマンドを追加」の手順で設定するかどうかを確認する。ユーザーが設定を望まない場合はworktree作成のみ行い、herdrワークスペースは開かれない旨を伝えて続行する。
2. `herdr status` で `server.status` が `running` か確認する。起動していなければ、ユーザーに `herdr` の起動を提案する（未起動のままでも `wtp add` 自体は失敗しないが、post_createフックのherdr連携コマンドが失敗する）。

## ステップ1: 入力の判別

`$ARGUMENTS` の1つ目のトークンを対象の識別に使う（2つ目以降があればベースブランチの明示指定として扱う）。

- 数字のみ、`#<数字>`、または `github.com/.../issues/<数字>` の形式 → GitHub issue
- ClickUpのタスクID形式（英数字混在、通常9文字前後）、または `app.clickup.com/t/<ID>` のURL → ClickUpタスク
- どちらとも判別できない場合はユーザーに確認する

## ステップ2: issue/タスク情報の取得

### GitHub issueの場合

`mcp__github__get_issue`（リポジトリのowner/repoは `git remote get-url origin` から推測、または `gh issue view <番号> --json number,title,body,url` でも可）で以下を取得する。

- 番号、タイトル、本文、URL

### ClickUpタスクの場合

`mcp__claude_ai_ClickUp__clickup_get_task` でタスクIDを指定し、以下を取得する。

- タスクID、タイトル(name)、説明、URL

## ステップ3: ブランチ名の決定

命名パターンは種別ごとに固定する。

- GitHub issue: `issue/<番号>-<slug>`（例: `issue/123-fix-login-bug`）
- ClickUpタスク: `task/<タスクID>-<slug>`（例: `task/86abcxyz-improve-checkout-flow`）

`<slug>` はタイトルから生成する。

- 英語タイトルであれば小文字化し、英数字以外の連続を `-` に置き換える。
- 日本語や記号を含むタイトルは、直訳ではなく内容を要約した3〜6単語程度の英単語summaryに変換してからslug化する。
- 全体で50文字程度を目安に切り詰める。

## ステップ4: ベースブランチの決定

1. `$ARGUMENTS` の2つ目以降でベースブランチが明示されていればそれを使う。
2. 指定が無ければ `git symbolic-ref refs/remotes/origin/HEAD --short` でリモートのデフォルトブランチを検出する。
3. 検出できない場合はユーザーに確認する。

## ステップ5〜7: worktreeの作成/再利用 + herdrワークスペース起動 + 実装フロー開始

既存worktreeの確認・`wtp add`によるworktree作成・herdrワークスペースの特定・新規作成時のclaude起動とプロンプト送信を、`scripts/wtp-herdr-start.sh` に集約している（生のJSON出力を都度パースするとトークンを消費するため、この一連の手順は1回のBash呼び出しにまとめている）。同一セッション内で `plan-and-review` を呼ぶのではなく、herdrの新規ワークスペース内のペインでclaudeを新規起動し、そこに実装フローの開始を指示する。これにより、実装作業（ファイル編集・commit等）が確実にworktreeのディレクトリを起点に行われる（このセッション自身はcwdが元のリポジトリのままであり、cwdを移動する手段がないため）。

ベースブランチは基本的に `develop` を指定する。developブランチが存在しない場合はどのブランチを使用するかユーザに確認する。

```bash
/Users/sugawarayss/.claude/skills/start-worktree/scripts/wtp-herdr-start.sh <branch> <base> <origin_pane_id> <agent_name> "<prompt>"
```

- `<branch>` / `<base>`: ステップ3・4で決定したブランチ名とベースブランチ。
- `<origin_pane_id>`: 環境変数 `$HERDR_PANE_ID`（このセッション自身が動いているpane_id）の値。未設定（herdr管理下のpaneで実行されていない）なら `-` を渡す。スクリプトが、対象worktree専用のgit管理ディレクトリ（`git -C <worktree_path> rev-parse --git-dir`）配下に `wtp-herdr-origin-pane-id` というファイルとして記録する。これにより `plan-and-review` / `execute-plan-and-pr` のプロンプト文字列でこの値を手動中継する必要が無くなり、`cleanup-worktree` がブランチ名から対象worktreeを特定した時点で自動的にこの値を読み出せる（`wtp remove` 時にgitがこのディレクトリごと削除するのでゴミも残らない）。最終的な後片付けでworktreeのherdr workspaceを閉じる際、そのworkspaceが実行中セッション自身のものだった場合にこの起点セッションへclose作業を委譲するために使われる（`herdr workspace close` は対象workspace配下の全terminalを閉じる実装のため、自分自身のworkspaceは自分では閉じられない）。
- `<agent_name>`: ブランチ名の `/` を `-` に置き換えたもの。herdrは名前を小文字英数字・`-`・`_`のみ、1〜32文字に制限しているが、issue番号+要約slugのブランチ名は容易に32文字を超える。**この切り詰めはスクリプト側（`wtp-herdr-start.sh`）が自動で行う**ため、呼び出し側で事前に短縮する必要はない（旧版では呼び出し側任せだったため `invalid_agent_name` エラーで毎回手動リトライが発生していた）。
- `<prompt>`: `"/plan-and-review <issue/タスクのURL> <ブランチ名> <ベースブランチ>"`（issue/タスクのタイトル・本文は埋め込まず、URLのみ渡す。`plan-and-review` 側でURLから再取得する。origin_pane_idは前述の通りファイル記録に一本化したため、ここには含めない）。

このスクリプトは以下を1回で行う（詳細は `scripts/wtp-herdr-start.sh --help` 相当のUsage出力を参照）。

1. `wtp cd <branch>` で既存worktreeの有無を確認する。存在すれば再利用（`status=reused`）、無ければ `wtp add -b <branch> <base>` で新規作成する（`status=created`）。
2. `origin_pane_id` が `-` でなければ、対象worktreeのgit管理ディレクトリに `wtp-herdr-origin-pane-id` ファイルを書き込む（`origin_pane_id_recorded`）。
3. herdrが起動していれば `herdr worktree open` でワークスペースを開き（既存の場合も冪等に動作する）、`workspace_id` / `pane_id` を出力する。
4. `status=created` の場合のみ、`pane_id` が取れていれば対象ペインでclaudeを起動し、プロンプトを送信する（`status=reused` の場合は行わない＝既存worktreeを再利用した場合は新規ペイン起動をスキップするという境界を、スクリプト側で担保している）。

標準出力は `status=` `worktree_path=` `origin_pane_id_recorded=` `herdr=` `workspace_id=` `pane_id=` `agent_started=` `prompt_sent=` の key=value 行（失敗時は `error=` 行）。この出力だけを読めば以降の報告に必要な情報が揃う。`wtp add` 自体が失敗した場合はスクリプトが exit 1 で終了するので、エラー内容をそのままユーザーに伝える。

## ステップ8: 報告

以下をユーザーに報告する。

- 作成（または再利用）したworktreeのパスとブランチ名（スクリプトの `status` / `worktree_path`）
- issue/タスクのタイトルとURL
- herdrワークスペースが開いたかどうか（スクリプトの `herdr` が `unavailable`/`error` の場合はその理由も伝える）
- `status=created` かつ `agent_started=true` の場合は、新規ペインでclaudeを起動し `plan-and-review` の開始を指示した旨（`prompt_sent=false` の場合はプロンプト送信に失敗した旨も伝える）
- `origin_pane_id_recorded=false`（かつ元々`$HERDR_PANE_ID`が取得できていた場合）: 起点pane_idの記録に失敗した旨。後片付け時に自動検出できず、手動でのworkspace close対応が必要になりうる旨を添える

## 境界

- ClickUpタスクのステータスやアサインの自動更新は行わない。
- `.wtp.yml` 自体の新規作成・herdr連携フックの追加は、前提条件の確認でユーザーの同意を得た場合のみ行う（無断で設定ファイルを書き換えない）。
- 実際のコード実装・コミット・push・PR作成はこのスキル自身では行わない。`scripts/wtp-herdr-start.sh` がherdrの新規ペイン上のclaudeセッションに `plan-and-review` の開始を指示するのみ。
- 既存worktreeを再利用した場合（`status=reused`）は新規ペインでのclaude起動・プロンプト送信を行わない（既に作業中の可能性があるため）。この判定はスクリプト内部で担保している。
