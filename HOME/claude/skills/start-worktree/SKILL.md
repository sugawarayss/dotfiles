---
name: start-worktree
description: >
  GitHub issue番号（またはURL）、またはClickUpタスクID（またはURL）を起点に、gwm（git worktree manager）+ herdr の
  worktreeワークフローを開始します。issue/タスクの情報を取得し、GitHub issue起点は `gwm create --issue` に、
  ClickUpタスク起点は `gwm create --name` に委ねてworktreeを作成すると、`.gwm.toml`のpost_createフック経由で
  herdrワークスペースが自動的に開きます。
  ユーザーが「issue #123からworktree作って」「ClickUpタスク<ID>からworktree始めて」「start-worktree」
  「/start-worktree」と入力した場合に使用します。
argument-hint: "[GitHub issue番号/URL または ClickUpタスクID/URL] [任意: ベースブランチ]"
allowed-tools: Bash(git symbolic-ref:*) Bash(git rev-parse:*) Bash(git branch:*) Bash(git show-ref:*) Bash(git status:*) Bash(gwm *) Bash(herdr *) Bash(jq:*) Bash(gh issue view:*) Bash(/Users/sugawarayss/.claude/skills/start-worktree/scripts/gwm-herdr-start.sh *) mcp__github__get_issue mcp__claude_ai_ClickUp__clickup_get_task
user-invocable: true
model: haiku
---

GitHub issue または ClickUp タスクを起点に、gwm + herdr のworktreeワークフロー（Obsidian vault `ClaudeCode/Knowledge/gwm-usage-reference`）を開始します。
このスキルの責務は **worktreeの作成とherdrワークスペースを開くところまで**。完了後は `plan-and-review` スキルに引き継ぎ、実装プランの検討からPull Request作成までを担当してもらう。
`Agent(model="haiku")` でモデルを切り替えてから実施します。

## 前提条件の確認

1. `.gwm.toml`（リポジトリ側 or `~/.config/gwm/config.toml`）に`[[hooks.post_create]]`で`herdr worktree open`を呼ぶ設定になっているか確認する（`gwm config list` で解決済みの値を見るのが確実）。**`cat`/`head`/`tail`/`find` は権限で拒否されるため、内容確認には `Read` ツール（一覧確認には `fd`/`Glob`）を使う**。
   - 無い、またはherdr連携が設定されていない場合: その旨をユーザーに伝え、設定するかどうかを確認する。ユーザーが設定を望まない場合はworktree作成のみ行い、herdrワークスペースは開かれない旨を伝えて続行する。
2. `herdr status` で `server.status` が `running` か確認する。起動していなければ、ユーザーに `herdr` の起動を提案する（未起動のままでも `gwm create` 自体は失敗しないが、post_createフックのherdr連携コマンドが失敗する）。
3. **worktree作成のたびにmainリポジトリのチェックアウトを操作する副作用がある点を把握しておく**: `gwm create`にはbase ref引数が無く、常にmainリポジトリの現在のHEADから分岐する。そのためステップ7のスクリプトが、決定したbase branchへmainリポジトリを`fetch`+`checkout`+`ff-only merge`で同期させてから`gwm create`を呼ぶ。mainリポジトリのworking treeが汚れていると同期できずエラーになる（この設計はworktreeでの作業がmainリポジトリの外で完結する運用を前提にしている）。

## ステップ1: 入力の判別

`$ARGUMENTS` の1つ目のトークンを対象の識別に使う（2つ目以降があればベースブランチの明示指定として扱う。ただし後述の通りbaseはtypeから自動決定するため、明示指定は上級者向けの上書き用途）。

- 数字のみ、`#<数字>`、または `github.com/.../issues/<数字>` の形式 → GitHub issue
- ClickUpのタスクID形式（英数字混在、通常9文字前後）、または `app.clickup.com/t/<ID>` のURL → ClickUpタスク
- どちらとも判別できない場合はユーザーに確認する

## ステップ2: issue/タスク情報の取得

### GitHub issueの場合

`mcp__github__get_issue`（リポジトリのowner/repoは `git remote get-url origin` から推測、または `gh issue view <番号> --json number,title,body,url,labels` でも可）で以下を取得する。

- 番号、タイトル、本文、URL、ラベル

### ClickUpタスクの場合

`mcp__claude_ai_ClickUp__clickup_get_task` でタスクIDを指定し、以下を取得する。

- タスクID、タイトル(name)、説明、URL

