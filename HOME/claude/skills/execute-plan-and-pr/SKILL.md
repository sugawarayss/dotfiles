---
name: execute-plan-and-pr
description: >
  `plan-and-review` で承認された実装プランに従ってコード変更を実施し（実装作業自体は
  Agentツールのsubagentに委譲する）、変更内容を
  critでレビューしてもらい、意味のある単位でcommitし、
  pushコマンドを提示したうえでPull Requestを作成し、
  ユーザーからPRがマージされた旨の報告を受けたら `cleanup-worktree` スキルで後片付けまで行います。
  `plan-and-review` でのプラン承認後に自動的に呼び出されるほか、
  既存のworktreeで承認済みのプランファイルがある状態で
  「実装を進めて」「execute-plan-and-pr」「/execute-plan-and-pr」と言われた場合にも使用します。
argument-hint: "[issue/タスクのURL] [ブランチ名] [ベースブランチ] [プランファイルのパス]"
allowed-tools: Agent Skill Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git add:*) Bash(git commit:*) Bash(git branch:*) Bash(git rev-parse:*) Bash(git merge-base:*) Bash(git symbolic-ref:*) Bash(gh pr create:*) Bash(gh pr view:*) Bash(gh repo view:*) Bash(crit:*) Bash(terminal-browser:*) Bash(herdr:*) Bash(jq:*) Bash(/Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/crit-pending-comments.sh:*) AskUserQuestion Read
user-invocable: true
model: sonnet
---

`plan-and-review` で承認された実装プランを引き継ぎ、実装からPull Request作成・後片付けの呼び出しまでを行います。`plan-and-review` と対になるスキルで、Plan Mode承認後に呼び出される想定ですが、承認済みプランファイルが既にある状態で単独に呼び出してもかまいません。

このスキルの責務は **実装 → レビュー → commit → push案内 → PR作成 → レビュー指摘のルール化の提案 → （マージ報告を受けての）後片付けの呼び出し** まで。実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは扱わない。このスキル自身は采配が中心のため `model: sonnet` で動作する。

役割分担は次の通り。ユーザーはcritで差分を確認しコメントを付けるだけ。コードレビューはreview-local（Herdr環境では別ペインのclaude kindのherdr agent、非Herdr環境では `Agent` ツール）が担う。実際のコード変更の適用（ステップ1の実装、ステップ2のレビュー指摘対応。後者は未対応コメントの取得と「対応」コメントの投稿を含む）は、環境を問わず `Agent` ツールのsubagent（`subagent_type: general-purpose`）に委譲する。subagentは毎回新しく起動し、前の実装・修正の文脈を引き継がない（レビュー指摘に対して実装時の思い込みで反論させないため）。采配（crit起動判断・未対応コメント件数の確認・subagentへの指示と結果の検証・commit/push/PR作成・後片付けの判断）はこのスキル自身が担う。review-localとsubagentのやり取りはcritのコメントスレッド上で行い、指摘本文や対応内容をこのスキルのコンテキストに載せない。

## 前提条件の確認

1. `git branch --show-current` で現在のブランチを確認する。`$ARGUMENTS` でブランチ名が渡されていて一致しない場合は、対象のworktree/ブランチに切り替わっているかユーザーに確認する。
2. `$ARGUMENTS` からプランファイルのパスが得られているか確認する。得られていなければユーザーに確認する。
3. プランファイルを読み、承認された実装方針を把握する。
4. `git rev-parse --show-toplevel` でworktreeの絶対パスを控える。ステップ1・2でsubagentへ渡す。
5. ベースブランチを確認する。`$ARGUMENTS` で渡されていればそれを使う。渡されていなければ `git symbolic-ref refs/remotes/origin/HEAD --short` でリモートのデフォルトブランチを確認する（`review-local` のベースブランチ決定と同じ基準）。ステップ2のmerge-base計算で使う。

## ステップ1: 実装

実装作業を `Agent` ツールのsubagent（`subagent_type: general-purpose`）に委譲する。Herdr環境かどうかで手順は変えない。

