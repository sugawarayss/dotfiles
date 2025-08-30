# vi モード時にモードインジケータを表示する
set -g theme_display_vi yes
# プロンプトに表示するパス表示の長さを指定
set -g fish_prompt_pwd_dir_length 10
# main/master ブランチ名でも表示する
set -g theme_display_git_default_branch yes
# Powerline 拡張フォントを使用しない
set -g theme_powerline_fonts no
# Nerd Font を使用する
set -g theme_nerd_fonts yes
# テーマを設定
set -g theme_color_scheme nord
# sshセッションがアクティブな場合にのみユーザ名を表示する
set -g theme_display_user ssh
# Python バージョン情報表示を有効にする
set -g theme_display_virtualenv yes
# Go バージョン情報表示を有効にする
set -g theme_display_go verbose
# Ruby のバージョン情報表示を有効にする
set -g theme_display_ruby yes
# node.js のバージョン情報表示を有効にする
set -g theme_display_node yes
# Nix 環境情報表示を有効にする
set -g theme_display_nix yes
# 右プロンプトの日付のタイムゾーンを設定
set -g theme_date_timezone Asia/Tokyo
