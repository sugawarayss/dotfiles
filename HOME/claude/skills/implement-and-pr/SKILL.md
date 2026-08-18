---
name: implement-and-pr
description: >
  worktree内でissue/タスクの実装プランを検討し、Plan Modeのcrit連携（ExitPlanMode時に
  自動起動する crit plan-hook）でユーザーレビューを受けたうえで実装し、変更内容を
  crit（branch diffモード）で再度レビューしてもらい、意味のある単位でcommitし、
  pushコマンドを提示したうえでPull Requestを作成し、
  ユーザーからPRがマージされた旨の報告を受けたら `cleanup-worktree` スキルで後片付けまで行います。
  `/start-worktree` からworktree作成後に自動的に呼び出されるほか、
  既存のworktree内で「実装してPRまで作って」「このissueの実装を進めて」
  「implement-and-pr」「/implement-and-pr」と言われた場合にも使用します。
argument-hint: "[issue/タスクのURL] [ブランチ名] [ベースブランチ]"
allowed-tools: Agent Skill EnterPlanMode ExitPlanMode Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git add:*) Bash(git commit:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(gh issue view:*) Bash(gh pr create:*) Bash(gh pr view:*) Bash(gh repo view:*) mcp__github__get_issue mcp__claude_ai_ClickUp__clickup_get_task
user-invocable: true
---

worktree内でissue/タスクの実装からPull Request作成までを行います。`start-worktree` スキルと対になるスキルで、worktree作成後に引き継がれる想定ですが、既存のworktreeで単独に呼び出してもかまいません。

このスキルの責務は **実装プランの検討 → レビュー → 実装 → レビュー → commit → push案内 → PR作成 → （マージ報告を受けての）後片付けの呼び出し** まで。worktree自体の作成・herdrワークスペースのオープンは `start-worktree` スキルの責務であり、ここでは扱わない。

## 前提条件の確認

1. `git branch --show-current` で現在のブランチを確認する。`$ARGUMENTS` でブランチ名が渡されていて一致しない場合は、対象のworktree/ブランチに切り替わっているかユーザーに確認する。
2. issue/タスクのURLおよびベースブランチが `$ARGUMENTS` から得られているか確認する。得られていなければユーザーに確認する。
3. URLの形式からGitHub issueかClickUpタスクかを判別し、タイトル・本文を取得する。
   - GitHub issue（`github.com/.../issues/<番号>`）: `gh issue view <番号> --json title,body,url` または `mcp__github__get_issue`
   - ClickUpタスク（`app.clickup.com/t/<ID>`）: `mcp__claude_ai_ClickUp__clickup_get_task`

## ステップ1: 実装プランの検討とレビュー（Plan Mode + crit）

1. `EnterPlanMode` でPlan Modeに入る。
2. issue/タスクの内容を踏まえて実装方針を検討する。調査の深さ（コードベース探索にAgent(Explore)を使うか、設計にAgent(Plan)を使うか、直接考えるか）は課題の規模に応じて判断する。単純な修正であれば直接プランを書き、複数ファイルにまたがる・要件があいまいなど複雑な課題であれば探索・設計のエージェントを使う。
3. 実装方針が固まったらプランファイルに書く。
4. `ExitPlanMode` を呼ぶ。crit プラグインの `hooks.json` により `ExitPlanMode` には `crit plan-hook` が自動的にフックされており、ブラウザでのinlineレビューが開始される。
5. レビューでコメントが付いた場合: 各コメントの内容に沿ってプランファイルを修正し、返信する（`crit-cli` スキルの運用に準ずる。`--resolve` は付けず、解決はレビューアーの判断に委ねる）。修正が終わったら再度 `ExitPlanMode` を呼び、次のレビューラウンドに入る。
6. ユーザーがコメント無しで承認するまで手順4〜5を繰り返す。承認されたらPlan Modeを抜けてステップ2に進む。

## ステップ2: 実装

承認されたプランに従ってコード変更を実施する。プランに無い大きな方針転換が必要になった場合は、その場で実装を進めず、ユーザーに確認する。

## ステップ3: 変更内容のレビュー（crit）

1. 実装が一区切りついたら、`Skill` ツールで `crit:crit` を引数なしで呼び出す（bare `crit` = ブランチdiffモード）。
2. crit skillのStep2〜5の手順（バックグラウンドで起動してブロック、stdoutのコメントを読む、各コメントに対応してファイルを修正、`crit comment --reply-to` で返信、再度 `crit:crit` を呼んで次ラウンド）にそのまま従う。`--resolve` は付けない。
3. ユーザーがコメント無しでFinish Reviewするまで繰り返す。

## ステップ4: commit

意味のある単位で複数のcommitに分ける。1つのcommitが1つの目的（1つの論理的な変更）に対応するようにし、無関係な変更を1つのcommitにまとめない。コミットメッセージは「なぜ」を中心に簡潔に書く。

## ステップ5: push

`git push` は権限設定上Bashから直接実行できないため、以下の形式でコマンドを提示し、ユーザー自身に `! <command>` で実行してもらう。

```
git push -u origin <branch>
```

ユーザーがpushを完了したことを確認してからステップ6に進む。

## ステップ6: Pull Requestの作成

1. PRのタイトル・本文（概要・テスト計画）を作成し、ベースブランチとともにユーザーに提示して確認を求める。実行前確認は必須のステップとして省略しない。
2. 承認後、以下の形式で実行する。

```bash
gh pr create --base <base-branch> --title "<title>" --body "<body>"
```

3. 作成されたPRのURLをユーザーに報告する。

## ステップ7: マージ後の後片付け

PR作成の報告後、同じ会話の中でユーザーから「マージされた」「PRがマージされたよ」などPRのマージを知らせる発言があったら、`Skill` ツールで `cleanup-worktree` スキルを呼び出す。引数には対象のブランチ名（ステップ6でPRを作成したブランチ）を渡す。

worktree・ブランチの実削除前の確認は `cleanup-worktree` 側のステップ4で行われるため、ここで重ねて確認を取る必要はない。

## 境界

- PRのマージ自体（`gh pr merge` 等）はこのスキルでは実行しない。マージされたかどうかはユーザーからの報告のみで判断し、能動的にCIやマージ状態を確認しにいくことはしない。
- `git push --force` やコミット履歴の書き換え（rebase, amendなど）は行わない。
- worktree自体の作成・削除、herdrワークスペースの管理は `start-worktree` / `cleanup-worktree` スキルの責務であり、実際の削除処理はステップ7で `cleanup-worktree` に委譲する。
