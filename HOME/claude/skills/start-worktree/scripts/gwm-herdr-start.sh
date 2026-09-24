#!/usr/bin/env bash
# gwm + herdr worktree ワークフロー (base branch同期 + 既存worktreeの確認/新規作成 +
# herdrワークスペースの発見 + 新規時のみエージェント起動) を1回のBash呼び出しに集約し、
# 後続処理に必要な情報だけを key=value 形式で出力する。
# リポジトリルート (メインworktree) をカレントディレクトリにして実行すること。
#
# gwmのbootstrap (.gwm.tomlの[[hooks.post_create]]) がherdr worktree openを自動実行する設計
# (ユーザーのgwm設定で確認済み) のため、このスクリプト自身はherdrを開かない (二重オープン回避)。
# gwm create完了後に`herdr workspace list`→`herdr pane list --workspace <id>`で、既に開かれて
# いるworkspace/paneを発見するだけに留める。
#
# origin_pane_id (このスキルを実行しているセッション自身のherdr pane_id、$HERDR_PANE_ID) は、
# worktree専用のgit管理ディレクトリ (`git -C <worktree_path> rev-parse --git-dir`) 配下に
# `gwm-herdr-origin-pane-id` というファイルとして書き込む。`plan-and-review`/`execute-plan-and-pr`の
# プロンプト文字列で手動中継する必要をなくし、`cleanup-worktree`がブランチ名/worktree名から直接
# 自動検出できるようにするため（`gwm remove`実行時にgitがこのディレクトリごと削除するのでゴミも残らない）。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: gwm-herdr-start.sh <source_type> <ref> <extra> <origin_pane_id|-> [<agent_name> [<prompt>]]

  source_type     "issue" または "task"
  ref             source_type=issue: GitHub issue番号 (数字のみ)
                  source_type=task:  ClickUpタスクID
  extra           source_type=issue: フォールバック用のtype (feat/fix/hotfix/docs/test/refactor/chore/perf/ci/build)。
                                      まず type 無しで `gwm create --issue` を試し、
                                      それが失敗した場合のみこの値で `--type` を付けてリトライする
                  source_type=task:  ブランチ/worktree名に使うslug (例: improve-checkout-flow)
  origin_pane_id  このスキルを実行しているセッション自身のherdr pane_id ($HERDR_PANE_ID)。
                  無ければ "-"。worktree専用のgit管理ディレクトリにファイルとして記録する
  agent_name      新規作成時のみ使用: herdr agent start に渡す名前。省略時はエージェント起動をスキップする。
                  herdrの制約 (小文字英数字・'-'・'_'のみ、1-32文字) に合わせて、このスクリプトが
                  小文字化・32文字への切り詰め・末尾ハイフン除去を自動で行う (呼び出し側で切り詰め不要)
  prompt          新規作成時のみ使用: herdr agent prompt に渡す文字列。省略時は送信をスキップする

標準出力 (key=value を1行ずつ、エラー時のみ error 行を追加):
  status=reused|created
  worktree_path=<絶対パス>
  worktree_name=<gwmのworktree名>    (cleanup-worktree / gwm remove にはこちらを渡す)
  origin_pane_id_recorded=true|false (origin_pane_idが"-"でなく、ファイルへの記録に成功した場合のみtrue)
  herdr=ok|unavailable
  workspace_id=<id>          (herdr=ok のときのみ)
  pane_id=<id>                (herdr=ok かつpane情報が取得できたときのみ)
  agent_started=true|false    (status=created のときのみ出力)
  prompt_sent=true|false      (status=created のときのみ出力)
  error=<メッセージ>          (該当する失敗があれば追加で出力。致命的な失敗は exit 1)
USAGE
}

source_type="${1:-}"
ref="${2:-}"
extra="${3:-}"
origin_pane_id="${4:-}"
agent_name="${5:-}"
prompt="${6:-}"

if [[ -z "$source_type" || -z "$ref" || -z "$origin_pane_id" ]]; then
  usage
  exit 1
