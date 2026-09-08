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
allowed-tools: Agent Skill Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git add:*) Bash(git commit:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(git merge-base:*) Bash(git symbolic-ref:*) Bash(gh pr create:*) Bash(gh pr view:*) Bash(gh repo view:*) Bash(tuicr:*) Bash(herdr:*) Bash(jq:*) Bash(/Users/sugawarayss/.claude/skills/tuicr/tuicr-wrapper-herdr.sh:*) Bash(/Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/tuicr-pending-comments.sh:*) Read
user-invocable: true
model: sonnet
---

`plan-and-review` で承認された実装プランを引き継ぎ、実装からPull Request作成・後片付けの呼び出しまでを行います。`plan-and-review` と対になるスキルで、Plan Mode承認後に呼び出される想定ですが、承認済みプランファイルが既にある状態で単独に呼び出してもかまいません。

このスキルの責務は **実装 → レビュー → commit → push案内 → PR作成 → （マージ報告を受けての）後片付けの呼び出し** まで。実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは扱わない。実装作業はコード変更の適用が中心のため、このスキルは `model: sonnet` で動作する。

Herdr環境での役割分担は次の通り。ユーザーはtuicrで差分を確認しコメントを付けるだけ、コードレビュー（review-local）と采配（tuicr起動判断・未対応コメントの抽出・codexへの指示・commit/push/PR作成の判断）はClaude（このスキル自身、およびreview-localが起動するclaude kindのherdr agent）が担い、実際のコード変更の適用（ステップ1の実装、ステップ2のレビュー指摘対応）はcodex kindのherdr agentに委譲する。`codex`・`claude` はいずれもHerdrが認識する `agent --kind` なので、`herdr agent start`/`herdr agent prompt --wait`/`herdr agent read` をこのスキルから直接呼び出し、完了検知を独自スクリプトに頼らずHerdrのagentライフサイクル管理（idle/working/blocked）に任せる（`tuicr`自体はHerdrが認識するagent kindではないため、tuicrの起動は引き続き `tuicr-wrapper-herdr.sh` の生pane方式を使う）。codexに委譲するのはコード変更の適用のみで、レビューの実施・commit・push・PR作成・後片付けの判断はこのスキル（Claude）が引き続き担う。
`Agent(model="sonnet")` でモデルを切り替えてから実施します。

## 前提条件の確認

1. `git branch --show-current` で現在のブランチを確認する。`$ARGUMENTS` でブランチ名が渡されていて一致しない場合は、対象のworktree/ブランチに切り替わっているかユーザーに確認する。
2. `$ARGUMENTS` からプランファイルのパスが得られているか確認する。得られていなければユーザーに確認する。
3. プランファイルを読み、承認された実装方針を把握する。
4. `git rev-parse --show-toplevel` でworktreeの絶対パスを控える。ステップ1でHerdr環境の場合にCodexへ渡す。
5. ベースブランチを確認する。`$ARGUMENTS` で渡されていればそれを使う。渡されていなければ `git symbolic-ref refs/remotes/origin/HEAD --short` でリモートのデフォルトブランチを確認する（`review-local` のベースブランチ決定と同じ基準）。ステップ2のmerge-base計算で使う。

## ステップ1: 実装

Herdr環境かどうかを判定する。

```bash
test "${HERDR_ENV:-}" = 1
```

**Herdr環境の場合（終了コード0）**: 実装作業をherdrの別ペインでCodexエージェントに委譲する。`codex` はHerdrが認識する `agent --kind` の一つなので、生ペイン＋自前の完了検知スクリプトではなく `herdr agent` コマンド列を直接呼ぶ（`herdr agent prompt --wait` がidle/blocked遷移を検知するため、完了トークンの自作は不要）。

タイムアウトは2種類が独立に存在する点に注意する。`herdr agent prompt --wait --timeout` はHerdr CLIが状態変化を待つ時間の上限に過ぎず、これに達してもCodexプロセス自体はHerdrサーバー配下のペインで動き続ける（killされない）。一方、Bashツール自体の `timeout` パラメータ（デフォルト120000ms、最大600000ms）はそのシェル呼び出し（＝herdr CLIというクライアント）を打ち切る上限で、これもCodexの動作には影響しない。実装作業は10分を超えうるため、`--wait` には `--timeout` を付けず無期限待ちにし、Bashツール呼び出し側の `timeout` パラメータを最大値（600000ms）に指定する。それでもBashツールのタイムアウトでこの呼び出しが打ち切られた場合は失敗とみなさず、ステップ4-bのリトライで待ち直す。

1. 分割方向を決める。`herdr pane layout --pane "$HERDR_PANE_ID"` で現在ペインの形状を確認し、横長なら `right`、縦長/狭ければ `down` を選ぶ。
2. 実装用ペインを分割する（cwdはworktree、フォーカスは奪わない）。

   ```bash
   herdr pane split --current --direction <right|down> --cwd "<worktreeの絶対パス>" --no-focus
   ```

   `.result.pane.pane_id` を控える（以降 `<pane_id>`）。
3. そのペインでcodexエージェントを起動する。`--` 以降はcodexのネイティブ引数。`-s workspace-write`（このworktree配下のみ書き込み許可）・`-a never`（承認プロンプトを出さず自動実行）・`--no-alt-screen`（altスクリーンを使わせず、Herdrのhost scrollbackに出力を残して後で全文を読めるようにする）は必須。

   ```bash
   herdr agent start codeximpl --kind codex --pane <pane_id> -- -s workspace-write -a never -m gpt-5.6-sol --no-alt-screen
   ```

4. 承認済みプランの実装指示をプロンプトとして送り、完了まで待つ。プロンプトには以下を含める: 「承認済みの実装プラン（`<プランファイルの絶対パス>`）の内容に従って実装する」「担当範囲は実装とその動作確認・テスト実行までで、commit/push/PR作成/tuicrレビュー/worktree削除は行わない」「AGENTS.md/CLAUDE.md等の規約があれば従う」「プランに無い大きな方針転換が必要な場合は実装を進めず理由を報告する」「完了したら変更ファイル一覧と実施内容の要約を報告する」。

   ```bash
   herdr agent prompt codeximpl "<実装指示プロンプト>" --wait
   ```

   このBash呼び出し自体の `timeout` パラメータを600000ms（最大値）に指定する。

   4-b. Bashツールのタイムアウトでこの呼び出し自体が打ち切られた場合（herdr側のエラーではなくBashツールが強制終了した場合）: Codexはまだペインで動作中の可能性が高いので、失敗と判断せず `herdr agent get codeximpl` で状態を確認する。`working` であれば、プロンプトを再送せず `herdr agent wait codeximpl`（`--until` は付けない。`agent prompt --wait` と同じ設定完了待ちになる。Bashツールのtimeoutを600000msにして）で待ち直す。これを `idle`/`done`/`blocked` になるまで繰り返す。
5. 結果を確認する。
   - `blocked` が返った場合（`-a never` 指定時は基本発生しないはずだが念のため）: `herdr agent get codeximpl` と `herdr agent read codeximpl --source recent-unwrapped --lines 120` で状況を確認し、ユーザーに判断を仰ぐ（Claude自身の判断で承認を代行しない）。
   - `idle`/`done` の場合: `herdr agent read codeximpl --source recent-unwrapped --lines 300` でCodexの最終メッセージを読む。応答が途中で切れていて全文を読めない場合（何らかの理由でaltスクリーンに戻ってしまった等）のみ、フォールバックとして「最終メッセージをMarkdownで一時ファイルに書き出し、ファイルパスのみ返信して」と追加で `herdr agent prompt codeximpl "..." --wait` し、返ってきたパスを `Read` する。
6. `herdr pane close <pane_id>` でペインを閉じる（エラーで中断した場合も、`pane_id` が分かっていればユーザーへの報告前に閉じておく）。
7. プランに無い大きな方針転換が必要だとCodexが報告している場合は、実装を先へ進めず、その内容をそのままユーザーに提示して方針を確認する（Claude自身の判断で方針転換を代行しない）。
8. `git status --short` および `git diff --stat` で実際に変更が加わったことを確認する。変更が見当たらない場合は、その旨をユーザーに伝えて対応を確認する。
9. 問題なければ、Codexの最終メッセージの要約（変更したファイル一覧・実施内容）をユーザーに報告してステップ2に進む。

**Herdr環境でない場合**: 従来通りこのセッション自身が実装する。承認されたプランに従ってコード変更を実施し、プランに無い大きな方針転換が必要になった場合は、その場で実装を進めず、ユーザーに確認する。

## ステップ2: 変更内容のレビュー（tuicr）

`tuicr` スキル（`tuicr review list/add` の作法）を前提とする。Herdr環境では `tuicr` スキル付属の `tuicr-wrapper-herdr.sh` を使い、ユーザーがtuicrを閉じる（`q`）までブロックして起動する。この設計はブロッキング起動を許容できる用途（ユーザーが見終えるまで待てばよい今回のレビューループ）に限る。

Herdr環境では、review-localによる自動レビュー（手順3）と、その指摘への対応（手順6）を、ステップ1のCodex委譲と同じ「`herdr agent`で別ペインを分割しHerdrのagentライフサイクル管理（idle/working/blocked）に完了検知を任せる」パターンで行う。review-localは `--kind claude`、指摘対応はステップ1と同じ `--kind codex` のagentを使う。非Herdr環境ではペイン分割ができないため、review-localは `Agent` ツールでの内製subagent呼び出しにフォールバックし、指摘対応はexecute-plan-and-pr自身が行う（Herdr環境でCodexに委譲するのはステップ1の実装とこのステップの指摘対応のみで、tuicrの実施判断やreview-localの起動判断そのものはこのスキルが担う）。

ステップ3で `review-local` にこのステップのtuicrセッションをそのまま再利用させるため、`review-local` の「Diffの対象範囲を決める（merge-base）」と同じ基準でrangeを揃える。

### 対象rangeの決定（merge-base）

```bash
git merge-base <base-branch> HEAD
```

`<base-branch>` は前提条件の確認で控えたベースブランチを使う。以降、この節で得た `<merge-base-sha>` を使う。

1. `tuicr review list --repo <worktreeのパス>` でライブセッションの有無を確認する。`kind: "local"` で `anchor` が現在のブランチ、mode（sha部分の前）が `staged-and-unstaged-and-commits`、sha部分が `<merge-base-sha 7桁>..<HEAD 7桁>` のセッションがあれば、それが今回のセッション。
2. Herdr環境かどうかを判定する。

   ```bash
   test "${HERDR_ENV:-}" = 1
   ```

   **Herdr環境の場合（終了コード0）**: ユーザーに確認や依頼をせず、以下を実行する。長時間ブロックしうるため、Bashのtimeoutは長め（600000ms）を指定する。

   ```bash
   /Users/sugawarayss/.claude/skills/tuicr/tuicr-wrapper-herdr.sh "<worktreeのパス>" -- -r <merge-base-sha>..HEAD -w
   ```

   このコマンドはユーザーがtuicrを `q` で閉じるまで戻ってこない。「コメントを付け終えたら教えてください」という手動の完了報告は不要（wrapperの終了自体が完了シグナルになる）。このBashツール呼び出しは、手順3の `herdr agent prompt reviewlocal --wait` と同じメッセージ内で並列に発行する。

   **Herdr環境でない場合**: ユーザーに `tuicr -r <merge-base-sha>..HEAD -w` をターミナルで起動し、レビューが終わったら教えてもらうよう依頼し、完了報告を待つ。この依頼を出すのと同じメッセージ内で、手順3の `Agent` 呼び出しも発行する。

3. レビューエージェントの実行（review-local）

   **Herdr環境の場合**: `review-local` を別ペインの独立したClaude Codeセッション（`--kind claude`）で実行させる。ペイン分割の方向判定・タイムアウト処理（Bashの `timeout` 600000ms指定、打ち切られた場合の `herdr agent get`/`herdr agent wait` によるリトライ）・`blocked`時の対応（ユーザーに判断を仰ぐ）は、ステップ1の該当手順（1〜2、4-b、5前半）と同様に行う。

      ```bash
      herdr pane split --current --direction <right|down> --cwd "<worktreeの絶対パス>" --no-focus
      herdr agent start reviewlocal --kind claude --pane <review_pane_id> -- --permission-mode bypassPermissions
      ```

      `--permission-mode bypassPermissions` はcodexの `-a never` に相当する自動承認設定。review-localは内部で `Agent` ツール（5観点のsubagent）や `Bash`（`git diff`・`tuicr review add` 等）を実行するため、これが無いと承認待ちで `blocked` になる。

      プロンプトには以下を含める: 「`Skill` ツールで `review-local` を実行する」「対象worktreeの絶対パスは `<worktreeの絶対パス>`」「対象range・セッションは既に `<merge-base-sha>` で確定済みなので、review-local自身のベースブランチ検出・merge-base再計算はスキップし渡された値をそのまま使う（手順1で確認した既存tuicrセッションを再利用させ、新規セッション・新規ペインを重複して作らせないため）」「完了したら `posted`（投稿件数）・`failed`（投稿失敗の指摘）を報告する」。

      ```bash
      herdr agent prompt reviewlocal "<review-local実行指示プロンプト>" --wait
      ```

      完了後は `herdr agent read reviewlocal --source recent-unwrapped --lines 300` で `posted`/`failed` を読み取り、`herdr pane close <review_pane_id>` でペインを閉じる。

   **Herdr環境でない場合**: `Agent` ツール（`subagent_type: general-purpose`）で上記と同じ内容（`Skill` ツールでの `review-local` 呼び出し・`<merge-base-sha>` と `--repo` 値の引き渡し・`posted`/`failed` の報告）をバックグラウンドで依頼する。

   このステップの完了は、手順2のtuicr起動（wrapperの終了、または非Herdr環境でのユーザーの完了報告）とあわせて待つ。両方が揃ってから手順4に進む。

4. 手順2のtuicr起動完了（wrapperの終了、または完了報告）と手順3の完了通知の両方を受けたら、`tuicr review list --repo <path>` で対象セッションの `path`（セッションJSONファイルの絶対パス）を取得する。セッションJSON全体を `Read` で読み込むのではなく、以下で未対応コメントだけを抽出する（`review_comments` / 各ファイルの `file_comments` / `line_comments` はコメントのやり取りをスレッド（配列）として保持しており、`author` が `execute-plan-and-pr` の応答が末尾に付いていれば対応済みとみなせる。生ファイルを毎回読むとdiff関連の付随情報やコメントの全履歴・対応済みスレッドまで読み込むことになりトークンを消費するため、スレッド末尾の author だけで未対応を判定するスクリプトに絞り込みを任せている）。

   ```bash
   /Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/tuicr-pending-comments.sh <session_json_path> execute-plan-and-pr
   ```

   出力は未対応スレッドのJSON配列（各要素: `scope`(`review`/`file`/`line`) / `path` / `line` / `author` / `lifecycle_state` / `content`）。
5. 出力が空配列であれば、「新規コメントはありませんでしたが、これで進めてよいですか？」とユーザーに確認する。承認が得られれば次のステップ（commit）へ進む。
6. 出力に要素があれば、Herdr環境かどうかで対応方法を分ける。

   **Herdr環境の場合**: 修正をcodexのherdr agentに委譲する。ペイン分割・agent起動・タイムアウト処理・`blocked` 時の対応はステップ1の該当手順と同様に行う（agent名は `codeximpl` とは別に `codexfix` を使う。ステップ1のペインは既に閉じているため名前は独立でよい）。

      ```bash
      herdr pane split --current --direction <right|down> --cwd "<worktreeの絶対パス>" --no-focus
      herdr agent start codexfix --kind codex --pane <fix_pane_id> -- -s workspace-write -a never -m gpt-5.6-sol --no-alt-screen
      ```

      手順4で得た未対応コメント一覧（`scope`/`path`/`line`/`content`）をプロンプトに含め、以下を明記して送る: 「以下のtuicrレビュー指摘に対応する」「commit/push/PR作成/tuicrへの投稿は行わない（対応の記録はexecute-plan-and-prが行う）」「指摘の対応範囲を超える大きな変更が必要な場合は実装を進めず理由を報告する」「完了したら指摘ごとに1〜2文の対応内容の要約を返す」。

      ```bash
      herdr agent prompt codexfix "<未対応コメント一覧＋指示>" --wait
      ```

      完了後は `herdr agent read codexfix --source recent-unwrapped --lines 300` で対応要約を読み、`herdr pane close <fix_pane_id>` でペインを閉じる。`git status --short` で実際に変更が加わったことを確認する。指摘の対応範囲を超える方針転換が必要だとcodexfixが報告している場合は、ステップ1の手順7と同様、その内容をそのままユーザーに提示して方針を確認する（Claude自身の判断で方針転換を代行しない）。

      codexfixの対応要約をもとに、指摘ごとに以下の形式で `tuicr review add` を実行する（この投稿はexecute-plan-and-pr自身が行う。tuicrには返信機能が無いため新規コメントで代替する。これによりそのスレッドの末尾authorが `execute-plan-and-pr` になり、次回の手順4では対応済みとして除外される）。

      ```bash
      # scope=line の場合
      tuicr review add --session '<slug>' --repo <path> --target-file <path> --line <line> --username 'execute-plan-and-pr' "対応: <codexfixの要約>"
      # scope=file の場合（--line を省略）
      tuicr review add --session '<slug>' --repo <path> --target-file <path> --username 'execute-plan-and-pr' "対応: <codexfixの要約>"
      # scope=review の場合（--target-file を省略）
      tuicr review add --session '<slug>' --repo <path> --username 'execute-plan-and-pr' "対応: <codexfixの要約>"
      ```

   **Herdr環境でない場合**: 従来通りこのセッション自身が該当ファイルを修正し、同様の形式で `tuicr review add --username 'execute-plan-and-pr'` を実行して対応内容を記録する。

7. 修正が終わったら、手順2に戻って再度tuicrを起動し、最新の差分をユーザーに確認してもらう（手順3のreview-local呼び出しも同様に行われる）。手順5でユーザーが承認するまで繰り返す。

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
- Herdr環境でCodexに委譲するのはコード変更の適用のみ（ステップ1の実装、ステップ2手順6のレビュー指摘対応）。tuicrの起動判断・review-localの起動・未対応コメントの抽出・commit・push案内・PR作成・後片付けの呼び出しの判断はこのスキル（Claude）が行い、Codexには渡さない。
- コードレビュー（review-local）はHerdr環境では別ペインのclaude kind herdr agentに、非Herdr環境では内製の`Agent`ツールに委譲する。レビュー結果の解釈・修正要否の判断・tuicrへの「対応」コメント投稿はこのスキル（Claude）自身が行い、review-localやcodexに行わせない。
- ユーザーの役割はtuicrでの差分確認とコメント追加のみ。tuicrの起動・停止・レビュー指摘への対応はこのスキルとcodex/review-localのagentが行い、ユーザーに追加の操作を求めない（tuicr起動をユーザーに依頼する非Herdr環境を除く）。
- Codexにプランへの方針転換・レビュー指摘の対応範囲を超える大きな変更を無断で行わせない。プランに無い方針転換や指摘対応の範囲を超える変更が必要になった場合、Codexには作業を止めて理由を報告するよう指示しており、Claude側もその報告を検証なしにそのまま続行の判断に使わない（必ずユーザーに確認する）。
