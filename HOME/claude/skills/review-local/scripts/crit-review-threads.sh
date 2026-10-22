#!/usr/bin/env bash
# critセッションの未resolveのコメントを、レビューのやり取り（対応/見送り/ユーザー発言）の状態付きで出力する。
# review-localが既存のやり取りを踏まえて再指摘・反論・resolveするために使う。
# critはコメントごとに返信スレッドを持つため、1コメント = 1指摘として扱う。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: crit-review-threads.sh <session_id> [reviewer_author] [fixer_author]

  session_id       critのセッションID
  reviewer_author  レビュー側の --author。`<reviewer_author>/<agent名>` も同じレビュー側とみなす (省略時: review-local)
  fixer_author     修正側の --author (省略時: execute-plan-and-pr)

標準出力: 指摘のJSON配列。各要素:
  { id, scope: "review"|"file"|"line", path, start_line, end_line, author, tag, status, can_reply,
    messages: [{author, content}] }
  author: 指摘を書いた人（スレッド先頭の発言者）
  status:
    pending     最後の発言がレビュー側（修正側の応答待ち）
    addressed   修正側が「対応:」と返答
    declined    修正側が理由付きで「見送り:」と返答
    skipped_optional 修正側が「2周目以降のsuggest/norush」の定型文で見送り
    user        最後の発言がユーザー（修正側の応答待ち）
  can_reply: status が addressed/declined で、レビュー側がまだ再指摘・反論していない
USAGE
}

session_id="${1:-}"
reviewer="${2:-review-local}"
fixer="${3:-execute-plan-and-pr}"

if [[ -z "$session_id" ]]; then
  usage
  exit 1
fi

crit comments --session "$session_id" --json | jq --arg reviewer "$reviewer" --arg fixer "$fixer" '
  def is_reply: test("^(再指摘|反論):");
  def is_reviewer: .author == $reviewer or (.author | startswith($reviewer + "/"));

  def status_of($last):
    if ($last | is_reviewer) then "pending"
    elif $last.author != $fixer then "user"
    elif ($last.content | test("^見送り: 2周目以降のsuggest/norush")) then "skipped_optional"
    elif ($last.content | test("^見送り:")) then "declined"
    else "addressed" end;

  map(
    ([{author, content: .body}] + ((.replies // []) | map({author, content: .body}))) as $messages
    | status_of($messages[-1]) as $status
    | {
        id, scope, path, start_line, end_line, author,
        tag: ((.body | capture("^(?<t>BUG|EDGE|ERR|RISK|INCONSISTENT|TEST|SEC|PERF|DOC)\\b").t) // null),
        status: $status,
        can_reply: (($status == "addressed" or $status == "declined")
          and ($messages | map(select(is_reviewer and (.content | is_reply))) | length) == 0),
        messages: $messages
      })
'