fi

if [[ "$source_type" != "issue" && "$source_type" != "task" ]]; then
  echo "error=source_typeはissueまたはtaskを指定してください: $source_type"
  exit 1
fi

if [[ -n "$agent_name" ]]; then
  agent_name="$(printf '%s' "$agent_name" | tr '[:upper:]' '[:lower:]' | cut -c1-32)"
  agent_name="${agent_name%-}"
fi

repo_root="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"

find_by_issue() {
  gwm list --format json 2>/dev/null | jq -c --argjson n "$1" '[.[] | select(.issue == $n)] | first // empty'
}

find_by_name() {
  gwm list --format json 2>/dev/null | jq -c --arg t "$1" '[.[] | select(.name == $t or .branch == $t)] | first // empty'
}

# --- base branch決定 + 同期 -------------------------------------------------
if [[ "$source_type" == "issue" && "$extra" == "hotfix" ]]; then
  base="$(git -C "$repo_root" symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null | sed 's#^origin/##')"
  if [[ -z "$base" ]]; then
    echo "error=デフォルトブランチを検出できませんでした(hotfixのbaseに必要)"
    exit 1
  fi
else
  base="develop"
  if ! git -C "$repo_root" show-ref --verify --quiet "refs/remotes/origin/$base" \
     && ! git -C "$repo_root" show-ref --verify --quiet "refs/heads/$base"; then
    echo "error=developブランチが見つかりません。SKILL.md側で事前にbaseを確認してください"
    exit 1
  fi
fi

current_branch="$(git -C "$repo_root" symbolic-ref --short HEAD 2>/dev/null || true)"
if [[ "$current_branch" != "$base" ]]; then
  if [[ -n "$(git -C "$repo_root" status --porcelain)" ]]; then
    echo "error=mainリポジトリのworking treeが汚れているため${base}へ切り替えられません。ユーザーに確認してください"
    exit 1
  fi
  if ! fetch_output="$(git -C "$repo_root" fetch origin "$base" 2>&1)"; then
    echo "error=git fetch origin ${base} に失敗しました: $fetch_output"
    exit 1
  fi
  if ! checkout_output="$(git -C "$repo_root" checkout "$base" 2>&1)"; then
    echo "error=git checkout ${base} に失敗しました: $checkout_output"
    exit 1
  fi
  if ! merge_output="$(git -C "$repo_root" merge --ff-only "origin/$base" 2>&1)"; then
    echo "error=git merge --ff-only origin/${base} に失敗しました(fast-forward不可): $merge_output"
    exit 1
  fi
fi

# --- 既存worktreeの確認 (reuse) ---------------------------------------------
status=""
worktree_path=""
worktree_name=""
worktree_branch=""
create_warning=""

if [[ "$source_type" == "issue" ]]; then
  existing="$(find_by_issue "$ref")"
else
  existing="$(find_by_name "task-${ref}-${extra}")"
fi

if [[ -n "${existing:-}" ]]; then
  status="reused"
  worktree_path="$(echo "$existing" | jq -r '.path')"
  worktree_name="$(echo "$existing" | jq -r '.name')"
  worktree_branch="$(echo "$existing" | jq -r '.branch')"
