---
name: start-worktree
description: >
  GitHub issue番号（またはURL）、またはClickUpタスクID（またはURL）を起点に、wtp（Worktree Plus）+ herdr の
  worktreeワークフローを開始します。issue/タスクの情報を取得し、命名規則に沿ったブランチ名で `wtp add` を実行して
  worktreeを作成すると、post_createフック経由でherdrワークスペースが自動的に開きます。
  ユーザーが「issue #123からworktree作って」「ClickUpタスク<ID>からworktree始めて」「start-worktree」
  「/start-worktree」と入力した場合に使用します。
argument-hint: "[GitHub issue番号/URL または ClickUpタスクID/URL] [任意: ベースブランチ]"
allowed-tools: Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git branch:*) Bash(wtp *) Bash(herdr *) Bash(gh issue view:*) mcp__github__get_issue mcp__claude_ai_ClickUp__clickup_get_task
user-invocable: true
---

GitHub issue または ClickUp タスクを起点に、wtp + herdr のworktreeワークフロー（[[wtp-herdr-worktree-workflow]]、Obsidian vault `ClaudeCode/Knowledge/`）を開始します。
このスキルの責務は **worktreeの作成とherdrワークスペースを開くところまで**。実装・コミット・PR作成は範囲外。

## 前提条件の確認

1. リポジトリルートに `.wtp.yml` があり、`post_create` フックで `herdr worktree open` を呼ぶ設定になっているか確認する。
   - 無い、またはherdr連携が設定されていない場合: その旨をユーザーに伝え、[[wtp-herdr-worktree-workflow]] の「1. リポジトリでwtpを初期化」「2. post_createフックにherdr連携コマンドを追加」の手順で設定するかどうかを確認する。ユーザーが設定を望まない場合はworktree作成のみ行い、herdrワークスペースは開かれない旨を伝えて続行する。
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

```bash
wtp add -b <branch> <base>
```

`.wtp.yml` にherdr連携フックが設定されていれば、これだけでherdrワークスペースが自動的に開く。

## ステップ7: 報告

以下をユーザーに報告する。

- 作成（または再利用）したworktreeのパスとブランチ名
- issue/タスクのタイトルとURL
- herdrワークスペースが開いたかどうか（フック未設定・herdr未起動などで開かなかった場合はその理由も伝える）

## 境界

- ClickUpタスクのステータスやアサインの自動更新は行わない。
- `.wtp.yml` 自体の新規作成・herdr連携フックの追加は、前提条件の確認でユーザーの同意を得た場合のみ行う（無断で設定ファイルを書き換えない）。
- 実際のコード実装・コミット・push・PR作成はこのスキルの範囲外。worktreeとherdrワークスペースを用意するところまでで完了とする。