## ステップ3: GitHub issueのtype選定（ClickUpタスクは対象外）

GitHub issue起点の場合のみ、gwmのbranch types（`feat` `fix` `hotfix` `docs` `test` `refactor` `chore` `perf` `ci` `build`）からissueのタイトル・本文・ラベルを見て1つ選ぶ。これは`gwm create --issue`がラベルから一意にtypeを推定できなかった場合の**フォールバック**として使われるだけで、必須の事前決定ではない（対象リポジトリの`.gwm.toml`に`[issue_template.by_type.*]`が定義されていれば、gwm側がラベルから自動で正しいtypeを選ぶ）。

ClickUpタスクの場合、slugをタイトルから生成する（現行ロジック）。

- 英語タイトルであれば小文字化し、英数字以外の連続を `-` に置き換える。
- 日本語や記号を含むタイトルは、直訳ではなく内容を要約した3〜6単語程度の英単語summaryに変換してからslug化する。
- 全体で50文字程度を目安に切り詰める。

## ステップ4: ベースブランチの決定

`$ARGUMENTS` の2つ目以降で明示指定があればそれを最優先する。無ければ以下のルールで決める（`main ← develop ← feat/fix/...` という構成を前提。`main`はdevelopからのマージのみで進み、例外はhotfix）。

- GitHub issueでtypeが`hotfix`: リポジトリのデフォルトブランチ（`git symbolic-ref refs/remotes/origin/HEAD --short`、通常`main`）
- それ以外（GitHub issueのhotfix以外の全type、ClickUpタスク全て）: `develop`

`develop`がローカルにもorigin配下にも存在しない場合、どのブランチを使用するかユーザーに確認する（`git show-ref --verify --quiet refs/remotes/origin/develop` / `refs/heads/develop` で存在確認できる）。

## ステップ5〜8: worktreeの作成/再利用 + base同期 + herdrワークスペース発見 + 新規作成時のclaude起動とプロンプト送信

base branchの同期・既存worktreeの確認・`gwm create`によるworktree作成・herdrワークスペースの特定・新規作成時のclaude起動とプロンプト送信を、`scripts/gwm-herdr-start.sh` に集約している（生のJSON出力を都度パースするとトークンを消費するため、この一連の手順は1回のBash呼び出しにまとめている）。同一セッション内で `plan-and-review` を呼ぶのではなく、herdrの新規ワークスペース内のペインでclaudeを新規起動し、そこに実装フローの開始を指示する。これにより、実装作業（ファイル編集・commit等）が確実にworktreeのディレクトリを起点に行われる（このセッション自身はcwdが元のリポジトリのままであり、cwdを移動する手段がないため）。

```bash
/Users/sugawarayss/.claude/skills/start-worktree/scripts/gwm-herdr-start.sh <source_type> <ref> <extra> <origin_pane_id> <agent_name> "<prompt>"
```

- `<source_type>`: `issue` または `task`。
- `<ref>`: GitHub issue番号、またはClickUpタスクID。
- `<extra>`: GitHub issueの場合はステップ3で選んだフォールバック用type、ClickUpタスクの場合はステップ3で生成したslug。
- `<origin_pane_id>`: 環境変数 `$HERDR_PANE_ID`（このセッション自身が動いているpane_id）の値。未設定（herdr管理下のpaneで実行されていない）なら `-` を渡す。スクリプトが、対象worktree専用のgit管理ディレクトリ（`git -C <worktree_path> rev-parse --git-dir`）配下に `gwm-herdr-origin-pane-id` というファイルとして記録する。これにより `plan-and-review` / `execute-plan-and-pr` のプロンプト文字列でこの値を手動中継する必要が無くなり、`cleanup-worktree` がブランチ名/worktree名から対象worktreeを特定した時点で自動的にこの値を読み出せる（`gwm remove` 時にgitがこのディレクトリごと削除するのでゴミも残らない）。最終的な後片付けでworktreeのherdr workspaceを閉じる際、そのworkspaceが実行中セッション自身のものだった場合にこの起点セッションへclose作業を委譲するために使われる（`herdr workspace close` は対象workspace配下の全terminalを閉じる実装のため、自分自身のworkspaceは自分では閉じられない）。
- `<agent_name>`: ブランチ名相当の識別子（issue系は`issue-<番号>`等、task系は`task-<ID>`等、分かりやすい形でよい）の `/` を `-` に置き換えたもの。herdrは名前を小文字英数字・`-`・`_`のみ、1〜32文字に制限しているが、**この切り詰めはスクリプト側（`gwm-herdr-start.sh`）が自動で行う**ため、呼び出し側で事前に短縮する必要はない。
- `<prompt>`: `"/plan-and-review <issue/タスクのURL> <worktree_nameまたはbranch> <ベースブランチ>"`（issue/タスクのタイトル・本文は埋め込まず、URLのみ渡す。`plan-and-review` 側でURLから再取得する。origin_pane_idは前述の通りファイル記録に一本化したため、ここには含めない）。

