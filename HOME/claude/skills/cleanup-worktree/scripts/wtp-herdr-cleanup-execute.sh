#!/usr/bin/env bash
# ユーザー確認後の実削除を1回のBash呼び出しに集約する。
# `wtp remove --with-branch` でworktreeとブランチを削除し、workspace_idが渡されていれば
# 対応するherdr workspaceを閉じる。-f/--force-branch等の強制フラグは付与しない
# （必要な場合は呼び出し側がユーザー確認の上で追加フラグとして明示的に渡す）。
#
# 削除対象のworkspace_idが自分自身（$HERDR_WORKSPACE_ID）と一致する場合、直接のcloseは行わない。
# herdr workspace close はそのworkspace配下の全terminalを閉じる実装のため（herdrdev/herdr
# src/app/actions.rs の close_selected_workspace で確認済み）、自分自身を閉じると実行中の
# このシェル自体が道連れに落ちてしまい、closeが正常完了しない・セッションが落ちるおそれがある。
# その場合、origin_pane_id（/start-worktree を実行した起点セッションのpane_id）が渡されていれば
# `herdr agent prompt` でそのセッションにclose作業を委譲する。渡されていなければユーザーに
# 手動でのclose を依頼する旨を報告するだけに留める。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: wtp-herdr-cleanup-execute.sh <branch> <workspace_id|-> <origin_pane_id|-> [extra wtp-remove flags...]

  branch          削除対象のブランチ名
  workspace_id    wtp-herdr-cleanup-find.sh が返した workspace_id。無ければ "-"
  origin_pane_id  /start-worktree を実行した起点セッションのpane_id（skillの引数として渡されてきた
                   ものをそのまま中継する）。無ければ "-"
  extra flags     dirty worktree / 未マージブランチの再実行時のみ、ユーザー確認の上で
                  -f や --force-branch を渡す（無断で付けない）

標準出力 (key=value, 1行ずつ):
  removed=true                    (成功時。失敗時はerror行を出しexit 1)
  workspace_closed=true|false
  workspace_self=true             (削除対象workspaceが自分自身の場合のみ)
  workspace_close_delegated=true|false  (workspace_self=true かつ origin_pane_id 指定時のみ)
  error=<メッセージ>               (該当する失敗があれば追加で出力)
USAGE
}

branch="${1:-}"
workspace_id="${2:-}"
origin_pane_id="${3:-}"

if [[ -z "$branch" || -z "$workspace_id" || -z "$origin_pane_id" ]]; then
  usage
  exit 1
fi
shift 3

if ! remove_output="$(wtp remove --with-branch "$branch" "$@" 2>&1)"; then
  echo "error=wtp remove failed: $remove_output"
  exit 1
fi
echo "removed=true"

if [[ "$workspace_id" == "-" ]]; then
  echo "workspace_closed=false"
  exit 0
fi

if [[ -z "${HERDR_WORKSPACE_ID:-}" || "$workspace_id" != "$HERDR_WORKSPACE_ID" ]]; then
  if close_output="$(herdr workspace close "$workspace_id" 2>&1)"; then
    echo "workspace_closed=true"
  else
    echo "workspace_closed=false"
    echo "error=herdr workspace close failed: $close_output"
  fi
  exit 0
fi

echo "workspace_closed=false"
echo "workspace_self=true"

if [[ "$origin_pane_id" == "-" ]]; then
  echo "workspace_close_delegated=false"
  echo "error=削除対象のherdr workspace ($workspace_id) はこのコマンドを実行中のセッション自身のworkspaceのためcloseをスキップしました。委譲先(origin_pane_id)も指定されていないため、ユーザーに手動でこのペイン/ワークスペースを閉じてもらってください。"
  exit 0
fi

delegate_message="[cleanup-worktree からの自動委譲] ブランチ '${branch}' のworktree/ブランチは削除済みです。このworkspace(${workspace_id})は削除元セッション自身が動いているため自分では閉じられません。以下を実行してherdr workspaceを閉じてください: herdr workspace close ${workspace_id}"

if prompt_output="$(herdr agent prompt "$origin_pane_id" "$delegate_message" 2>&1)"; then
  echo "workspace_close_delegated=true"
else
  echo "workspace_close_delegated=false"
  echo "error=起点セッション(pane ${origin_pane_id})への委譲に失敗しました: ${prompt_output}。ユーザーに手動でこのペイン/ワークスペースを閉じてもらってください。"
fi
