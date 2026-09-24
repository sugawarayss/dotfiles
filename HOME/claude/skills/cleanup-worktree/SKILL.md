---
name: cleanup-worktree
description: >
  ブランチ名/worktree名を起点に、gwm + herdr の worktree 後片付けワークフローを実行します。
  `gwm remove --delete-branch` によるworktree・ブランチの削除、および対応する herdr ワークスペースが
  あれば `herdr workspace close` によるクローズを、常に起点セッション（`/start-worktree` を実行した
  元セッション）へ委譲します（起点セッションが見つからない場合はユーザーに実行を依頼します）。
  ユーザーが「worktree片付けて」「<ブランチ名>のworktree消して」「cleanup-worktree」
  「/cleanup-worktree」と入力した場合に使用します。
argument-hint: "[削除対象のブランチ名またはworktree名] [起点pane_id(省略可、既定 -)]"
allowed-tools: Bash(git rev-parse:*) Bash(git branch:*) Bash(gwm *) Bash(herdr *) Bash(/Users/sugawarayss/.claude/skills/cleanup-worktree/scripts/gwm-herdr-cleanup-find.sh *)
user-invocable: true
---

`gwm` + `herdr` のworktreeワークフローにおける後片付けを行います。`/start-worktree`スキル と対になるスキルで、責務は **worktreeとherdrワークスペースの削除・クローズのみ**。実装・コミット・PRのマージ確認・リモートブランチの削除は範囲外。

**実際の削除・クローズはこのスキル自身では実行しない。** `gwm remove --delete-branch` も `herdr workspace close` も、常に起点セッション（`/start-worktree` を実行した元セッション）へ委譲する。理由は2つ: (1) `start-worktree`→`plan-and-review`→`execute-plan-and-pr`→`cleanup-worktree` が同一worktree用herdr workspace内の同一セッションで実行される設計上、このスキル実行時点のcwdは削除対象worktree自身の中にあるのが通常パターンで、`gwm remove`はカレントディレクトリの制約で必ず失敗する。(2) 削除対象のherdr workspaceも実行中セッション自身のものであることが多く、`herdr workspace close`は対象workspace配下の全terminalを閉じる実装（herdrdev/herdr `src/app/actions.rs` の `close_selected_workspace` で確認済み、自己close用の特別なガードは無い）のため、自分自身に対して呼ぶと実行中のこのシェル自体が道連れに落ちる。cwdやworkspace_idの一致判定でケースを分岐するより、常に起点セッションへ委譲する方が単純かつ安全（起点セッションはworktree作成前の別ディレクトリ・別workspaceで動いているため、上記いずれの自己参照問題も構造的に起きない）。

起点セッションのherdr pane_idは、`start-worktree` が対象worktree専用のgit管理ディレクトリにファイルとして記録したものをステップ2〜3で自動検出する。`plan-and-review`/`execute-plan-and-pr`からのプロンプト中継には依存しないため、そのskillチェーンを経由せず単独で `/cleanup-worktree <branch>` を呼んだ場合でも自動検出が働く。

**`gwm remove --delete-branch`にはunmergedブランチへの保護が無い**（実機確認済み: `wtp remove --with-branch`と違い、マージ済みかどうかに関わらず無条件で削除する。dirty worktreeも同様に無条件で削除される）。そのためステップ4の削除前確認が唯一の安全弁であり、省略できない。万一の誤削除は起点セッション側で `gwm undo`（`gwm history`に記録された直近の破壊的操作をブランチ・worktree・コミット内容ごと復元する。実機で復元成功を確認済み）で復元可能。

## 前提条件の確認

`herdr status` で `server.status` が `running` か確認する。未起動の場合、起点セッションへの委譲（`herdr agent prompt`）自体が行えないため、ステップ5〜6は常に「ユーザーに手動実行を依頼する」経路になる旨を把握しておく。

## ステップ1: 対象ブランチ/worktree名の確認

`$ARGUMENTS` の1つ目のトークンを削除対象として扱う。gitのブランチ文字列（例: `feat/#123-desc`）とgwmのworktree名（例: `feat-123-desc`）のどちらを渡しても、ステップ2〜3のスクリプトが解決する。指定が無い場合は現在のディレクトリを勝手に対象にせず、ユーザーにブランチ名/worktree名を確認する。

`$ARGUMENTS` の2つ目のトークン（起点pane_id）は明示的な上書き用の任意引数。通常は不要（ステップ2〜3で自動検出される）で、ユーザーやskillが明示的に指定してきた場合のみ控えておき、ステップ5〜6でその値を優先する。

## ステップ2〜3: 対象worktreeとherdr workspaceの特定

worktreeの存在確認（`gwm list --format json` 相当）とherdr workspaceの特定（`herdr workspace list` の走査・jqでの突き合わせ）を1回のBash呼び出しに集約している（生JSONを都度パースするとトークンを消費するため）。

```bash
/Users/sugawarayss/.claude/skills/cleanup-worktree/scripts/gwm-herdr-cleanup-find.sh <branch_or_worktree_name>
```

