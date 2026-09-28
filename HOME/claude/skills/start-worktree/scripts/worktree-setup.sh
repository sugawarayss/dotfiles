#!/usr/bin/env bash
# 新規worktreeの初期セットアップ (.envの作成 + プロジェクトのセットアップ)。
# nonoサンドボックスは**/.envへの書き込みをdenyしているため、サンドボックス内で動くgwmの
# post_createフックでは.envを作れない。そこでgwm-herdr-start.shが、サンドボックス外で動く
# herdrペインのシェルに `herdr pane run` でこのスクリプトを実行させる。
# worktreeのルートをカレントディレクトリにして実行すること。
set -euo pipefail

# git管理下の全.env.exampleから、同じディレクトリの.envを作る (既存の.envは上書きしない)
git ls-files -z -- ':(glob)**/.env.example' | while IFS= read -r -d '' example; do
  cp -n "$example" "${example%.example}"
done

# ~/.config/gwm/config.tomlのpost_createフック (サンドボックス内ではスキップされる) と同じ処理
if [[ -f mise.toml ]]; then
  mise run setup:project
fi
if [[ -f pyproject.toml ]]; then
  uv sync
fi
