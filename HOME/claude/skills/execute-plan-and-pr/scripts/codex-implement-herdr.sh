#!/usr/bin/env bash
# 承認済み実装プランに基づく実装作業を、herdrの別ペインで `codex exec` に委譲する。
# tuicr-wrapper-herdr.sh と同じ設計（別ペインで起動 -> 完了トークンをpane出力で待つ -> pane close）を踏襲する。
# 実装作業そのものはcodexに任せ、このClaudeセッションはブロッキングで完了を待つだけにする。
set -euo pipefail

CODEX_IMPLEMENT_PANE_DIRECTION="${CODEX_IMPLEMENT_PANE_DIRECTION:-right}"
HERDR_BIN="${HERDR_BIN:-herdr}"
JQ_BIN="${JQ_BIN:-jq}"
CODEX_BIN="${CODEX_BIN:-codex}"

usage() {
  cat <<'USAGE' >&2
Usage: codex-implement-herdr.sh <worktree_path> <plan_path>

  worktree_path  実装対象のworktreeの絶対パス
  plan_path      承認済み実装プランファイルの絶対パス

標準出力 (key=value を1行ずつ、エラー時のみ error 行を追加):
  status=ok|error
  exit_code=<終了コード>         (status=ok のときはcodexの終了コード0。status=error のときはcodexが異常終了したコード、
                                  またはcodexを起動できなかった場合は1)
  last_message_path=<絶対パス>  (status=ok のときのみ。codexの最終メッセージを書き出した一時ファイル)
  error=<メッセージ>            (status=error のときのみ。呼び出し側は必ず status=error と error= の対で失敗を検知できる)
USAGE
}

# 呼び出し側が status=error / error= の対だけを見て失敗を判定できるよう、
# 失敗するすべてのパス（事前条件チェックだけでなく herdr/jq コマンドの失敗も含む）をここに集約する。
# exit_code もここで必ず出力し、status=error のときに exit_code が欠落するパスを作らない。
fail() {
  echo "status=error"
  echo "exit_code=1"
  echo "error=$1"
  exit 1
}

require_command() {
  local command_name="$1"
  local display_name="$2"
  command -v "$command_name" &>/dev/null || fail "$display_name not found on PATH"
}

worktree_path="${1:-}"
plan_path="${2:-}"

if [[ -z "$worktree_path" || -z "$plan_path" ]]; then
  usage
  fail "worktree_path and plan_path are required"
fi

if [[ "${HERDR_ENV:-}" != "1" ]]; then
  fail "not running inside a Herdr-managed pane"
fi

require_command "$HERDR_BIN" "Herdr"
require_command "$JQ_BIN" "jq"
require_command "$CODEX_BIN" "Codex CLI"

if [[ ! -d "$worktree_path" ]]; then
  fail "worktree directory not found: $worktree_path"
fi
if [[ ! -f "$plan_path" ]]; then
  fail "plan file not found: $plan_path"
fi
worktree_path=$(cd "$worktree_path" && pwd) || fail "failed to resolve worktree path: $worktree_path"

case "$CODEX_IMPLEMENT_PANE_DIRECTION" in
  right|down) ;;
  *) CODEX_IMPLEMENT_PANE_DIRECTION="right" ;;
esac

last_message_file=$(mktemp -t codex-implement-last-message) || fail "failed to create temp file for codex output"

new_pane_id=""
cleanup() {
  local status=$?
  if [[ -n "$new_pane_id" ]]; then
    "$HERDR_BIN" pane close "$new_pane_id" >/dev/null 2>&1 || true
  fi
  return "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

split_response=$("$HERDR_BIN" pane split --current \
  --direction "$CODEX_IMPLEMENT_PANE_DIRECTION" \
  --cwd "$worktree_path" \
  --focus) || fail "herdr pane split failed"

new_pane_id=$(printf '%s\n' "$split_response" | "$JQ_BIN" -er '.result.pane.pane_id') || \
  fail "failed to parse pane_id from herdr pane split output"

prompt=$(cat <<EOF
承認済みの実装プラン（${plan_path}）の内容に従って、このリポジトリで実装してください。

担当範囲（厳守）:
- 行うのは実装（コード変更）と、その動作確認・テストの実行までです。
- git commit、git push、Pull Requestの作成、tuicr等によるレビューの実施、worktree/ブランチの削除といった後続作業は一切行わないでください。それらはこのCodexセッションを呼び出した側（Claude）が別途担当します。

プロジェクト規約:
- このリポジトリ内に `AGENTS.md` や `CLAUDE.md` など実装ルールを記述したファイルがあれば、その内容に従ってください（あなたは非対話実行のため、これらのファイルを自分で探して読む必要があります）。
- 実装後、プロジェクトのテスト・lintなど検証コマンドが分かる場合は実行し、結果を最終メッセージに含めてください。分からない場合は無理に探さなくて構いません。

制約:
- プランに書かれていない大きな方針転換が必要だと判断した場合は、実装を進めず作業を止め、最終メッセージでその理由を明確に報告してください。方針転換をあなたの判断で実施しないでください。
- 実装が完了したら、変更したファイルの一覧と実施内容の要約を最終メッセージに含めてください。
EOF
)

codex_cmd=("$CODEX_BIN" exec -C "$worktree_path" -s workspace-write --output-last-message "$last_message_file" "$prompt")

quoted_codex=""
for arg in "${codex_cmd[@]}"; do
  printf -v quoted_arg '%q' "$arg"
  quoted_codex="$quoted_codex $quoted_arg"
done

completion_suffix="_DONE_$$_${RANDOM}__"
completion_token="__CODEXIMPL${completion_suffix}"
# tuicr-wrapper-herdr.sh と同じ理由で bash -c にラップする:
# `herdr pane run` はpaneの対話シェル（fishの場合もある）にコマンド文字列をそのまま流し込むため、
# bashのprintf %q が生成する引用符（$'...' 等）がfish/zshで構文エラーになりうる。
# 単一引用符の意味論はbash/zsh/fishで共通なので、シングルクオートで囲んだ1引数だけを渡す。
pane_command="bash -c '$quoted_codex; printf \"\\n__CODEXIMPL%s:%s\\n\" $completion_suffix \$?'"

"$HERDR_BIN" pane run "$new_pane_id" "$pane_command" >/dev/null || fail "herdr pane run failed"

wait_response=$("$HERDR_BIN" pane wait-output "$new_pane_id" \
  --match "$completion_token" \
  --source recent-unwrapped) || fail "herdr pane wait-output failed"

matched_line=$(printf '%s\n' "$wait_response" | "$JQ_BIN" -er '.result.matched_line') || \
  fail "failed to parse matched_line from herdr pane wait-output"

codex_status="${matched_line##*:}"
if [[ ! "$codex_status" =~ ^[0-9]+$ ]]; then
  fail "could not read codex exit status from Herdr output"
fi

if [[ "$codex_status" -eq 0 ]]; then
  echo "status=ok"
  echo "exit_code=0"
  echo "last_message_path=$last_message_file"
else
  echo "status=error"
  echo "exit_code=$codex_status"
  if [[ -s "$last_message_file" ]]; then
    echo "last_message_path=$last_message_file"
  fi
  echo "error=codex exec exited with status $codex_status"
  exit 1
fi
