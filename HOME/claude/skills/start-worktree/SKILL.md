---
name: start-worktree
description: >
  GitHub issue番号（またはURL）、またはClickUpタスクID（またはURL）を起点に、wtp（Worktree Plus）+ herdr の
  worktreeワークフローを開始します。issue/タスクの情報を取得し、命名規則に沿ったブランチ名で `wtp add` を実行して
  worktreeを作成すると、post_createフック経由でherdrワークスペースが自動的に開きます。
  ユーザーが「issue #123からworktree作って」「ClickUpタスク<ID>からworktree始めて」「start-worktree」
  「/start-worktree」と入力した場合に使用します。
argument-hint: "[GitHub issue番号/URL または ClickUpタスクID/URL] [任意: ベースブランチ]"
allowed-tools: Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git branch:*) Bash(wtp *) Bash(herdr *) Bash(jq:*) Bash(gh issue view:*) mcp__github__get_issue mcp__claude_ai_ClickUp__clickup_get_task
user-invocable: true
model: haiku
---

GitHub issue または ClickUp タスクを起点に、wtp + herdr のworktreeワークフロー（Obsidian vault `ClaudeCode/Knowledge/wtp-herdr-worktree-workflow`）を開始します。
このスキルの責務は **worktreeの作成とherdrワークスペースを開くところまで**。完了後は `implement-and-pr` スキルに引き継ぎ、実装プランの検討からPull Request作成までを担当してもらう。

## 前提条件の確認

1. リポジトリルートに `.wtp.yml` があり、`post_create` フックで `herdr worktree open` を呼ぶ設定になっているか確認する。
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

## ステップ5: 既存worktreeの確認

`wtp list` でステップ3のブランチ名に一致するworktreeが既に存在するか確認する。

- 存在する場合: 新規作成せず、既存worktreeのパスを使って `herdr worktree open --cwd <メインworktreeルート> --path <既存worktreeパス> --label <ブランチ名> --no-focus` を実行し、既存worktreeを再利用した旨を報告して終了する。
- 存在しない場合: ステップ6に進む。

## ステップ6: worktreeの作成

ベースブランチは基本的に `develop` を指定する。developブランチが存在しない場合はどのブランチを使用するかユーザに確認する。

```bash
wtp add -b <branch> <base>
```

`.wtp.yml` にherdr連携フックが設定されていれば、これだけでherdrワークスペースが自動的に開く。この標準出力に `post_create` フック内の `herdr worktree open` のJSONレスポンスが含まれる。

## ステップ7: herdr経由での実装フロー起動

worktreeの作成が完了したら、同一セッション内で `implement-and-pr` を呼ぶのではなく、herdrの新規ワークスペース内のペインでclaudeを新規起動し、そこに実装フローの開始を指示する。これにより、実装作業（ファイル編集・commit等）が確実にworktreeのディレクトリを起点に行われる（このセッション自身はcwdが元のリポジトリのままであり、cwdを移動する手段がないため）。

1. ステップ6の標準出力から `workspace_id` と `root_pane.pane_id` を取得する（`jq`で抽出できる場合はそれを使う。抽出できなければ `herdr workspace list` でステップ3のブランチ名と一致する `label` を探して `workspace_id` を特定し、`herdr pane list --workspace <workspace_id>` で `pane_id` を特定するフォールバックを使う）。
2. `herdr agent start <name> --kind claude --pane <pane_id>` で対象ペインにclaudeを起動する。`<name>` はブランチ名の `/` を `-` に置き換えたものを使う。
3. `herdr agent prompt <pane_id> "/implement-and-pr <issue/タスクのURL> <ブランチ名> <ベースブランチ>"` で実装フローの開始を指示する（issue/タスクのタイトル・本文は埋め込まず、URLのみ渡す。`implement-and-pr` 側でURLから再取得する）。`--wait` はタイムアウトすることがあるため付けない。

herdr未起動・フック未設定などでherdrワークスペースが開かなかった場合は、この手順は行わずステップ8の報告でその旨を伝えるにとどめる。

## ステップ8: 報告

以下をユーザーに報告する。

- 作成（または再利用）したworktreeのパスとブランチ名
- issue/タスクのタイトルとURL
- herdrワークスペースが開いたかどうか（フック未設定・herdr未起動などで開かなかった場合はその理由も伝える）
- ステップ7を実行した場合は、新規ペインでclaudeを起動し `implement-and-pr` の開始を指示した旨

## 境界

- ClickUpタスクのステータスやアサインの自動更新は行わない。
- `.wtp.yml` 自体の新規作成・herdr連携フックの追加は、前提条件の確認でユーザーの同意を得た場合のみ行う（無断で設定ファイルを書き換えない）。
- 実際のコード実装・コミット・push・PR作成はこのスキル自身では行わない。ステップ7でherdrの新規ペイン上のclaudeセッションに `implement-and-pr` の開始を指示するのみ。
- ステップ5で既存worktreeを再利用した場合はステップ7を行わない（既に作業中の可能性があるため、既存worktreeのherdrワークスペースを開いた報告のみで終了する）。
