---
name: cleanup-worktree
description: >
  ブランチ名を起点に、wtp（Worktree Plus）+ herdr の worktree 後片付けワークフローを実行します。
  `wtp remove --with-branch` で worktree とブランチを削除し、対応する herdr ワークスペースが
  あれば `herdr workspace close` で閉じます。
  ユーザーが「worktree片付けて」「<ブランチ名>のworktree消して」「cleanup-worktree」
  「/cleanup-worktree」と入力した場合に使用します。
argument-hint: "[削除対象のブランチ名] [起点pane_id(省略可、既定 -)]"
allowed-tools: Bash(git rev-parse:*) Bash(git branch:*) Bash(wtp *) Bash(herdr *) Bash(/Users/sugawarayss/.claude/skills/cleanup-worktree/scripts/wtp-herdr-cleanup-find.sh *) Bash(/Users/sugawarayss/.claude/skills/cleanup-worktree/scripts/wtp-herdr-cleanup-execute.sh *)
user-invocable: true
---

`wtp` + `herdr` のworktreeワークフローにおける後片付けを行います。`/start-worktree`スキル と対になるスキルで、責務は **worktreeとherdrワークスペースの削除・クローズのみ**。実装・コミット・PRのマージ確認・リモートブランチの削除は範囲外。

起点セッション（`/start-worktree` を実行した元セッション）のherdr pane_idは、`start-worktree` が対象worktree専用のgit管理ディレクトリにファイルとして記録したものをステップ2〜3で自動検出する。`plan-and-review`/`execute-plan-and-pr`からのプロンプト中継には依存しないため、そのskillチェーンを経由せず単独で `/cleanup-worktree <branch>` を呼んだ場合でも自動検出が働く。

## 前提条件の確認

`herdr status` で `server.status` が `running` か確認する。未起動の場合、herdr側のワークスペース片付けはスキップされる旨を伝え、wtp側の削除のみ続行してよいかユーザーに確認する（`wtp remove` 自体はherdrが無くても動く）。

## ステップ1: 対象ブランチの確認

`$ARGUMENTS` の1つ目のトークンを削除対象のブランチ名として扱う。指定が無い場合は現在のディレクトリを勝手に対象にせず、ユーザーにブランチ名を確認する。

`$ARGUMENTS` の2つ目のトークン（起点pane_id）は明示的な上書き用の任意引数。通常は不要（ステップ2〜3で自動検出される）で、ユーザーやskillが明示的に指定してきた場合のみ控えておき、ステップ5〜6でその値を優先する。

## ステップ2〜3: 対象worktreeとherdr workspaceの特定

worktreeの存在確認（`wtp list` 相当）とherdr workspaceの特定（`herdr workspace list` の走査・jqでの突き合わせ）を1回のBash呼び出しに集約している（生JSONを都度パースするとトークンを消費するため）。

```bash
/Users/sugawarayss/.claude/skills/cleanup-worktree/scripts/wtp-herdr-cleanup-find.sh <branch>
```

標準出力は `status=found|not_found` `worktree_path=` `origin_pane_id=` `herdr=ok|unavailable` `workspace_id=` `workspace_label=` のkey=value行。

- `status=not_found`: 該当するworktreeが見つからない旨を報告して終了する。
- `status=found` かつ `workspace_id` が出力されない場合: 対応するherdrワークスペースは無いものとして扱い、ステップ6はスキップする（herdr未起動時も同様）。
- `origin_pane_id`: `start-worktree` が対象worktree作成時に記録した起点pane_id（`wtp-herdr-origin-pane-id`ファイル）から自動検出された値。ステップ1で明示的な上書き引数が渡されていればそちらを優先し、無ければこの値を使う。どちらも無ければ `-` として扱う。

## ステップ4: 削除前の確認

以下をユーザーに提示し、実行してよいか確認を求める。実体を削除する不可逆操作のため、このステップは省略しない。

- worktreeのパス（`worktree_path`）
- ブランチ名
- 見つかった場合: herdr workspace_id とそのラベル（`workspace_id` / `workspace_label`）

## ステップ5〜6: `wtp remove --with-branch` の実行とherdr workspaceのクローズ

ユーザー確認後、実削除とherdr workspaceのクローズ（`workspace_id` が見つかっていれば）を1回のBash呼び出しに集約している。

```bash
/Users/sugawarayss/.claude/skills/cleanup-worktree/scripts/wtp-herdr-cleanup-execute.sh <branch> <workspace_id または -> <起点pane_id または ->
```

- `<workspace_id>`: ステップ2〜3で取得した値。見つかっていなければ `-` を渡す（herdr workspaceのクローズはスキップされる）。
- `<起点pane_id>`: ステップ1の明示的な上書き引数があればそれを、無ければステップ2〜3で自動検出された`origin_pane_id`を、どちらも無ければ `-` を渡す。
- 標準出力は `removed=true` `workspace_closed=true|false`（失敗時は `error=` 行を追加しexit 1）。