1. `Agent` ツールで実装を依頼する。プロンプトには以下を含める: 「承認済みの実装プラン（`<プランファイルの絶対パス>`）の内容に従って実装する」「作業対象のworktreeは `<worktreeの絶対パス>`」「担当範囲は実装とその動作確認・テスト実行までで、commit/push/PR作成/critレビュー/worktree削除は行わない」「CLAUDE.md・`rules/` 等の規約に従う」「プランに無い大きな方針転換が必要な場合は実装を進めず理由を報告する」「報告前に、変更した判定・処理と同種の箇所が他に残っていないかをセルフレビューし、見つけた問題は直してから報告する」「完了したら変更ファイル一覧と実施内容の要約だけを報告する（diff本文は報告に含めない）」。
2. 完了通知を待ち、subagentの報告を読む。
3. プランに無い大きな方針転換が必要だとsubagentが報告している場合は、実装を先へ進めず、その内容をそのままユーザーに提示して方針を確認する（Claude自身の判断で方針転換を代行しない）。
4. `git status --short` および `git diff --stat` で実際に変更が加わったことを確認する。変更が見当たらない場合は、その旨をユーザーに伝えて対応を確認する。
5. 問題なければ、subagentの報告の要約（変更したファイル一覧・実施内容）をユーザーに報告してステップ2に進む。

## ステップ2: 変更内容のレビュー（crit）

`crit-cli` スキル（`crit comment` / `crit comments` の作法）を前提とする。critはユーザーが Finish Review を押すまでブロックし、2回目以降に同じセッションで起動し直すと前の周回の完了を通知してから再びブロックするため、このレビューループの「ユーザーが見終えるまで待つ」にそのまま使える。

review-localによる自動レビュー（手順3）は、Herdr環境では「`herdr agent`で別ペインを分割し、別ペインのclaude agentの完了を待つ」パターンで行い、非Herdr環境では `Agent` ツールでの内製subagent呼び出しにフォールバックする。その指摘への対応（手順6）は、環境を問わずステップ1と同じく `Agent` ツールのsubagentに委譲する（critの起動判断やreview-localの起動判断そのものはこのスキルが担う）。

### 対象rangeの決定（merge-base）

```bash
git merge-base <base-branch> HEAD
```

`<base-branch>` は前提条件の確認で控えたベースブランチを使う。この節で得た `<merge-base-sha>` は、review-localの分析用diff（`git diff <merge-base-sha>`）に使う。critは `--base-branch <base-branch>` を渡すと、同じmerge-baseから作業ツリー（未コミットの変更を含む）までを差分にするため、commitの前後で起動方法を変える必要はない。

1. 開き方を確認する（1周目のみ）。AskUserQuestionで、①`--no-open` でブラウザの自動起動を止め、レビューURLを `terminal-browser open <url> --split right` でherdr内のペインに開く、②`--no-open` を付けずにcrit標準のブラウザ起動に任せる、のどちらにするかを確認する。2周目以降は同じ開き方を使う。
2. critを起動する。worktreeの絶対パスをcwdにして、Bashツールで `run_in_background: true` と `timeout: 86400000` を指定して実行する。

   ```bash
   # 1周目
   crit --base-branch <base-branch> --no-open   # ①の場合
   crit --base-branch <base-branch>             # ②の場合
   # 2周目以降（前の周回の完了を通知してから再びブロックする）
   crit --session <session_id>
   ```

   起動出力の1行目（`Started crit daemon at http://localhost:<port> (session <session_id>, ...)`）からURLとセッションIDを控える。まだ出力されていなければ1〜2秒待って再確認する（最大5回）。①の場合は1周目だけ `terminal-browser open <url> --split right` で開く。2周目以降に `crit --session` がセッション未検出で失敗した場合（前の周回で未resolveのコメントが0件だとcritのデーモンが停止する）は、1周目のコマンドで起動し直し、新しいセッションIDを控える。

   **critの出力ファイルは、起動行以外を読まない。** 終了時の出力にはコメント本文が含まれるため、読むと本文をこのスキルのコンテキストに載せないという方針が崩れる。完了はバックグラウンドタスクの終了通知で知る。このBashツール呼び出しは、手順3のreview-local呼び出しと同じメッセージ内で並列に発行する。

