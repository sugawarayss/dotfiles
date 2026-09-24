#!/usr/bin/env bash
# 削除対象worktreeのパス・gwm上のworktree名と、対応するherdr workspace_idを1回のBash呼び出しで
# 特定する。破壊的操作(gwm remove)は行わない。結果はユーザー確認の材料として使う。
#
# gwmの`gwm path`/`gwm remove`はworktree名(dashed、例: feat-123-desc)にのみfuzzy一致し、
# 実際のgitブランチ文字列(例: feat/#123-desc)には一致しない(wtpとの差異、実機確認済み)。
# そのためこのスクリプトは`gwm list --format json`を1回取得し、name/branchのどちらで
# 渡されても解決できるようにしている。
#
# あわせて、`start-worktree`（gwm-herdr-start.sh）が対象worktree専用のgit管理ディレクトリに
# 記録した起点pane_id（`gwm-herdr-origin-pane-id`ファイル）を読み出し、origin_pane_idとして
# 出力する。plan-and-review/execute-plan-and-prでの手動中継に頼らず、ブランチ名/worktree名から
# このスキル単独で起点セッションを自動検出できるようにするため。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: gwm-herdr-cleanup-find.sh <branch_or_worktree_name>

  branch_or_worktree_name  削除対象のgitブランチ名(例: feat/#123-desc)、
                            またはgwmのworktree名(例: feat-123-desc)のどちらでもよい

標準出力 (key=value, 1行ずつ):
  status=found|not_found
  worktree_name=<name>          (statusがfoundのときのみ。`gwm remove`にはこの値を渡す)
  worktree_path=<絶対パス>       (statusがfoundのときのみ)
  origin_pane_id=<id>            (start-worktreeが記録したファイルが見つかった場合のみ)
  herdr=ok|unavailable
  workspace_id=<id>              (対応するherdr workspaceが見つかった場合のみ)
  workspace_label=<label>        (同上)
USAGE
}

target="${1:-}"
if [[ -z "$target" ]]; then
  usage
  exit 1
fi

repo_root="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"

match="$(gwm list --format json 2>/dev/null | jq -c --arg t "$target" '
  ([.[] | select(.name == $t or .branch == $t)] | first) //
  ([.[] | select((.name | contains($t)) or (.branch | contains($t)))] | first) //
  empty
')"

if [[ -z "${match:-}" ]]; then
  echo "status=not_found"
  exit 0
fi

worktree_name="$(echo "$match" | jq -r '.name')"
worktree_path="$(echo "$match" | jq -r '.path')"
worktree_branch="$(echo "$match" | jq -r '.branch')"

echo "status=found"
echo "worktree_name=$worktree_name"
echo "worktree_path=$worktree_path"

if worktree_git_dir="$(git -C "$worktree_path" rev-parse --path-format=absolute --git-dir 2>/dev/null)"; then
  origin_pane_id_file="$worktree_git_dir/gwm-herdr-origin-pane-id"
  if [[ -s "$origin_pane_id_file" ]]; then
    echo "origin_pane_id=$(<"$origin_pane_id_file")"
  fi
fi

herdr_available=false
if herdr status >/dev/null 2>&1; then
  herdr_available=true
fi

if [[ "$herdr_available" != true ]]; then
  echo "herdr=unavailable"
  exit 0
fi

echo "herdr=ok"

ws_match="$(herdr workspace list 2>/dev/null | jq -c --arg root "$repo_root" --arg branch "$worktree_branch" --arg path "$worktree_path" '
  [.result.workspaces[]
    | select(.worktree.repo_root == $root)
    | select(.label == $branch or .worktree.checkout_path == $path)
  ] | first // empty
')"

if [[ -n "$ws_match" ]]; then
  echo "workspace_id=$(echo "$ws_match" | jq -r '.workspace_id')"
  echo "workspace_label=$(echo "$ws_match" | jq -r '.label')"
fi
