#!/usr/bin/env bash
# tuicrセッションJSONから、過去のレビュー指摘とそれへの応答（対応/見送り/ユーザー発言）を
# 指摘単位に整理して出力する。review-localが既存のやり取りを踏まえて再指摘・反論するために使う。
# tuicrは同じ行キーのスレッドに複数の独立した指摘を積むため、review-localの新規指摘
# （`再指摘:`/`反論:` で始まらないもの）を区切りとして1スレッドを複数の指摘に分割する。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: tuicr-review-threads.sh <session_json_path> [reviewer_username] [fixer_username]

  session_json_path   `tuicr review list` の .path (セッションJSONファイルの絶対パス)
  reviewer_username   レビュー側の --username (省略時: review-local)
  fixer_username      修正側の --username (省略時: execute-plan-and-pr)

標準出力: 指摘のJSON配列。各要素:
  { scope: "review"|"file"|"line", path, line, tag, status, can_reply,
    messages: [{author, content}] }
  line: 返信時に --line に渡すスレッドキー（範囲コメントでは終了行）
  status:
    pending     最後の発言がレビュー側（修正側の応答待ち）
    addressed   修正側が「対応:」と返答
    declined    修正側が理由付きで「見送り:」と返答
    skipped_low 修正側が「2周目以降の重要度低」の定型文で見送り
    user        最後の発言がユーザー（修正側の応答待ち）
  can_reply: status が addressed/declined で、レビュー側がまだ再指摘・反論していない
USAGE
}

session_path="${1:-}"
reviewer="${2:-review-local}"
fixer="${3:-execute-plan-and-pr}"

if [[ -z "$session_path" ]]; then
  usage
  exit 1
fi

if [[ ! -f "$session_path" ]]; then
  echo "error=session file not found: $session_path" >&2
  exit 1
fi

jq --arg reviewer "$reviewer" --arg fixer "$fixer" '
  def is_reply: test("^(再指摘|反論):");

  def split_items:
    reduce .[] as $c ([];
      if length == 0 or ($c.author == $reviewer and ($c.content | is_reply | not))
      then . + [[$c]]
      else .[:-1] + [.[-1] + [$c]] end);

  def status_of($last):
    if $last.author == $reviewer then "pending"
    elif $last.author != $fixer then "user"
    elif ($last.content | test("^見送り: 2周目以降の重要度低")) then "skipped_low"
    elif ($last.content | test("^見送り:")) then "declined"
    else "addressed" end;

  def items_from(arr; $scope; $path; $line):
    (arr // []) | split_items | map(
      status_of(.[-1]) as $status
      | {
          scope: $scope, path: $path, line: $line,
          tag: ((.[0].content | capture("^(?<t>BUG|EDGE|ERR|RISK|INCONSISTENT|TEST|SEC|PERF|DOC)\\b").t) // null),
          status: $status,
          can_reply: (($status == "addressed" or $status == "declined")
            and (map(select(.author == $reviewer and (.content | is_reply))) | length) == 0),
          messages: map({author, content})
        });

  items_from(.review_comments; "review"; null; null)
  + ((.files // {}) | to_entries | map(
      .key as $path
      | items_from(.value.file_comments; "file"; $path; null)
        + ((.value.line_comments // {}) | to_entries | map(
            items_from(.value; "line"; $path; (.key | tonumber))
          ) | add // [])
    ) | add // [])
  | sort_by(.path, .line)
' "$session_path"
