#!/usr/bin/env python3
"""critのレビューファイル(~/.crit/reviews/*/review.json)から、未処理の指摘コメントを抽出する。

状態ファイル(デフォルト: ~/.config/review-lessons/state.json)に記録された
セッションごとの watermark (最後に処理したコメントの created_at) より新しい
コメントだけを候補として出力する。状態ファイルに無いセッションは全履歴が対象になる。
session_key は `<owner>/<repo>@<branch>#<review id>`（remoteが取れなければ owner/repo の代わりに cwd）。

Usage:
  extract_comments.py                          候補をJSONで標準出力
  extract_comments.py --commit-watermarks -     標準入力のJSON({session_key: iso timestamp})を
                                                 状態ファイルへ(既存値とのmaxを取って)マージ保存
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

DEFAULT_REVIEWS_DIR = Path.home() / ".crit/reviews"
DEFAULT_STATE_PATH = Path.home() / ".config/review-lessons/state.json"

# 修正側の「対応:」「見送り:」返信と、/crit でエージェントが返す対応報告は
# 指摘そのものではないので候補から除外する。
EXCLUDED_AUTHORS = {"execute-plan-and-pr", "Claude Code"}

# review-local が resolve 時に残す「確認: ...」は決着の記録で、指摘ではない。
EXCLUDED_BODY_PREFIXES = ("確認:",)

REMOTE_PATTERN = re.compile(r"[:/]([^/:]+/[^/]+?)(?:\.git)?$")


def load_state(path: Path) -> dict:
    if path.exists():
        return json.loads(path.read_text())
    return {}


def repo_name(cwd: str) -> str:
    if not cwd:
        return "unknown"
    try:
        url = subprocess.run(
            ["git", "-C", cwd, "remote", "get-url", "origin"],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError, NotADirectoryError):
        return cwd
    match = REMOTE_PATTERN.search(url)
    return match.group(1) if match else cwd


def extract_from_session(data: dict, session_key: str, watermark: str):
    repo_path = data.get("cwd")
    branch_name = data.get("branch")
    candidates = []
    max_seen = watermark

    def consider(comment: dict, file_path, line):
        nonlocal max_seen
        author = comment.get("author") or ""
        created_at = comment.get("created_at") or ""
        body = comment.get("body", "")
        if author in EXCLUDED_AUTHORS or body.startswith(EXCLUDED_BODY_PREFIXES):
            return
        if watermark and created_at <= watermark:
            return
        if created_at > max_seen:
            max_seen = created_at
        candidates.append(
            {
                "session_key": session_key,
                "repo_path": repo_path,
                "branch_name": branch_name,
                "file": file_path,
                "line": line,
                "author": author,
                "content": body,
                "created_at": created_at,
                "comment_id": comment.get("id"),
            }
        )

    def consider_thread(comment: dict, file_path, line):
        consider(comment, file_path, line)
        for reply in comment.get("replies") or []:
            consider(reply, file_path, line)

    for c in data.get("review_comments", []) or []:
        consider_thread(c, None, None)

    for file_path, finfo in (data.get("files") or {}).items():
        for c in finfo.get("comments", []) or []:
            consider_thread(c, file_path, c.get("start_line") or None)

    return candidates, max_seen


def cmd_extract(args):
    reviews_dir = Path(args.reviews_dir)
    state_path = Path(args.state)
    state = load_state(state_path)

    all_candidates = []
    suggested_watermarks = {}
    sessions_scanned = 0

    for review_file in sorted(reviews_dir.glob("*/review.json")):
        data = json.loads(review_file.read_text())
        session_key = f"{repo_name(data.get('cwd', ''))}@{data.get('branch', '')}#{review_file.parent.name}"
        if args.key_prefix and not any(session_key.startswith(p) for p in args.key_prefix):
            continue

        sessions_scanned += 1
        watermark = state.get(session_key, "")
        candidates, max_seen = extract_from_session(data, session_key, watermark)
        all_candidates.extend(candidates)
        if max_seen and max_seen != watermark:
            suggested_watermarks[session_key] = max_seen

    all_candidates.sort(key=lambda c: c["created_at"])

    result = {
        "sessions_scanned": sessions_scanned,
        "candidate_count": len(all_candidates),
        "candidates": all_candidates,
        "suggested_watermarks": suggested_watermarks,
        "state_path": str(state_path),
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


def cmd_commit(args):
    state_path = Path(args.state)
    if args.commit_watermarks == "-":
        new_watermarks = json.loads(sys.stdin.read())
    else:
        new_watermarks = json.loads(Path(args.commit_watermarks).read_text())

    state = load_state(state_path)
    for session_key, ts in new_watermarks.items():
        prev = state.get(session_key, "")
        if ts > prev:
            state[session_key] = ts

    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.write_text(json.dumps(state, ensure_ascii=False, indent=2, sort_keys=True) + "\n")
    print(json.dumps({"written_to": str(state_path), "state": state}, ensure_ascii=False, indent=2))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--reviews-dir", default=str(DEFAULT_REVIEWS_DIR))
    ap.add_argument("--state", default=str(DEFAULT_STATE_PATH))
    ap.add_argument(
        "--key-prefix",
        action="append",
        default=None,
        help="このprefixで始まるsession_keyだけを対象にする(複数指定可)",
    )
    ap.add_argument(
        "--commit-watermarks",
        default=None,
        help="このJSONファイル(または'-'でstdin)の{session_key: ISO timestamp}を状態ファイルにマージ保存する",
    )
    args = ap.parse_args()

    if args.commit_watermarks:
        cmd_commit(args)
    else:
        cmd_extract(args)


if __name__ == "__main__":
    main()
