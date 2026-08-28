#!/usr/bin/env bash
# tuicrセッションJSONから「まだこのエージェントが応答していないコメントスレッド」だけを抽出する。
# 各スレッド（review_comments / file_comments / line_comments の各キー配列）は
# 「最後のコメントの author がエージェント名でない」場合のみ未対応として出力する。
# SKILL.md側で `Read` によりセッションJSON全体を読み込む代わりにこれを使うことで、
# 対応済みスレッドの再読み込みと全コメント（diff情報等を含む）の読み込みを避ける。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: tuicr-pending-comments.sh <session_json_path> [agent_username]

  session_json_path  `tuicr review list` の .path (セッションJSONファイルの絶対パス)
  agent_username      このエージェントの --username (省略時: execute-plan-and-pr)

標準出力: 未対応コメントスレッドのJSON配列。各要素:
  { scope: "review"|"file"|"line", path, line, author, lifecycle_state, content }
USAGE
}

session_path="${1:-}"
agent="${2:-execute-plan-and-pr}"

if [[ -z "$session_path" ]]; then
  usage
  exit 1
fi

if [[ ! -f "$session_path" ]]; then
  echo "error=session file not found: $session_path" >&2
  exit 1
fi

jq --arg agent "$agent" '
  def pending_from(arr; scope; path; line):
    (arr // []) as $t
    | if ($t | length) > 0 and ($t[-1].author != $agent)
      then [{scope: scope, path: path, line: line, author: $t[-1].author,
             lifecycle_state: $t[-1].lifecycle_state, content: $t[-1].content}]
      else [] end;

  (pending_from(.review_comments; "review"; null; null)) as $review_pending
  | ((.files // {}) | to_entries | map(
      .key as $path
      | .value as $f
      | pending_from($f.file_comments; "file"; $path; null)
        + (($f.line_comments // {}) | to_entries | map(
            pending_from(.value; "line"; $path; (.key | tonumber))
          ) | add // [])
    ) | add // []) as $file_pending
  | ($review_pending + $file_pending)
  | sort_by(.path, .line)
' "$session_path"