3. レビューエージェントの実行（review-local）

   **Herdr環境の場合**: `review-local` を別ペインの独立したClaude Codeセッション（`--kind claude`）で実行させる。ペインの分割方向は `herdr pane layout --pane "$HERDR_PANE_ID"` で現在ペインの形状を確認して決める（横長なら `right`、縦長/狭ければ `down`）。`herdr agent start` には「対話可能になるまで待つ」タイムアウト（デフォルト30000ms）があり、nonoサンドボックス経由の起動は時間がかかるため `--timeout 300000`（最大値）を指定する。claudeはherdrの状態判定が効くので、完了待ちには `herdr agent prompt --wait` を使い、Bashの `timeout` を600000msに指定する。Bashツールのタイムアウトで打ち切られた場合は、プロンプトを再送せず `herdr agent wait reviewlocal`（`--until` なし。idle/done/blockedに一致するまで待つ）で待ち直す。

      ```bash
      herdr pane split --current --direction <right|down> --cwd "<worktreeの絶対パス>" --no-focus
      herdr agent start reviewlocal --kind claude --pane <review_pane_id> --timeout 300000 -- --permission-mode bypassPermissions
      ```

      `--permission-mode bypassPermissions` は承認プロンプトを出さない自動承認設定。review-localは内部で `Agent` ツール（5観点のsubagent）や `Bash`（`git diff`・`crit comment` 等）を実行するため、これが無いと承認待ちで `blocked` になる。

      プロンプトには以下を含める: 「`Skill` ツールで `review-local` を実行する」「対象worktreeの絶対パスは `<worktreeの絶対パス>`」「対象rangeは `<merge-base-sha>`、critのセッションは `--session <session_id>` で確定済みなので、review-local自身のベースブランチ検出・merge-base再計算・crit起動はスキップし渡された値をそのまま使う（手順2で起動したcritセッションに投稿させ、新規セッションを重複して作らせないため）」「完了したら `posted`（新規投稿件数）・`replied`（返信件数）・`resolved`（resolveした件数）・`failed`（投稿失敗の指摘）・`disputed`（意見が割れた指摘の `path:line` と論点）を報告する」。2周目以降は「過去の対応・見送りのやり取りを踏まえてレビューし、決着した指摘はresolveする」も含める（review-localが「対応:」の検証や「見送り:」への反論を返信し、手順6の修正subagentが再度応答することで、エージェント同士の議論になる。決着した指摘をreview-localがresolveすることで、ユーザーのcrit画面には未決着の指摘だけが残る）。

      ```bash
      herdr agent prompt reviewlocal "<review-local実行指示プロンプト>" --wait
      ```

      完了後は `herdr agent read reviewlocal --source recent-unwrapped --lines 300` で `posted`/`replied`/`resolved`/`failed`/`disputed` を読み取り、`herdr pane close <review_pane_id>` でペインを閉じる。

   **Herdr環境でない場合**: `Agent` ツール（`subagent_type: general-purpose`）で上記と同じ内容（`Skill` ツールでの `review-local` 呼び出し・`<merge-base-sha>` と `--session <session_id>` の引き渡し・`posted`/`replied`/`resolved`/`failed`/`disputed` の報告）をバックグラウンドで依頼する。

   このステップの完了は、手順2のcritの終了（ユーザーが Finish Review を押した）とあわせて待つ。両方が揃ってから手順4に進む。review-localの投稿はcritの画面に即座に反映されるため、ユーザーはreview-localの完了前からレビューを始められる。

