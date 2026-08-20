---
name: plan-and-review
description: >
  worktree内でissue/タスクの実装プランを検討し、Plan Modeのcrit連携（ExitPlanMode時に
  自動起動する crit plan-hook）でユーザーレビューを受け、承認されたら実装フェーズを
  `execute-plan-and-pr` スキルに引き継ぎます。
  `/start-worktree` からworktree作成後に自動的に呼び出されるほか、
  既存のworktree内で「実装してPRまで作って」「このissueの実装を進めて」
  「plan-and-review」「/plan-and-review」と言われた場合にも使用します。
argument-hint: "[issue/タスクのURL] [ブランチ名] [ベースブランチ]"
allowed-tools: Agent Skill EnterPlanMode ExitPlanMode Bash(git status:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(gh issue view:*) mcp__github__get_issue mcp__claude_ai_ClickUp__clickup_get_task
user-invocable: true
model: opus
---

worktree内でissue/タスクの実装プランを検討し、ユーザーレビューを経て承認を得るところまでを行います。`start-worktree` スキルと対になるスキルで、worktree作成後に引き継がれる想定ですが、既存のworktreeで単独に呼び出してもかまいません。

このスキルの責務は **実装プランの検討 → レビュー → 承認** まで。承認後の **実装 → レビュー → commit → push案内 → PR作成 → （マージ報告を受けての）後片付けの呼び出し** は `execute-plan-and-pr` スキルに引き継ぐ。プラン検討は方針判断の比重が大きいためこのスキルは `model: opus` で動作し、実装フェーズは `execute-plan-and-pr` 側で `model: sonnet` に切り替わる。worktree自体の作成・herdrワークスペースのオープンは `start-worktree` スキルの責務であり、ここでは扱わない。

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

## ステップ2: 実装フェーズへの引き継ぎ

Plan Modeを抜けたら、`Skill` ツールで `execute-plan-and-pr` を呼び出す。引数にはissue/タスクのURL、ブランチ名、ベースブランチ、承認されたプランファイルのパスを渡す。以降の実装・レビュー・commit・push案内・PR作成・後片付けの呼び出しは `execute-plan-and-pr` の責務であり、このスキルはここで完了する。

## 境界

- Plan Mode承認後の実装・commit・PR作成・後片付けの呼び出しは行わない（`execute-plan-and-pr` に引き継ぐ）。
- worktree自体の作成・削除、herdrワークスペースの管理は `start-worktree` / `cleanup-worktree` スキルの責務であり、ここでは扱わない。
