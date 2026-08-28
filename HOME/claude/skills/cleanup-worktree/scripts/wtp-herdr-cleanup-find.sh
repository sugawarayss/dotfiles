#!/usr/bin/env bash
# 削除対象worktreeのパスと、対応するherdr workspace_idを1回のBash呼び出しで特定する。
# 破壊的操作(wtp remove)は行わない。結果はユーザー確認の材料として使う。
#
# あわせて、`start-worktree`（wtp-herdr-start.sh）が対象worktree専用のgit管理ディレクトリに
# 記録した起点pane_id（`wtp-herdr-origin-pane-id`ファイル）を読み出し、origin_pane_idとして
# 出力する。plan-and-review/execute-plan-and-prでの手動中継に頼らず、ブランチ名からこのスキル
# 単独で起点セッションを自動検出できるようにするため。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: wtp-herdr-cleanup-find.sh <branch>

  branch  削除対象のブランチ名

標準出力 (key=value, 1行ずつ):
  status=found|not_found
  worktree_path=<絶対パス>       (statusがfoundのときのみ)
  origin_pane_id=<id>            (start-worktreeが記録したファイルが見つかった場合のみ)
  herdr=ok|unavailable
  workspace_id=<id>              (対応するherdr workspaceが見つかった場合のみ)
  workspace_label=<label>        (同上)
USAGE
}

branch="${1:-}"
if [[ -z "$branch" ]]; then
  usage
  exit 1
fi

repo_root="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"

worktree_path=""
if ! worktree_path="$(wtp cd "$branch" 2>/dev/null)"; then
  echo "status=not_found"
  exit 0
fi

echo "status=found"
echo "worktree_path=$worktree_path"

if worktree_git_dir="$(git -C "$worktree_path" rev-parse --path-format=absolute --git-dir 2>/dev/null)"; then
  origin_pane_id_file="$worktree_git_dir/wtp-herdr-origin-pane-id"
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

match="$(herdr workspace list 2>/dev/null | jq -c --arg root "$repo_root" --arg branch "$branch" --arg path "$worktree_path" '
  [.result.workspaces[]
    | select(.worktree.repo_root == $root)
    | select(.label == $branch or .worktree.checkout_path == $path)
  ] | first // empty
')"

if [[ -n "$match" ]]; then
  echo "workspace_id=$(echo "$match" | jq -r '.workspace_id')"
  echo "workspace_label=$(echo "$match" | jq -r '.label')"
fi