4. 手順2のcritの終了と手順3の完了通知の両方を受けたら、以下で未対応コメントだけを抽出する（未resolveのコメントのうち、スレッド末尾の発言者が `execute-plan-and-pr` でないものを未対応とみなす。コメント全件を読むと対応済みスレッドの本文まで読み込むことになりトークンを消費するため、スクリプトに絞り込みを任せている）。

   ```bash
   /Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/crit-pending-comments.sh <session_id> execute-plan-and-pr
   ```

   出力は未対応コメントのJSON配列（各要素: `id` / `scope`(`review`/`file`/`line`) / `path` / `start_line` / `end_line` / `author` / `content`。`author` と `content` はスレッド末尾の発言のもの）。

   コメント本文の取得と対応は手順6の修正subagentが自分で行うため、このスキルでは件数だけを確認する（本文をこのスキルのコンテキストに載せない）。

   ```bash
   /Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/crit-pending-comments.sh <session_id> execute-plan-and-pr | jq length
   ```

   **2周目以降（手順6を既に1回以上実行した後）のsuggest/norushの見送り**: review-localは各指摘に重要度 `[must|should|suggest|norush|nitpick]` を付けて投稿する。1周目は重要度を問わず全件に対応するが、2周目以降にreview-localが新たに投稿した `suggest`/`norush` の指摘は修正せず見送る（修正後のコードに対して毎回追加のテストケースや書き方の揃えを求められ、ループが収束しなくなるのを防ぐため）。`nitpick`（変更行内の数行で直せて、テスト追加も横展開も要らないもの）は新たな指摘を生みにくいので、`must`/`should` と同じく見送らずに手順6で修正する。件数確認の前に、対象の場所だけを抽出して見送りを記録する（本文は読まない）。

   ```bash
   /Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/crit-pending-comments.sh <session_id> execute-plan-and-pr \
     | jq -c '[.[] | select((.author | test("^review-local(/|$)")) and (.content | test("\\[(suggest|norush)\\]"))) | {reply_to: .id, body: "見送り: 2周目以降のsuggest/norushの指摘のため対応しない"}]'
   ```

   返ったJSONをそのまま `crit comment --session <session_id> --author 'execute-plan-and-pr' --json` の標準入力に渡し、1回のBash呼び出しで全件に返信する。これでそのスレッドは対応済み扱いになり、上記の件数には含まれなくなる（次の周回でreview-localがresolveする）。見送った件数は手順5の確認で伝える。ユーザー（またはreview-local以外）のコメントは重要度を問わず見送らない。見送ったスレッドにユーザーがcritで返信すれば、末尾の発言者がユーザーになるため次の周回で通常の指摘として対応される。
5. 件数が0（空配列）であれば、「新規コメントはありませんでしたが、これで進めてよいですか？」とユーザーに確認する（suggest/norushを見送った場合は「suggest/norushのN件は見送りました。対応が必要なものがあればcritでそのスレッドに返信してください」と添える。手順3でreview-localが `disputed` を報告した場合は、その `path:line` と論点を列挙し「review-localと修正側で意見が割れています。判断をcritのそのスレッドに返信してください」と添える。提示した `disputed` の一覧は、手順6と後述「意見が割れた指摘の判断記録」で使うので保持しておく）。承認が得られれば次のステップ（commit）へ進む。
6. 件数が1以上であれば、未対応コメントの取得・修正・「対応」コメントの投稿まで、まとめて `Agent` ツールのsubagent（`subagent_type: general-purpose`）に委譲する（対応内容を一番よく知っている修正者自身が投稿することで、このスキルが要約を言い換える際の情報の欠落と、コメント一覧・対応要約をこのスキルのコンテキストに載せるトークン消費を避ける）。ステップ1の実装subagentは再利用せず、新しいsubagentを起動する。

   コメント本文はプロンプトに含めず、取得に必要な情報（critのセッションID・worktreeの絶対パス）と下記のコマンドテンプレートを渡す。プロンプトには以下を明記する: 「まず `crit-pending-comments.sh <session_id> execute-plan-and-pr` を実行して未対応のcritレビュー指摘を取得し、それぞれに対応する」「指摘本文に `同種の箇所: path:line, ...` が列挙されている場合は、代表箇所と同時にそれらもすべて直し、対応コメントにも直した箇所を含める」「1件の修正が終わるごとに、そのスレッドに下記テンプレートで『対応: <1〜2文の対応内容>』を返信する。`--author` は必ず `execute-plan-and-pr` にする（スレッド末尾の発言者がこの名前であることで対応済みと判定されるため）」「`--resolve` は付けない（resolveはレビュー側とユーザーが行う）」「対応しなかった指摘（対応範囲を超える大きな変更が必要なもの等）には何も投稿せず、実装も進めない」「`再指摘:`/`反論:` で始まる指摘はreview-localが以前の『対応:』『見送り:』に返信したもの。修正するなら『対応:』、それでも見送るなら反論への根拠を添えた『見送り: <理由>』を投稿する（再度の見送りはreview-localがユーザーに判断を委ねるので、無言で放置しない）。指摘に同意できない場合も、根拠なく同意して直すのではなく根拠を添えて『見送り:』にする」「未対応一覧に無いスレッドへの投稿、commit/push/PR作成は行わない」「投稿前に、指摘と同種の問題が他の箇所に残っていないかセルフレビューする」「最終メッセージは、対応件数と、対応しなかった指摘それぞれの場所と理由だけにする（指摘ごとの対応内容はcritに返信済みなので繰り返さない）」。保持している `disputed` の一覧があり、そのスレッドが未対応一覧に含まれる（ユーザーが判断をコメントした）場合は、その一覧と「このスキルの『意見が割れた指摘の判断記録』節に従って記録する」旨もプロンプトに含め、最終メッセージに「判断を記録した指摘それぞれの場所・採った判断・記録先」を加えさせる。

   ```bash
   # 未対応指摘の取得（出力: id/scope/path/start_line/end_line/author/content のJSON配列）
   /Users/sugawarayss/.claude/skills/execute-plan-and-pr/scripts/crit-pending-comments.sh <session_id> execute-plan-and-pr
   # 返信（scopeを問わず、取得した id に返信する）
   crit comment --session '<session_id>' --author 'execute-plan-and-pr' --reply-to '<id>' '対応: <対応内容>'
   ```

   返信によりそのスレッドの末尾の発言者が `execute-plan-and-pr` になり、次回の手順4では対応済みとして除外される。

   完了通知を受けたら、subagentの最終メッセージを読み、以下の2点を確認する。
   - `git status --short` で実際に変更が加わったこと。
   - 手順4と同じ `crit-pending-comments.sh ... | jq length` の結果が、subagentが報告した「対応しなかった指摘」の件数と一致すること。一致しない場合（返信漏れ・`--author` の誤り等）は、パイプせずに再実行して残っているスレッドを確認し、subagentの報告をもとにこのスキルが `crit comment --author 'execute-plan-and-pr' --reply-to <id>` で補う。

   subagentが対応しなかった指摘（指摘の対応範囲を超える方針転換が必要なもの等）がある場合は、ステップ1の手順3と同様、その場所と理由をそのままユーザーに提示して方針を確認する（Claude自身の判断で方針転換を代行しない）。

