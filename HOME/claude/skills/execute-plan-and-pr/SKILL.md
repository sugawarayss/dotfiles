---
name: execute-plan-and-pr
description: >
  `plan-and-review` で承認された実装プランに従ってコード変更を実施し、変更内容を
  Hunk（`hunk-review` スキル）でレビューしてもらい、意味のある単位でcommitし、
  pushコマンドを提示したうえでPull Requestを作成し、
  ユーザーからPRがマージされた旨の報告を受けたら `cleanup-worktree` スキルで後片付けまで行います。
  `plan-and-review` でのプラン承認後に自動的に呼び出されるほか、
  既存のworktreeで承認済みのプランファイルがある状態で
  「実装を進めて」「execute-plan-and-pr」「/execute-plan-and-pr」と言われた場合にも使用します。
argument-hint: "[issue/タスクのURL] [ブランチ名] [ベースブランチ] [プランファイルのパス]"
allowed-tools: Agent Skill Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git add:*) Bash(git commit:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(gh pr create:*) Bash(gh pr view:*) Bash(gh repo view:*) Bash(hunk session:*) Bash(herdr:*)
user-invocable: true
model: sonnet
---

`plan-and-review` で承認された実装プランを引き継ぎ、実装からPull Request作成・後片付けの呼び出しまでを行います。`plan-and-review` と対になるスキルで、Plan Mode承認後に呼び出される想定ですが、承認済みプランファイルが既にある状態で単独に呼び出してもかまいません。

このスキルの責務は **実装 → レビュー → commit → push案内 → PR作成 → （マージ報告を受けての）後片付けの呼び出し** まで。実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは扱わない。実装作業はコード変更の適用が中心のため、このスキルは `model: sonnet` で動作する。
`Agent(model="sonnet")` でモデルを切り替えてから実施します。

## 前提条件の確認

1. `git branch --show-current` で現在のブランチを確認する。`$ARGUMENTS` でブランチ名が渡されていて一致しない場合は、対象のworktree/ブランチに切り替わっているかユーザーに確認する。
2. `$ARGUMENTS` からプランファイルのパスが得られているか確認する。得られていなければユーザーに確認する。
3. プランファイルを読み、承認された実装方針を把握する。

## ステップ1: 実装

承認されたプランに従ってコード変更を実施する。プランに無い大きな方針転換が必要になった場合は、その場で実装を進めず、ユーザーに確認する。

## ステップ2: 変更内容のレビュー（Hunk）

1. 実装が一区切りついたら、`Skill` ツールで `hunk-review` を呼び出し、その手順に従う。
2. `hunk session list --repo <worktreeのパス>` でライブセッションの有無を確認する。セッションがあればステップ3に進む。無ければ以下で起動する（`hunk diff` 自体はTUIのため、エージェントが直接実行してはいけない）。

   ```bash
   test "${HERDR_ENV:-}" = 1
   ```

   **Herdr環境の場合（終了コード0）**: ユーザーに確認や依頼をせず、右側に新規ペインを割いて自動的に起動する。

   ```bash
   herdr pane split --current --direction right --cwd "<worktreeのパス>" --no-focus
   # → .result.pane.pane_id を取得
   herdr pane run <pane_id> "hunk diff"
   ```

   セッションの永続化には少し時間がかかることがある。`hunk session list --repo <path>` が対象セッションを返さない間は1〜2秒待って再試行する（最大5回程度）。5回試しても現れない場合はエラーとしてユーザーに報告し中断する。

   **Herdr環境でない場合**: ユーザーに `hunk diff` をターミナルで起動してもらうよう依頼し、起動完了の報告を待ってから次に進む。
3. `hunk session reload --repo <path> -- diff` で作業ツリーの差分を最新状態に反映する。
4. ユーザーに「Hunkでインラインコメントを付け終えたら教えてください」と伝える。crit と異なりHunkにはブロッキングで完了を待つ仕組みが無いため、ユーザーからの完了報告を待つ。Herdr環境で自動的にペインを開いた場合は、そのペインで確認できる旨も伝える。
5. 完了報告を受けたら `hunk session comment list --repo <path> --type user --json` で人間が付けたコメントを取得する。
6. 各コメントについて、`hunk session navigate` で該当箇所を確認しつつ対応するファイルを修正する。対応内容は同じ箇所に `hunk session comment add` で短く記録する（crit の `--reply-to` に相当する返信機能はHunkに無いため、新規コメントで代替する）。
7. 修正が終わったら `hunk session reload --repo <path> -- diff` で差分を更新し、再度ステップ4に戻ってユーザーにレビューを依頼する。
8. ユーザーが明示的に承認する（コメントを追加せず「OK」「これで進めて」等と発言する）までステップ4〜7を繰り返す。

## ステップ3: commit

意味のある単位で複数のcommitに分ける。1つのcommitが1つの目的（1つの論理的な変更）に対応するようにし、無関係な変更を1つのcommitにまとめない。コミットメッセージは「なぜ」を中心に簡潔に書く。

## ステップ4: push

`git push` は権限設定上Bashから直接実行できないため、以下の形式でコマンドを提示し、ユーザー自身に `! <command>` で実行してもらう。

```
git push -u origin <branch>
```

ユーザーがpushを完了したことを確認してからステップ5に進む。

## ステップ5: Pull Requestの作成

1. PRのタイトル・本文（概要・テスト計画）を作成し、ベースブランチとともにユーザーに提示して確認を求める。実行前確認は必須のステップとして省略しない。
2. 承認後、以下の形式で実行する。

```bash
gh pr create --base <base-branch> --title "<title>" --body "<body>"
```

1. 作成されたPRのURLをユーザーに報告する。

## ステップ6: マージ後の後片付け

PR作成の報告後、同じ会話の中でユーザーから「マージされた」「PRがマージされたよ」などPRのマージを知らせる発言があったら、`Skill` ツールで `cleanup-worktree` スキルを呼び出す。引数には対象のブランチ名（ステップ5でPRを作成したブランチ）を渡す。

worktree・ブランチの実削除前の確認は `cleanup-worktree` 側のステップ4で行われるため、ここで重ねて確認を取る必要はない。

## 境界

- PRのマージ自体（`gh pr merge` 等）はこのスキルでは実行しない。マージされたかどうかはユーザーからの報告のみで判断し、能動的にCIやマージ状態を確認しにいくことはしない。
- `git push --force` やコミット履歴の書き換え（rebase, amendなど）は行わない。
- 実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは行わない。
- worktree自体の作成・削除、herdrワークスペースの管理は `start-worktree` / `cleanup-worktree` スキルの責務であり、実際の削除処理はステップ6で `cleanup-worktree` に委譲する。
