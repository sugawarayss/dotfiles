#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title input
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.description show vim on ghostty for input
# @raycast.author sugawarayss
# @raycast.authorURL https://raycast.com/sugawarayss

tmp_dir="${TMPDIR:-/tmp}"
tmp_file="${tmp_dir%/}/raycast-note-$(date +%Y%m%d%H%M%S).md"

# 空ファイルを作成して初期ハッシュを固定（未編集や :q! はペーストをスキップするため）
: > "$tmp_file"
initial_hash="$(shasum -a 256 "$tmp_file" | awk '{print $1}')"

# 起動前に前面アプリを記録（nvim 終了後に戻してペーストするため）
front_app="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')"

# Ghostty を新規起動して nvim を開く
/Applications/Ghostty.app/Contents/MacOS/ghostty -e zsh -i -c "
nvim '$tmp_file'
final_hash=\"\$(shasum -a 256 '$tmp_file' | awk '{print \$1}')\"
if [ \"\$final_hash\" != '$initial_hash' ] && [ -s '$tmp_file' ]; then
  cat '$tmp_file' | pbcopy
  osascript -e 'tell application \"$front_app\" to activate'
  osascript -e 'tell application \"System Events\" to keystroke \"v\" using command down'
fi
"

