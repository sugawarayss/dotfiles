#!/usr/bin/env bash
# wtp + herdr worktree ワークフロー (既存worktreeの確認/新規作成 + herdrワークスペースを開く + 新規時のみエージェント起動)
# を1回のBash呼び出しに集約し、後続処理に必要な情報だけを key=value 形式で出力する。
# リポジトリルート (メインworktree) をカレントディレクトリにして実行すること。
#
# origin_pane_id (このスキルを実行しているセッション自身のherdr pane_id、$HERDR_PANE_ID) は、
# worktree専用のgit管理ディレクトリ (`git -C <worktree_path> rev-parse --git-dir`) 配下に
# `wtp-herdr-origin-pane-id` というファイルとして書き込む。`plan-and-review`/`execute-plan-and-pr`の
# プロンプト文字列で手動中継する必要をなくし、`cleanup-worktree`がブランチ名から直接自動検出できる
# ようにするため（`wtp remove`実行時にgitがこのディレクトリごと削除するのでゴミも残らない）。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: wtp-herdr-start.sh <branch> <base> <origin_pane_id|-> [<agent_name> [<prompt>]]

  branch          作成/再利用するブランチ名 (例: issue/123-fix-login-bug)
  base            新規作成時のベースブランチ (例: develop)。既存worktree再利用時は無視される
  origin_pane_id  このスキルを実行しているセッション自身のherdr pane_id ($HERDR_PANE_ID)。
                  無ければ "-"。worktree専用のgit管理ディレクトリにファイルとして記録する
  agent_name      新規作成時のみ使用: herdr agent start に渡す名前。省略時はエージェント起動をスキップする
  prompt          新規作成時のみ使用: herdr agent prompt に渡す文字列。省略時は送信をスキップする

標準出力 (key=value を1行ずつ、エラー時のみ error 行を追加):
  status=reused|created
  worktree_path=<絶対パス>
  origin_pane_id_recorded=true|false (origin_pane_idが"-"でなく、ファイルへの記録に成功した場合のみtrue)
  herdr=ok|unavailable|error
  workspace_id=<id>          (herdr=ok のときのみ)
  pane_id=<id>                (herdr=ok かつ root_pane が取得できたときのみ)
  agent_started=true|false    (status=created のときのみ出力)
  prompt_sent=true|false      (status=created のときのみ出力)
  error=<メッセージ>          (該当する失敗があれば追加で出力。致命的な失敗は exit 1)
USAGE
}

branch="${1:-}"
base="${2:-}"
origin_pane_id="${3:-}"
agent_name="${4:-}"
prompt="${5:-}"

if [[ -z "$branch" || -z "$base" || -z "$origin_pane_id" ]]; then
  usage
  exit 1
fi

repo_root="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"

herdr_available=false
if herdr status >/dev/null 2>&1; then
  herdr_available=true
fi

status=""
worktree_path=""

if worktree_path="$(wtp cd "$branch" 2>/dev/null)"; then
  status="reused"
else
  add_output=""
  if ! add_output="$(wtp add -b "$branch" "$base" 2>&1)"; then
    echo "error=wtp add failed: $add_output"
    exit 1
  fi
  if ! worktree_path="$(wtp cd "$branch" 2>/dev/null)"; then
    echo "error=wtp add後にworktreeパスを特定できませんでした: $add_output"
    exit 1
  fi
  status="created"
fi

echo "status=$status"
echo "worktree_path=$worktree_path"

origin_pane_id_recorded=false
if [[ "$origin_pane_id" != "-" ]]; then
  if worktree_git_dir="$(git -C "$worktree_path" rev-parse --path-format=absolute --git-dir 2>/dev/null)"; then
    if printf '%s' "$origin_pane_id" > "$worktree_git_dir/wtp-herdr-origin-pane-id" 2>/dev/null; then
      origin_pane_id_recorded=true
    fi
  fi
fi
echo "origin_pane_id_recorded=$origin_pane_id_recorded"

workspace_id=""
pane_id=""

if [[ "$herdr_available" == true ]]; then
  open_result="$(herdr worktree open --cwd "$repo_root" --path "$worktree_path" --label "$branch" --no-focus 2>&1)" || true
  if echo "$open_result" | jq -e '.result.type == "worktree_opened"' >/dev/null 2>&1; then
    workspace_id="$(echo "$open_result" | jq -r '.result.workspace.workspace_id // empty')"
    pane_id="$(echo "$open_result" | jq -r '.result.root_pane.pane_id // empty')"
    echo "herdr=ok"
    [[ -n "$workspace_id" ]] && echo "workspace_id=$workspace_id"
    [[ -n "$pane_id" ]] && echo "pane_id=$pane_id"
  else
    echo "herdr=error"
    echo "error=herdr worktree open failed: $open_result"
  fi
else
  echo "herdr=unavailable"
fi

if [[ "$status" == "created" ]]; then
  agent_started=false
  prompt_sent=false

  if [[ -n "$pane_id" && -n "$agent_name" ]]; then
    if start_result="$(herdr agent start "$agent_name" --kind claude --pane "$pane_id" 2>&1)"; then
      agent_started=true
      if [[ -n "$prompt" ]]; then
        if prompt_result="$(herdr agent prompt "$pane_id" "$prompt" 2>&1)"; then
          prompt_sent=true
        else
          echo "error=herdr agent prompt failed: $prompt_result"
        fi
      fi
    else
      echo "error=herdr agent start failed: $start_result"
    fi
  fi

  echo "agent_started=$agent_started"
  echo "prompt_sent=$prompt_sent"
fi
