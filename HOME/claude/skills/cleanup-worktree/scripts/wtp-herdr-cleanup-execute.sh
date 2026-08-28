#!/usr/bin/env bash
# ユーザー確認後の実削除を1回のBash呼び出しに集約する。
# `wtp remove --with-branch` でworktreeとブランチを削除し、workspace_idが渡されていれば
# 対応するherdr workspaceを閉じる。-f/--force-branch等の強制フラグは付与しない
# （必要な場合は呼び出し側がユーザー確認の上で追加フラグとして明示的に渡す）。
#
# 実行中のシェルのカレントディレクトリが削除対象worktree自身の中にある場合、
# `wtp remove` は "cannot remove worktree while you are currently inside it" で失敗する。
# このスクリプトはherdrのworkspace_idに関わらず（=自分自身のworkspaceかどうかを問わず）cwdを
# 事前チェックし、該当する場合は`wtp remove`を試みずに、wtp remove + herdr workspace close の
# 両方をorigin_pane_id（/start-worktree を実行した起点セッションのpane_id）に一括委譲する。
# origin_pane_idが無ければユーザーに手動対応（別ディレクトリへ移動後に再実行）を依頼する旨を
# 報告するだけに留める。
#
# 加えて、cwdは対象worktree外だが削除対象のworkspace_idが自分自身（$HERDR_WORKSPACE_ID）と
# 一致するケース（例: 同一workspace内の別paneから実行した場合）にも備え、`wtp remove`成功後の
# herdr workspace close 側でも同様の自己close回避チェックを行う。herdr workspace close は
# そのworkspace配下の全terminalを閉じる実装のため（herdrdev/herdr src/app/actions.rs の
# close_selected_workspace で確認済み）、自分自身を閉じると実行中のこのシェル自体が道連れに
# 落ちてしまい、closeが正常完了しない・セッションが落ちるおそれがある。
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
  cwd_blocks_remove=true          (cwdが削除対象worktree内にあり、wtp removeを直接実行できない場合のみ)
  remove_delegated=true|false     (cwd_blocks_remove=trueの場合のみ。委譲の送信可否)
  removed=true                    (このプロセスで実際にwtp removeを完了できた場合のみ。失敗/委譲時はfalseまたは省略しexit 1)
  removed=false                   (cwd_blocks_remove=true、またはwtp remove自体が失敗した場合)
  workspace_closed=true|false
  workspace_self=true             (削除対象workspaceが自分自身の場合のみ。cwd_blocks_remove=trueの場合は出力しない)
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

# `wtp cd` はパスを出力するだけの非破壊コマンド。対象worktreeの実パスを取得し、
# 実行中シェルのcwdがその配下にあるかどうかを事前に判定する。
target_path=""
target_path="$(wtp cd "$branch" 2>/dev/null || true)"

cwd_blocks_remove=false
if [[ -n "$target_path" ]]; then
  target_real="$(cd "$target_path" 2>/dev/null && pwd -P || printf '%s' "$target_path")"
  current_real="$(pwd -P)"
  case "$current_real" in
    "$target_real"|"$target_real"/*)
      cwd_blocks_remove=true
      ;;
  esac
fi

if [[ "$cwd_blocks_remove" == true ]]; then
  echo "cwd_blocks_remove=true"
  echo "removed=false"

  if [[ "$origin_pane_id" == "-" ]]; then
    echo "remove_delegated=false"
    echo "error=このコマンドを実行中のセッション自身が削除対象worktree (${target_path}) の中で動いているため、'wtp remove' をカレントディレクトリの制約で実行できません。起点pane_idも指定されていないため、ユーザーに別のディレクトリへ移動してから手動で 'wtp remove --with-branch ${branch}' を実行してもらう必要があります。"
    exit 1
  fi

  workspace_close_hint=""
  if [[ "$workspace_id" != "-" ]]; then
    workspace_close_hint=" 2) 成功したら herdr workspace close ${workspace_id} でworkspaceを閉じる"
  fi
  delegate_message="[cleanup-worktree からの自動委譲] ブランチ '${branch}' のworktree後片付けをお願いします。このコマンドを実行中のセッション自身がそのworktree (${target_path}) 内で動いているため、'wtp remove' がカレントディレクトリの制約で実行できません。以下を実行してください: 1) wtp remove --with-branch ${branch}${workspace_close_hint}"

  if prompt_output="$(herdr agent prompt "$origin_pane_id" "$delegate_message" 2>&1)"; then
    echo "remove_delegated=true"
    echo "workspace_closed=false"
  else
    echo "remove_delegated=false"
    echo "error=起点セッション(pane ${origin_pane_id})への委譲に失敗しました: ${prompt_output}。ユーザーに手動での対応を依頼してください。"
    exit 1
  fi
  exit 0
fi

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