else
  # --- 新規作成 ---------------------------------------------------------
  # gwm createが非ゼロ終了しても、無関係なpost_createフック(例: mise setup)の失敗で
  # worktree自体は既に作成済みというケースがあるため、終了コードだけで判定せず
  # 必ず`gwm list`で実在を確認してから成否を決める。
  create_output=""
  if [[ "$source_type" == "issue" ]]; then
    if ! create_output="$(gwm create --issue "$ref" --allow-bootstrap 2>&1)"; then
      new_entry="$(find_by_issue "$ref")"
      if [[ -z "${new_entry:-}" ]]; then
        # type無しで失敗 → フォールバックのtypeを付けてリトライ
        retry_output=""
        if ! retry_output="$(gwm create --issue "$ref" --type "$extra" --allow-bootstrap 2>&1)"; then
          new_entry="$(find_by_issue "$ref")"
          if [[ -z "${new_entry:-}" ]]; then
            echo "error=gwm create --issue $ref failed (type無し): $create_output / (--type $extra): $retry_output"
            exit 1
          fi
        else
          new_entry="$(find_by_issue "$ref")"
        fi
      fi
    else
      new_entry="$(find_by_issue "$ref")"
    fi
  else
    if ! create_output="$(gwm create --name "task-${ref}-${extra}" --allow-bootstrap 2>&1)"; then
      new_entry="$(find_by_name "task-${ref}-${extra}")"
      if [[ -z "${new_entry:-}" ]]; then
        echo "error=gwm create --name task-${ref}-${extra} failed: $create_output"
        exit 1
      fi
    else
      new_entry="$(find_by_name "task-${ref}-${extra}")"
    fi
  fi

  if [[ -z "${new_entry:-}" ]]; then
    echo "error=gwm create後にworktreeを特定できませんでした: $create_output"
    exit 1
  fi

  status="created"
  worktree_path="$(echo "$new_entry" | jq -r '.path')"
  worktree_name="$(echo "$new_entry" | jq -r '.name')"
  worktree_branch="$(echo "$new_entry" | jq -r '.branch')"
fi

echo "status=$status"
echo "worktree_path=$worktree_path"
echo "worktree_name=$worktree_name"

origin_pane_id_recorded=false
if [[ "$origin_pane_id" != "-" ]]; then
  if worktree_git_dir="$(git -C "$worktree_path" rev-parse --path-format=absolute --git-dir 2>/dev/null)"; then
    if printf '%s' "$origin_pane_id" > "$worktree_git_dir/gwm-herdr-origin-pane-id" 2>/dev/null; then
      origin_pane_id_recorded=true
    fi
  fi
fi
echo "origin_pane_id_recorded=$origin_pane_id_recorded"

# --- herdr workspace/paneの発見 (自分では開かない、gwmのpost_createフックに任せる) ------
workspace_id=""
pane_id=""

herdr_available=false
if herdr status >/dev/null 2>&1; then
  herdr_available=true
fi

if [[ "$herdr_available" == true ]]; then
  ws_match="$(herdr workspace list 2>/dev/null | jq -c --arg root "$repo_root" --arg branch "$worktree_branch" --arg path "$worktree_path" '
    [.result.workspaces[]
      | select(.worktree.repo_root == $root)
      | select(.label == $branch or .worktree.checkout_path == $path)
    ] | first // empty
  ')"
  if [[ -n "$ws_match" ]]; then
    workspace_id="$(echo "$ws_match" | jq -r '.workspace_id // empty')"
    echo "herdr=ok"
    echo "workspace_id=$workspace_id"
    if [[ -n "$workspace_id" ]]; then
      pane_id="$(herdr pane list --workspace "$workspace_id" 2>/dev/null | jq -r --arg path "$worktree_path" '
        (.result.panes[] | select(.cwd == $path) | .pane_id) // (.result.panes[0].pane_id // empty)
      ' | head -n1)"
      [[ -n "$pane_id" ]] && echo "pane_id=$pane_id"
    fi
  else
    echo "herdr=unavailable"
    echo "error=gwmのpost_createフックによるherdr worktree openがまだ反映されていないか失敗しています。gwm bootstrap ${worktree_path} で手動再実行するか、herdr worktree open --path ${worktree_path} を確認してください"
  fi
else
  echo "herdr=unavailable"
fi

if [[ "$status" == "created" ]]; then
  agent_started=false
  prompt_sent=false

  if [[ -n "$pane_id" && -n "$agent_name" ]]; then
    # claude起動がnonoサンドボックス経由になっており、デフォルトの30秒では
    # agent_not_readyになりうるため、herdr agent startの最大値(300000ms=5分)を指定する。
    if start_result="$(herdr agent start "$agent_name" --kind claude --pane "$pane_id" --timeout 300000 2>&1)"; then
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
