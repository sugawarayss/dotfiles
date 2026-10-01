#!/usr/bin/env bash
# herdr agent(--kind codex) にプロンプトを送り、そのターンが終わるまで待つ。
# herdr 0.9.2以降、codexの状態は画面ヒューリスティックのみで判定され、応答後も
# `unknown` のまま `herdr agent prompt --wait` がタイムアウトしうる。そのため完了は
# codex自身のrolloutログ（~/.codex/sessions/**/rollout-*-<session_id>.jsonl）に
# 書かれる task_complete / turn_aborted イベントで判定する。blocked だけはherdrの状態を使う。
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage: codex-turn-wait.sh <agent_name> prompt <text>
       codex-turn-wait.sh <agent_name> wait

  prompt  プロンプトを送信し、送信後に始まったターンの終了を待つ
  wait    再送せず、実行中のターンの終了を待つ（Bashツールのタイムアウト後の待ち直し用）

標準出力（最終行）: status=done | status=aborted | status=blocked
終了コード: 0=done, 2=blocked, 3=aborted, 1=エラー
USAGE
}

agent="${1:-}"
mode="${2:-}"
poll_interval_seconds=5

if [[ -z "$agent" || ( "$mode" != prompt && "$mode" != wait ) ]]; then
  usage
  exit 1
fi
if [[ "$mode" == prompt && -z "${3:-}" ]]; then
  usage
  exit 1
fi

session_startup_timeout_seconds=120
shopt -s nullglob

# codexは最初のプロンプト受信時にSessionStartフックを実行するため、それまではsession_idが無い
find_rollout_file() {
  local session_id rollout_files
  session_id="$(herdr agent get "$agent" | jq -r '.result.agent.agent_session.value // empty')"
  [[ -n "$session_id" ]] || return 1
  rollout_files=("${CODEX_HOME:-$HOME/.codex}"/sessions/*/*/*/rollout-*-"$session_id".jsonl)
  (( ${#rollout_files[@]} > 0 )) || return 1
  echo "${rollout_files[0]}"
}

wait_for_rollout_file() {
  local deadline=$((SECONDS + session_startup_timeout_seconds))
  until rollout_file="$(find_rollout_file)"; do
    if (( SECONDS >= deadline )); then
      echo "error=codex session not reported for agent: $agent" >&2
      exit 1
    fi
    sleep "$poll_interval_seconds"
  done
}

turn_events() {
  jq -r 'select(.type == "event_msg") | .payload.type
         | select(. == "task_started" or . == "task_complete" or . == "turn_aborted")' "$rollout_file"
}

finished_turn_count() {
  turn_events | awk '$0 == "task_complete" || $0 == "turn_aborted" { n++ } END { print n + 0 }'
}

last_turn_event() {
  turn_events | tail -1
}

is_blocked() {
  [[ "$(herdr agent get "$agent" | jq -r '.result.agent.agent_status')" == blocked ]]
}

report_and_exit() {
  case "$1" in
    task_complete) echo "status=done"; exit 0 ;;
    turn_aborted) echo "status=aborted"; exit 3 ;;
    *) echo "error=no codex turn found in $rollout_file" >&2; exit 1 ;;
  esac
}

if [[ "$mode" == prompt ]]; then
  baseline_count=0
  if rollout_file="$(find_rollout_file)"; then
    baseline_count="$(finished_turn_count)"
  fi
  herdr agent prompt "$agent" "$3" >/dev/null
  wait_for_rollout_file
  while (( "$(finished_turn_count)" <= baseline_count )); do
    if is_blocked; then echo "status=blocked"; exit 2; fi
    sleep "$poll_interval_seconds"
  done
  report_and_exit "$(last_turn_event)"
fi

wait_for_rollout_file
while [[ "$(last_turn_event)" == task_started ]]; do
  if is_blocked; then echo "status=blocked"; exit 2; fi
  sleep "$poll_interval_seconds"
done
report_and_exit "$(last_turn_event)"
