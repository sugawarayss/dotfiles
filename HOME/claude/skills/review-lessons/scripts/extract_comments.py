#!/usr/bin/env python3
"""tuicrの永続化レビューセッションから、未処理の指摘コメントを抽出する。

状態ファイル(デフォルト: ~/.config/review-lessons/state.json)に記録された
セッションごとの watermark (最後に処理したコメントの created_at) より新しい
コメントだけを候補として出力する。状態ファイルに無いセッションは全履歴が対象になる。

Usage:
  extract_comments.py                          候補をJSONで標準出力
  extract_comments.py --commit-watermarks -     標準入力のJSON({session_key: iso timestamp})を
                                                 状態ファイルへ(既存値とのmaxを取って)マージ保存
"""
import argparse
import json
import sys
from pathlib import Path

DEFAULT_REVIEWS_DIR = Path.home() / "Library/Application Support/tuicr/reviews"
DEFAULT_STATE_PATH = Path.home() / ".config/review-lessons/state.json"

# tuicr review add --username 'execute-plan-and-pr' で投稿される「対応: ...」は
# 指摘そのものではなく対応済みメモなので候補から除外する。
EXCLUDED_AUTHORS = {"execute-plan-and-pr"}

# スキル自体の動作確認用に作った使い捨てセッション。
EXCLUDED_SESSION_KEY_PREFIXES = ("tuicr-test",)


def load_state(path: Path) -> dict:
    if path.exists():
        return json.loads(path.read_text())
    return {}


def extract_from_session(data: dict, session_key: str, watermark: str):
    repo_path = data.get("repo_path")
    branch_name = data.get("branch_name")
    candidates = []
    max_seen = watermark

    def consider(comment: dict, file_path, line):
        nonlocal max_seen
        author = comment.get("author") or ""
        created_at = comment.get("created_at") or ""
        if author in EXCLUDED_AUTHORS:
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
                "content": comment.get("content", ""),
                "created_at": created_at,
                "comment_id": comment.get("id"),
            }
        )

    for c in data.get("review_comments", []) or []:
        consider(c, None, None)

    for file_path, finfo in (data.get("files") or {}).items():
        for c in finfo.get("file_comments", []) or []:
            consider(c, file_path, None)
        for line, comments in (finfo.get("line_comments") or {}).items():
            for c in comments or []:
                consider(c, file_path, line)

    return candidates, max_seen


def cmd_extract(args):
    reviews_dir = Path(args.reviews_dir)
    state_path = Path(args.state)
    state = load_state(state_path)

    index_path = reviews_dir / "index.json"
    index = json.loads(index_path.read_text())

    all_candidates = []
    suggested_watermarks = {}
    sessions_scanned = 0
    sessions_skipped_missing = []

    for session_key, entries in index.get("entries", {}).items():
        if any(session_key.startswith(p) for p in EXCLUDED_SESSION_KEY_PREFIXES):
            continue
        if args.key_prefix and not any(session_key.startswith(p) for p in args.key_prefix):
            continue

        watermark = state.get(session_key, "")
        for entry in entries or []:
            rel_path = entry.get("path")
            if not rel_path:
                continue
            session_file = reviews_dir / rel_path
            if not session_file.exists():
                sessions_skipped_missing.append(session_key)
                continue
            sessions_scanned += 1
            data = json.loads(session_file.read_text())
            candidates, max_seen = extract_from_session(data, session_key, watermark)
            all_candidates.extend(candidates)
            if max_seen and max_seen != watermark:
                prev = suggested_watermarks.get(session_key, "")
                suggested_watermarks[session_key] = max(max_seen, prev)

    all_candidates.sort(key=lambda c: c["created_at"])

    result = {
        "sessions_scanned": sessions_scanned,
        "sessions_skipped_missing_file": sessions_skipped_missing,
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
