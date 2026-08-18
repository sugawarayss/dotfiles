---
name: cleanup-worktree
description: >
  ブランチ名を起点に、wtp（Worktree Plus）+ herdr の worktree 後片付けワークフローを実行します。
  `wtp remove --with-branch` で worktree とブランチを削除し、対応する herdr ワークスペースが
  あれば `herdr workspace close` で閉じます。
  ユーザーが「worktree片付けて」「<ブランチ名>のworktree消して」「cleanup-worktree」
  「/cleanup-worktree」と入力した場合に使用します。
argument-hint: "[削除対象のブランチ名]"
allowed-tools: Bash(git rev-parse:*) Bash(git branch:*) Bash(wtp *) Bash(herdr *)
user-invocable: true
---

`wtp` + `herdr` のworktreeワークフローにおける後片付けを行います。`/start-worktree`スキル と対になるスキルで、責務は **worktreeとherdrワークスペースの削除・クローズのみ**。実装・コミット・PRのマージ確認・リモートブランチの削除は範囲外。

## 前提条件の確認

`herdr status` で `server.status` が `running` か確認する。未起動の場合、herdr側のワークスペース片付けはスキップされる旨を伝え、wtp側の削除のみ続行してよいかユーザーに確認する（`wtp remove` 自体はherdrが無くても動く）。

## ステップ1: 対象ブランチの確認

`$ARGUMENTS` の1つ目のトークンを削除対象のブランチ名として扱う。指定が無い場合は現在のディレクトリを勝手に対象にせず、ユーザーにブランチ名を確認する。

## ステップ2: 対象worktreeの特定

`wtp list` を実行し、対象ブランチに一致するworktreeが存在するか確認する。

- 存在しない場合: 該当するworktreeが見つからない旨を報告して終了する。
- 存在する場合: そのworktreeのパスを控え、ステップ3に進む。

リポジトリルートは `git rev-parse --path-format=absolute --git-common-dir` の親ディレクトリで取得する。

## ステップ3: herdr workspaceの特定

`herdr workspace list` を実行する。出力はJSON（`result.workspaces` が配列）で、各要素の `worktree.repo_root` がステップ2で取得したリポジトリルートと一致し、かつ `label`（またはworktree.checkout_path）が対象worktreeと一致するものを探し、`workspace_id` を控える。

- 一致するものが無い場合、またはherdrが未起動の場合: 対応するherdrワークスペースは無いものとして扱い、ステップ6はスキップする。

**注意**: `herdr worktree list --cwd <path>` の出力には `workspace_id` が含まれない。workspace_idの取得には必ず `herdr workspace list` を使うこと。

## ステップ4: 削除前の確認

以下をユーザーに提示し、実行してよいか確認を求める。実体を削除する不可逆操作のため、このステップは省略しない。

- worktreeのパス
- ブランチ名
- 見つかった場合: herdr workspace_id とそのラベル

## ステップ5: `wtp remove --with-branch <branch>` の実行

```bash
wtp remove --with-branch <branch>
```

- 成功した場合: ステップ6に進む。
- dirty worktreeで失敗した場合: 未コミットの変更が残っている旨を伝え、`-f/--force` を付けて再実行してよいかユーザーに確認する。無断で `-f` は付けない。
- 未マージブランチで拒否された場合: ブランチが未マージである旨を伝え、`--force-branch` を付けて再実行してよいかユーザーに確認する。無断で `--force-branch` は付けない。

## ステップ6: herdr workspaceのクローズ

ステップ3で `workspace_id` が見つかっていれば実行する。

```bash
herdr workspace close <workspace_id>
```

見つかっていなければ何もしない。`herdr worktree remove` は使わない（git worktreeの実体そのものを削除するコマンドであり、ステップ5で既に実体を削除済みのため対象を失いエラーになる）。

## ステップ7: 報告

以下をユーザーに報告する。

- 削除したworktreeのパスとブランチ名
- herdrワークスペースを閉じたかどうか（閉じなかった場合はその理由 = herdr未起動 / 対応するワークスペースが無かった、など）

## 境界

- worktree・ブランチの実体削除は `wtp remove --with-branch` にのみ任せる。`herdr worktree remove` は使わない。
- `-f` / `--force-branch` は無断で使わず、失敗時にユーザーへ確認してから使う。
- リモートブランチの削除、PRのクローズ・マージ確認は行わない。あくまでローカルのworktree・ブランチ・herdrワークスペースの片付けまで。