7. 修正が終わったら、手順2に戻って `crit --session <session_id>` で次の周回を始め、最新の差分をユーザーに確認してもらう（手順3のreview-local呼び出しも同様に行われる）。手順5でユーザーが承認するまで繰り返す。

### 意見が割れた指摘の判断記録

critのレビューはローカルにしか残らないため、ユーザーが下した判断を記録しないと、次のレビュー（別セッション・別の人）で同じ指摘が蒸し返される。記録するのは、ユーザーが判断をコメントした後に限る（判断前の対立そのものは記録しない）。

- ユーザーの判断に従って修正した場合: 修正そのものが記録になるので、仕様書・コメントには残さない（PR本文の一覧にだけ載せる）。
- 見送りが確定した場合（または、判断がコードから読み取れない制約を課す場合）は、判断の性質で記録先を選ぶ。
  - 仕様・設計方針に関わる判断（例: 「並列化はしない」「この入力は許容する」）: プロジェクトのシステム仕様書（`docs/stock/` など。既存の文書構造を優先）の制約・例外条件として追記する。該当する仕様書が無いプロジェクトでは、仕様書を新設せずコードコメントにする。
  - その箇所に閉じた判断（例: 「N+1だが件数上限があるので許容」）: 該当箇所に「なぜそうしているか」を1〜2行のコードコメントで残す（コードの説明ではなく、判断の理由だけを書く）。
- 記録した場合は、そのスレッドへの「対応:」コメントの末尾に `判断記録: <記録先のpath:line>` を付ける（`review-lessons` が後で判断済みの指摘を集計できるようにするため）。
- 記録の変更は、対応する修正と同じcommitに含める。

判断済みの一覧（場所・論点・採った判断・記録先）はステップ5のPR本文で使うので保持しておく（修正subagentの最終メッセージから取得する）。

## ステップ3: commit

意味のある単位で複数のcommitに分ける。1つのcommitが1つの目的（1つの論理的な変更）に対応するようにし、無関係な変更を1つのcommitにまとめない。コミットメッセージは「なぜ」を中心に簡潔に書く。

## ステップ4: push

`git push` は権限設定上Bashから直接実行できないため、以下の形式でコマンドを提示し、ユーザー自身に `! <command>` で実行してもらう。

