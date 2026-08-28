---
name: execute-plan-and-pr
description: >
  `plan-and-review` で承認された実装プランに従ってコード変更を実施し（Herdr環境では
  実装作業自体を別ペインのCodexに委譲する）、変更内容を
  tuicrでレビューしてもらい、意味のある単位でcommitし、
  pushコマンドを提示したうえでPull Requestを作成し、
  ユーザーからPRがマージされた旨の報告を受けたら `cleanup-worktree` スキルで後片付けまで行います。
  `plan-and-review` でのプラン承認後に自動的に呼び出されるほか、
  既存のworktreeで承認済みのプランファイルがある状態で
  「実装を進めて」「execute-plan-and-pr」「/execute-plan-and-pr」と言われた場合にも使用します。
argument-hint: "[issue/タスクのURL] [ブランチ名] [ベースブランチ] [プランファイルのパス]"
allowed-tools: Agent Skill Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git add:*) Bash(git commit:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(gh pr create:*) Bash(gh pr view:*) Bash(gh repo view:*) Bash(tuicr:*) Bash(~/.claude/skills/tuicr/tuicr-wrapper-herdr.sh:*) Bash(/Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/tuicr-pending-comments.sh:*) Bash(/Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/codex-implement-herdr.sh:*) Read
user-invocable: true
model: sonnet
---

`plan-and-review` で承認された実装プランを引き継ぎ、実装からPull Request作成・後片付けの呼び出しまでを行います。`plan-and-review` と対になるスキルで、Plan Mode承認後に呼び出される想定ですが、承認済みプランファイルが既にある状態で単独に呼び出してもかまいません。

このスキルの責務は **実装 → レビュー → commit → push案内 → PR作成 → （マージ報告を受けての）後片付けの呼び出し** まで。実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは扱わない。実装作業はコード変更の適用が中心のため、このスキルは `model: sonnet` で動作する。Herdr環境では、ステップ1の実装作業自体を別ペインのCodex（`codex exec`）に委譲する。委譲するのは実装のみで、レビュー・commit・push・PR作成・後片付けの判断はこのスキル（Claude）が引き続き担う。
`Agent(model="sonnet")` でモデルを切り替えてから実施します。

## 前提条件の確認

1. `git branch --show-current` で現在のブランチを確認する。`$ARGUMENTS` でブランチ名が渡されていて一致しない場合は、対象のworktree/ブランチに切り替わっているかユーザーに確認する。
2. `$ARGUMENTS` からプランファイルのパスが得られているか確認する。得られていなければユーザーに確認する。
3. プランファイルを読み、承認された実装方針を把握する。
4. `git rev-parse --show-toplevel` でworktreeの絶対パスを控える。ステップ1でHerdr環境の場合にCodexへ渡す。

## ステップ1: 実装

Herdr環境かどうかを判定する。

```bash
test "${HERDR_ENV:-}" = 1
```

**Herdr環境の場合（終了コード0）**: 実装作業をherdrの別ペインでCodexに委譲する（`codex exec -s workspace-write`）。このスキル自身がファイルを編集するのではなく、Codexに実装させ、完了を待って結果を検証する立場に回る。長時間ブロックしうるため、Bashのtimeoutは長め（600000ms）を指定する。

```bash
/Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/codex-implement-herdr.sh "<worktreeの絶対パス>" "<プランファイルの絶対パス>"
```

このコマンドは現在のペインの右側にherdrの別ペインを分割し、そこで承認済みプランの内容に従って `codex exec` を実行させ、完了するまで戻ってこない。完了後はそのペインを自動で閉じる。

1. 標準出力の `status=ok` を確認する。`status=error` の場合は `error=` の内容と（あれば）`last_message_path` の内容をユーザーに報告し、この先へは進まない。
2. `status=ok` の場合、`last_message_path` が指す一時ファイルを `Read` で読み、Codexの最終メッセージを確認する。プランに無い大きな方針転換が必要だとCodexが報告している場合は、実装を先へ進めず、その内容をそのままユーザーに提示して方針を確認する（Claude自身の判断で方針転換を代行しない）。
3. `git status --short` および `git diff --stat` で実際に変更が加わったことを確認する。変更が見当たらない場合は、その旨をユーザーに伝えて対応を確認する。
4. 問題なければ、Codexの最終メッセージの要約（変更したファイル一覧・実施内容）をユーザーに報告してステップ2に進む。

**Herdr環境でない場合**: 従来通りこのセッション自身が実装する。承認されたプランに従ってコード変更を実施し、プランに無い大きな方針転換が必要になった場合は、その場で実装を進めず、ユーザーに確認する。

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
3. wrapperの終了（または完了報告）を受けたら、`tuicr review list --repo <path>` で対象セッションの `path`（セッションJSONファイルの絶対パス）を取得する。セッションJSON全体を `Read` で読み込むのではなく、以下で未対応コメントだけを抽出する（`review_comments` / 各ファイルの `file_comments` / `line_comments` はコメントのやり取りをスレッド（配列）として保持しており、`author` が `execute-plan-and-pr` の応答が末尾に付いていれば対応済みとみなせる。生ファイルを毎回読むとdiff関連の付随情報やコメントの全履歴・対応済みスレッドまで読み込むことになりトークンを消費するため、スレッド末尾の author だけで未対応を判定するスクリプトに絞り込みを任せている）。

   ```bash
   /Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/tuicr-pending-comments.sh <session_json_path> execute-plan-and-pr
   ```

   出力は未対応スレッドのJSON配列（各要素: `scope`(`review`/`file`/`line`) / `path` / `line` / `author` / `lifecycle_state` / `content`）。
4. 出力が空配列であれば、「新規コメントはありませんでしたが、これで進めてよいですか？」とユーザーに確認する。承認が得られればステップ3(commit)へ進む。
5. 出力に要素があれば、各要素について `scope`/`path`/`line` から該当箇所を特定し、対応するファイルを修正する。対応内容は同じ箇所に以下の形式で短く記録する（tuicrには返信機能が無いため、新規コメントで代替する。これによりそのスレッドの末尾authorが `execute-plan-and-pr` になり、次回のステップ3では対応済みとして除外される）。

   ```bash
   # scope=line の場合
   tuicr review add --session '<slug>' --repo <path> --target-file <path> --line <line> --username 'execute-plan-and-pr' "対応: ..."
   # scope=file の場合（--line を省略）
   tuicr review add --session '<slug>' --repo <path> --target-file <path> --username 'execute-plan-and-pr' "対応: ..."
   # scope=review の場合（--target-file を省略）
   tuicr review add --session '<slug>' --repo <path> --username 'execute-plan-and-pr' "対応: ..."
   ```

6. 修正が終わったら、ステップ2に戻って再度tuicrを起動し、最新の差分をユーザーに確認してもらう。背後で `/review-local` スキルを実行してエージェントによるレビューも行う。ステップ4でユーザーが承認するまで繰り返す。
    レビューによる指摘点がtuicr上にコメントとして送信されるので、修正をcodexに移譲する。

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

PR作成の報告後、同じ会話の中でユーザーから「マージされた」「PRがマージされたよ」などPRのマージを知らせる発言があったら、`Skill` ツールで `cleanup-worktree` スキルを呼び出す。引数には対象のブランチ名（ステップ5でPRを作成したブランチ）を渡す。起点pane_idは `cleanup-worktree` 側が `start-worktree` の記録したファイルから自動検出するため、ここで明示的に渡す必要はない。

worktree・ブランチの実削除前の確認は `cleanup-worktree` 側のステップ4で行われるため、ここで重ねて確認を取る必要はない。

## 境界

- PRのマージ自体（`gh pr merge` 等）はこのスキルでは実行しない。マージされたかどうかはユーザーからの報告のみで判断し、能動的にCIやマージ状態を確認しにいくことはしない。
- `git push --force` やコミット履歴の書き換え（rebase, amendなど）は行わない。
- 実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは行わない。
- worktree自体の作成・削除、herdrワークスペースの管理は `start-worktree` / `cleanup-worktree` スキルの責務であり、実際の削除処理はステップ6で `cleanup-worktree` に委譲する。
- Herdr環境でCodexに委譲するのはステップ1（実装）のみ。tuicrレビュー・commit・push案内・PR作成・後片付けの呼び出しの判断はこのスキル（Claude）が行い、Codexには渡さない。
- Codexにプランへの方針転換を無断で行わせない。プランに無い方針転換が必要になった場合、Codexには実装を止めて理由を報告するよう指示しており、Claude側もその報告を検証なしにそのまま実装続行の判断に使わない（必ずユーザーに確認する）。
