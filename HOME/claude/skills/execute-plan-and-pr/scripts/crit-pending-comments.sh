#!/usr/bin/env bash
# critセッションから「まだこのエージェントが応答していない未resolveのコメント」だけを抽出する。
# スレッド末尾（最後の返信、返信が無ければコメント本体）の author がエージェント名でないものを未対応とする。
# SKILL.md側でコメント全件を読み込む代わりにこれを使い、対応済みスレッドの本文をコンテキストに載せないようにする。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: crit-pending-comments.sh <session_id> [agent_author]

  session_id    critのセッションID（起動出力の `session <id>`）
  agent_author  このエージェントの --author (省略時: execute-plan-and-pr)

標準出力: 未対応コメントのJSON配列。各要素:
  { id, scope: "review"|"file"|"line", path, start_line, end_line, author, content }
  author/content はスレッド末尾の発言のもの
USAGE
}

session_id="${1:-}"
agent="${2:-execute-plan-and-pr}"

if [[ -z "$session_id" ]]; then
  usage
  exit 1
fi

crit comments --session "$session_id" --json | jq --arg agent "$agent" '
  map(. as $c
    | ((($c.replies // []) | last) // $c) as $last
    | select($last.author != $agent)
    | {id, scope, path, start_line, end_line, author: $last.author, content: $last.body})
'
