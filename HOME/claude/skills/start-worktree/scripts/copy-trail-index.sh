#!/usr/bin/env bash
# gwmのpost_createフックから新規worktree直下で実行する。
# trailのインデックス(graft/)はglobal gitignoreで除外されworktreeに持ち込まれず、
# trailも自動buildしないため、メインリポジトリの索引をコピーして空振りを防ぐ。
# 索引は相対パスのみでfingerprintにより差分更新されるため、コピーしてもそのまま使える。
set -euo pipefail

worktree="$(pwd)"
main="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"

# trailを初期化したディレクトリ(リポジトリ直下とは限らない)ごとにgraft/がある
fd -H -I -t d '^graft$' -E .worktrees -E node_modules -E .git "$main" | while read -r src; do
  src="${src%/}" # fdは末尾に/を付けるが、rsyncでは中身だけのコピーになってしまう
  [ -d "$src/.graph" ] || continue
  dest_parent="$worktree/$(dirname "${src#"$main"/}")"
  mkdir -p "$dest_parent"
  # .cache/session はセッション固有の状態なので持ち込まない
  rsync -a --exclude '.cache/session/' "$src" "$dest_parent/"
done
