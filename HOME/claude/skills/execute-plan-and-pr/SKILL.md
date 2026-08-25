---
name: execute-plan-and-pr
description: >
  `plan-and-review` で承認された実装プランに従ってコード変更を実施し、変更内容を
  tuicrでレビューしてもらい、意味のある単位でcommitし、
  pushコマンドを提示したうえでPull Requestを作成し、
  ユーザーからPRがマージされた旨の報告を受けたら `cleanup-worktree` スキルで後片付けまで行います。
  `plan-and-review` でのプラン承認後に自動的に呼び出されるほか、
  既存のworktreeで承認済みのプランファイルがある状態で
  「実装を進めて」「execute-plan-and-pr」「/execute-plan-and-pr」と言われた場合にも使用します。
argument-hint: "[issue/タスクのURL] [ブランチ名] [ベースブランチ] [プランファイルのパス]"
allowed-tools: Agent Skill Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git add:*) Bash(git commit:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(gh pr create:*) Bash(gh pr view:*) Bash(gh repo view:*) Bash(tuicr:*) Bash(~/.claude/skills/tuicr/tuicr-wrapper-herdr.sh:*) Read
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

## ステップ2: 変更内容のレビュー（tuicr）

`tuicr` スキル（`tuicr review list/add` の作法）を前提とする。Herdr環境では `tuicr` スキル付属の `tuicr-wrapper-herdr.sh` を使い、ユーザーがtuicrを閉じる（`q`）までブロックして起動する。この設計はブロッキング起動を許容できる用途（ユーザーが見終えるまで待てばよい今回のレビューループ）に限る。同じくtuicrを使う `review-local` は「コメント投稿用にセッションを開いたまま裏でsubagent分析を進める」用途のためブロッキング起動と相性が悪く、非ブロッキングな自前起動ロジックを維持している。

1. `tuicr review list --repo <worktreeのパス>` でライブセッションの有無を確認する。`kind: "local"` で `anchor` が現在のブランチ、mode（sha部分の前）が `staged-and-unstaged` のセッションがあれば、それが今回のセッション。
2. Herdr環境かどうかを判定する。

   ```bash
   test "${HERDR_ENV:-}" = 1
   ```

   **Herdr環境の場合（終了コード0）**: ユーザーに確認や依頼をせず、以下を実行する。長時間ブロックしうるため、Bashのtimeoutは長め（600000ms）を指定する。

   ```bash
   ~/.claude/skills/tuicr/tuicr-wrapper-herdr.sh "<worktreeのパス>" -- -w
   ```

   このコマンドはユーザーがtuicrを `q` で閉じるまで戻ってこない。「コメントを付け終えたら教えてください」という手動の完了報告は不要（wrapperの終了自体が完了シグナルになる）。

   **Herdr環境でない場合**: ユーザーに `tuicr -w` をターミナルで起動し、レビューが終わったら教えてもらうよう依頼し、完了報告を待つ。
3. wrapperの終了（または完了報告）を受けたら、`tuicr review list --repo <path>` で対象セッションの `path`（セッションJSONファイルの絶対パス）を取得し、`Read` でその中身を読む。`review_comments`（ファイルに紐付かない全体コメント）と各ファイルの `files.<path>.line_comments`（行コメント）を走査し、`author` が `execute-plan-and-pr` ではないコメントを新規の人間コメントとして扱う。
4. 新規コメントが無ければ、「新規コメントはありませんでしたが、これで進めてよいですか？」とユーザーに確認する。承認が得られればステップ3(commit)へ進む。
5. 新規コメントがあれば、各コメントについて該当ファイルの該当行（行コメントなら `line_comments` のキーが行番号、全体コメントならファイル横断で確認）を確認しつつ対応するファイルを修正する。対応内容は同じ箇所に `tuicr review add --session '<slug>' --repo <path> --target-file <path> --line <line> --username 'execute-plan-and-pr' "対応: ..."` で短く記録する（tuicrには返信機能が無いため、新規コメントで代替する）。
6. 修正が終わったら、ステップ2に戻って再度tuicrを起動し、最新の差分をユーザーに確認してもらう。ステップ4でユーザーが承認するまで繰り返す。

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