標準出力は `status=found|not_found` `worktree_name=` `worktree_path=` `origin_pane_id=` `herdr=ok|unavailable` `workspace_id=` `workspace_label=` のkey=value行。

- `status=not_found`: 該当するworktreeが見つからない旨を報告して終了する。
- `status=found` かつ `workspace_id` が出力されない場合: 対応するherdrワークスペースは無いものとして扱い、ステップ6はスキップする（herdr未起動時も同様）。
- `origin_pane_id`: `start-worktree` が対象worktree作成時に記録した起点pane_id（`gwm-herdr-origin-pane-id`ファイル）から自動検出された値。ステップ1で明示的な上書き引数が渡されていればそちらを優先し、無ければこの値を使う。どちらも無ければ `-` として扱う。
- `worktree_name`: **ステップ5〜6の`gwm remove`にはこの値を渡す**（ユーザーが入力したブランチ文字列そのものではなく、スクリプトが解決したgwmのworktree名。`gwm remove`はブランチ文字列にはfuzzy一致しないため）。

## ステップ4: 削除前の確認

以下をユーザーに提示し、実行してよいか確認を求める。実体を削除する不可逆操作であり、かつ`gwm remove --delete-branch`はunmergedでも無条件に削除するため、このステップは省略しない。

- worktreeのパス（`worktree_path`）とworktree名（`worktree_name`）
- 見つかった場合: herdr workspace_id とそのラベル（`workspace_id` / `workspace_label`）
- 「マージ済みかどうかに関わらず削除され、削除後の復元は起点セッションで`gwm undo`を使う必要がある」旨

## ステップ5〜6: 起点セッションへの委譲（またはユーザーへの手動依頼）

ユーザー確認後、実削除（`gwm remove --delete-branch`）とherdr workspaceのクローズ（`workspace_id` が見つかっていれば）は、このスキル自身では実行せず、常に起点セッションへの委譲、または起点セッションが無い場合のユーザーへの手動依頼のいずれかで完結させる。

`<起点pane_id>`: ステップ1の明示的な上書き引数があればそれを、無ければステップ2〜3で自動検出された`origin_pane_id`を、どちらも無ければ `-` として扱う。

**`<起点pane_id>` が `-` 以外の場合**: 以下の内容を1つのメッセージにまとめ、`herdr agent prompt <起点pane_id> "<メッセージ>"` で委譲する（`--wait` は付けないfire-and-forget。委譲の送信に成功しても、それは「起点セッションに指示が届いた」ことのみを意味し、実際の削除・close完了までは保証しない）。

メッセージに含める内容:

1. `gwm remove <worktree_name> --delete-branch` を実行する（`<worktree_name>`はステップ2〜3で解決した値。ユーザーが入力したブランチ文字列ではない）。
2. 失敗した場合の対応: dirty worktree・unmergedブランチのどちらも`gwm remove --delete-branch`は無条件で削除するため、通常はここで失敗しない。それでも失敗した場合は理由をそのままユーザーに提示し、**無断で追加フラグを付けて再実行しない**（起点セッションは対話中の実セッションなので、必要な判断はそのセッションの利用者に行わせる）。
3. `workspace_id` が見つかっていれば、1が成功したら `herdr workspace close <workspace_id>` を実行する（`workspace_id` が無ければこの手順は含めない）。

**`<起点pane_id>` が `-`（無い）場合**: 委譲先が無いため、ユーザーに別ディレクトリへ移動した上で上記1〜3を手動で実行してもらうよう依頼する（`workspace_id` が無ければ3は不要）。

`herdr worktree remove` は使わない（git worktreeの実体そのものを削除するコマンドであり、`gwm remove --delete-branch` で既に実体を削除済みのため対象を失いエラーになる。使うのは常に `herdr workspace close` のみ）。

## ステップ7: 報告

以下をユーザーに報告する。

- 起点セッションへ委譲した場合: 委譲した内容（gwm remove、および該当すればherdr workspace close）と、実際の完了は確認できていない旨。
- 起点セッションが無くユーザーに手動実行を依頼した場合: 依頼した具体的なコマンドと理由。
- 誤って削除してしまった場合は起点セッションで `gwm undo` により復元できる旨（削除完了の報告に添える）。

## 境界

- worktree・ブランチの実体削除は `gwm remove --delete-branch` にのみ任せる。`herdr worktree remove` は使わない。
- `gwm remove --delete-branch`はunmergedブランチ・dirty worktreeのどちらも無条件で削除する。この挙動を理由に確認をスキップしない（ステップ4は必須）。
- リモートブランチの削除、PRのクローズ・マージ確認は行わない。あくまでローカルのworktree・ブランチ・herdrワークスペースの片付けまで。
- `gwm remove` ・ `herdr workspace close` の実行はこのスキル自身では一切行わない。cwdが削除対象worktree内にある／削除対象workspaceが自分自身である、といった自己参照的な失敗パターンを個別に検知するのではなく、常に起点セッションへの委譲（または起点セッションが無ければユーザーへの依頼）に統一することで、これらの自己参照問題を構造的に回避する。