**実行中のシェルのcwdが削除対象worktree自身の中にある場合の扱い**（`cwd_blocks_remove=true` が出力される）: `wtp remove` は「カレントディレクトリが削除対象worktree内にある」場合、`workspace_id`が自分自身のworkspaceかどうかに関わらず必ず失敗する（`cannot remove worktree while you are currently inside it`）。スクリプトは`wtp remove`を試みる前にこれを検知し、`wtp remove --with-branch`とherdr workspaceのcloseの両方を1つの委譲メッセージにまとめて起点セッションに送る。

- `<起点pane_id>` が指定されていれば、`herdr agent prompt <起点pane_id> "..."` で「1) wtp remove --with-branch の実行 2) 成功したら herdr workspace close」をまとめて委譲する（`remove_delegated=true|false`）。fire-and-forgetのため、`=true`は「起点セッションに指示が届いた」ことのみを意味し、実際の削除・close完了までは保証しない。
- `<起点pane_id>` が `-`（無い）場合は、ユーザーに別ディレクトリへ移動してから手動で `wtp remove --with-branch <branch>` を実行してもらうよう報告するに留める。この場合`removed`はfalseのまま終了する（exit 1）。

**cwdは対象worktree外だが、削除対象のherdr workspaceが実行中セッション自身のものだった場合の扱い**（`wtp remove`自体は成功し、`workspace_self=true` が出力される）: `herdr worktree open` で開いたworktree用workspace内で `plan-and-review` → `execute-plan-and-pr` → `cleanup-worktree` が実行される設計上、最後に閉じるべきworkspaceは自分自身が動いているworkspaceであることが多い。`herdr workspace close` は対象workspace配下の全terminalを閉じる実装（herdrdev/herdr `src/app/actions.rs` の `close_selected_workspace` で確認済み）のため、自分自身に対して呼ぶと実行中のこのシェル自体が道連れに落ちてしまう。そのためスクリプトは自分自身のworkspaceは直接closeせず、以下のいずれかを行う。

- `<起点pane_id>` が指定されていれば、`herdr agent prompt <起点pane_id> "..."` でそのセッション（`/start-worktree` を実行した元セッション、自分自身とは別workspaceにいるため安全にcloseできる）にclose作業を委譲する（`workspace_close_delegated=true|false`）。委譲は `--wait` を付けない fire-and-forget で行うため、委譲が成功した（`=true`）ことは「起点セッションに指示が届いた」ことを意味し、実際にcloseが完了したことまでは保証しない。
- `<起点pane_id>` が `-`（無い）場合は、ユーザーに手動でこのペイン/ワークスペースを閉じてもらうよう報告するに留める。

失敗時の対応（**無断で強制フラグは付けない**）:

- dirty worktreeで失敗した場合: 未コミットの変更が残っている旨を伝え、`-f/--force` を付けて再実行してよいかユーザーに確認する。承認が得られたら `... <branch> <workspace_id> <起点pane_id> -f` のように末尾に追加して再実行する。
- 未マージブランチで拒否された場合: ブランチが未マージである旨を伝え、`--force-branch` を付けて再実行してよいかユーザーに確認する。承認後、同様に末尾に追加して再実行する。

`herdr worktree remove` は使わない（git worktreeの実体そのものを削除するコマンドであり、`wtp remove --with-branch` で既に実体を削除済みのため対象を失いエラーになる。スクリプトは常に `herdr workspace close` のみを使う）。

## ステップ7: 報告

以下をユーザーに報告する。

- `cwd_blocks_remove=true` の場合: worktree/ブランチの実削除自体がまだ完了していない旨をまず伝える。
  - `remove_delegated=true`: 起点セッションに「wtp remove + herdr workspace close」を委譲した旨（完了確認はできていない旨も添える）
  - `remove_delegated=false` または起点pane_idが無かった場合: ユーザーに別ディレクトリへ移動してから手動で `wtp remove --with-branch <branch>` を実行してもらう必要がある旨
- それ以外（`removed=true`）の場合:
  - 削除したworktreeのパスとブランチ名
  - herdrワークスペースを閉じたかどうか（`workspace_closed=false` の場合はその理由）
    - `workspace_self=true` かつ `workspace_close_delegated=true`: 起点セッションにcloseを委譲した旨（完了確認はできていない旨も添える）
    - `workspace_self=true` かつ `workspace_close_delegated=false` または起点pane_idが無かった場合: ユーザーに手動でこのペイン/ワークスペースを閉じてもらう必要がある旨
    - それ以外（herdr未起動 / 対応するワークスペースが無かった / クローズ自体が失敗、など）: その理由

## 境界

- worktree・ブランチの実体削除は `wtp remove --with-branch` にのみ任せる。`herdr worktree remove` は使わない。
- `-f` / `--force-branch` は無断で使わず、失敗時にユーザーへ確認してから使う。
- リモートブランチの削除、PRのクローズ・マージ確認は行わない。あくまでローカルのworktree・ブランチ・herdrワークスペースの片付けまで。
- 自分自身が動いているherdr workspaceは直接closeしない。起点pane_idがあれば委譲、無ければユーザーに手動close を依頼する。