このスクリプトは以下を1回で行う（詳細は `scripts/gwm-herdr-start.sh --help` 相当のUsage出力を参照）。

1. base branchを決定し（`hotfix`ならデフォルトブランチ、それ以外は`develop`）、mainリポジトリのチェックアウトをそれへ同期する（working treeが汚れていれば中断してエラーを返す）。
2. `gwm list --format json` で既存worktreeの有無を確認する。存在すれば再利用（`status=reused`）、無ければ`gwm create`で新規作成する（`status=created`）。GitHub issue系はまずtype無しで`gwm create --issue`を試し、失敗した場合のみ`<extra>`のtypeを付けてリトライする。
3. `origin_pane_id` が `-` でなければ、対象worktreeのgit管理ディレクトリに `gwm-herdr-origin-pane-id` ファイルを書き込む（`origin_pane_id_recorded`）。
4. `.gwm.toml`の`[[hooks.post_create]]`が`gwm create`実行中に自動でherdrワークスペースを開くため、このスクリプト自身はherdrを開かず、`herdr workspace list`→`herdr pane list --workspace <id>`で既に開かれているworkspace/paneを発見する（`workspace_id` / `pane_id`）。
5. `status=created` の場合のみ、`pane_id` が取れていれば対象ペインでclaudeを起動し、プロンプトを送信する（`status=reused` の場合は行わない＝既存worktreeを再利用した場合は新規ペイン起動をスキップするという境界を、スクリプト側で担保している）。

標準出力は `status=` `worktree_path=` `worktree_name=` `origin_pane_id_recorded=` `herdr=` `workspace_id=` `pane_id=` `agent_started=` `prompt_sent=` の key=value 行（失敗時は `error=` 行）。この出力だけを読めば以降の報告に必要な情報が揃う。`gwm create` 自体が完全に失敗した場合はスクリプトが exit 1 で終了するので、エラー内容をそのままユーザーに伝える。`herdr=unavailable`かつ`error=`に`gwm bootstrap`を促す内容が出ている場合は、post_createフックの途中（例: mise setupなど別のフック）が失敗しherdr連携まで到達しなかった可能性がある旨も併せて伝える。

## ステップ9: 報告

以下をユーザーに報告する。

- 作成（または再利用）したworktreeのパスとworktree名/ブランチ名（スクリプトの `status` / `worktree_path` / `worktree_name`）
- issue/タスクのタイトルとURL
- herdrワークスペースが開いたかどうか（スクリプトの `herdr` が `unavailable` の場合はその理由も伝える）
- `status=created` かつ `agent_started=true` の場合は、新規ペインでclaudeを起動し `plan-and-review` の開始を指示した旨（`prompt_sent=false` の場合はプロンプト送信に失敗した旨も伝える）
- `origin_pane_id_recorded=false`（かつ元々`$HERDR_PANE_ID`が取得できていた場合）: 起点pane_idの記録に失敗した旨。後片付け時に自動検出できず、手動でのworkspace close対応が必要になりうる旨を添える

## 境界

- ClickUpタスクのステータスやアサインの自動更新は行わない。
- `.gwm.toml` 自体の新規作成・herdr連携フックの追加は、前提条件の確認でユーザーの同意を得た場合のみ行う（無断で設定ファイルを書き換えない）。
- 実際のコード実装・コミット・push・PR作成はこのスキル自身では行わない。`scripts/gwm-herdr-start.sh` がherdrの新規ペイン上のclaudeセッションに `plan-and-review` の開始を指示するのみ。
- 既存worktreeを再利用した場合（`status=reused`）は新規ペインでのclaude起動・プロンプト送信を行わない（既に作業中の可能性があるため）。この判定はスクリプト内部で担保している。
- mainリポジトリのチェックアウトをbase branchへ切り替える際、working treeが汚れていれば無断で`stash`等はせず中断してユーザーに確認する。