```
git push -u origin <branch>
```

ユーザーがpushを完了したことを確認してからステップ5に進む。

## ステップ5: Pull Requestの作成

1. PRのタイトル・本文（概要・テスト計画）を作成し（ステップ2で判断済みの割れた指摘があれば、本文に「レビューで割れた判断」節を設け、場所・論点・採った判断・記録先を1件1行で載せる）、ベースブランチとともにユーザーに提示して確認を求める。実行前確認は必須のステップとして省略しない。
2. 承認後、以下の形式で実行する。

```bash
gh pr create --base <base-branch> --title "<title>" --body "<body>"
```

1. 作成されたPRのURLをユーザーに報告する。

## ステップ5-b: レビュー指摘のルール化の提案

ステップ2のレビューで1件以上の指摘に対応した場合は、PRのURL報告と同じメッセージで「今回のレビュー指摘を `review-lessons` で横断ルールに反映しますか？」とユーザーに確認する。指摘が0件だった場合はこのステップを省略する。

承認された場合は `Skill` ツールで `review-lessons` を呼び出す。引数には今回のリポジトリに絞るための `--key-prefix <owner>/<repo>@` を渡す（`<owner>/<repo>` は `gh repo view --json nameWithOwner -q .nameWithOwner` で取得する）。候補の取捨選択とルールファイルへの書き込み前の確認は `review-lessons` 側で行われるため、ここで重ねて確認しない。

指摘を横断ルールへ反映せずに次のタスクへ進むと、実装subagentが同じ指摘を繰り返してレビューの往復が増えるため、このステップはPR作成直後（指摘の記憶が新しいうち）に行う。

## ステップ6: マージ後の後片付け

PR作成の報告後、同じ会話の中でユーザーから「マージされた」「PRがマージされたよ」などPRのマージを知らせる発言があったら、`Skill` ツールで `cleanup-worktree` スキルを呼び出す。引数には対象のブランチ名（ステップ5でPRを作成したブランチ）を渡す。起点pane_idは `cleanup-worktree` 側が `start-worktree` の記録したファイルから自動検出するため、ここで明示的に渡す必要はない。

worktree・ブランチの実削除前の確認は `cleanup-worktree` 側のステップ4で行われるため、ここで重ねて確認を取る必要はない。

## 境界

- PRのマージ自体（`gh pr merge` 等）はこのスキルでは実行しない。マージされたかどうかはユーザーからの報告のみで判断し、能動的にCIやマージ状態を確認しにいくことはしない。
- `git push --force` やコミット履歴の書き換え（rebase, amendなど）は行わない。
- 実装プランの検討・レビュー・承認は `plan-and-review` の責務であり、ここでは行わない。
- worktree自体の作成・削除、herdrワークスペースの管理は `start-worktree` / `cleanup-worktree` スキルの責務であり、実際の削除処理はステップ6で `cleanup-worktree` に委譲する。
- subagentに委譲するのは、コード変更の適用（ステップ1の実装、ステップ2手順6のレビュー指摘対応）と、手順6での未対応コメントの取得・「対応」コメントの返信のみ。critの起動判断・review-localの起動・未対応件数の確認と投稿結果の検証・commit・push案内・PR作成・後片付けの呼び出しの判断はこのスキル自身が行い、subagentには渡さない。
- コードレビュー（review-local）はHerdr環境では別ペインのclaude kind herdr agentに、非Herdr環境では内製の`Agent`ツールに委譲する。修正へ進むかどうかの判断と、修正subagentが対応しなかった指摘の扱いはこのスキル自身が行う。review-localには「対応」コメントを投稿させない。
- ユーザーの役割はcritでの差分確認・コメント追加・resolve・Finish Reviewのみ。critの起動・レビュー指摘への対応はこのスキルとsubagent/review-localのagentが行い、ユーザーに追加の操作を求めない。
- subagentにプランへの方針転換・レビュー指摘の対応範囲を超える大きな変更を無断で行わせない。プランに無い方針転換や指摘対応の範囲を超える変更が必要になった場合、subagentには作業を止めて理由を報告するよう指示しており、このスキルもその報告を検証なしにそのまま続行の判断に使わない（必ずユーザーに確認する）。
