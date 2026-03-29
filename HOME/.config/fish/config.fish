
############
# set PATH #
############
# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
# uv
fish_add_path "/Users/sugawarayss/.local/bin"
# RUST
fish_add_path $HOME/.cargo/bin
# psql
fish_add_path /opt/homebrew/opt/libpq/bin
# mysql
fish_add_path /opt/homebrew/opt/mysql-client/bin

# starship
# starship init fish | source

#########################
# ENVIRONMENT VARIABLES #
#########################
set -Ux LANG ja_JP.UTF-8
set -Ux KCODE u
set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
# XDG PATHs 
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache
# fish CONFIG PATHs
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_CACHE_DIR $XDG_CACHE_HOME/fish

# Claude Code
set -g CLAUDE_CONFIG_DIR $HOME/.claude

# android sdk
# set -Ux ANDROID_HOME $HOME/Library/Android/sdk
# set PATH $ANDROID_HOME/tools $PATH
# fish_add_path $ANDROID_HOME/tools
# set PATH $ANDROID_HOME/platform-tools $PATH
# fish_add_path $ANDROID_HOME/platform-tools

# tideのプロンプト設定
set --global tide_left_prompt_frame_enabled true
set --global tide_left_prompt_items "vi_mode" "pwd" "git" "newline" "character"
set --global tide_right_prompt_frame_enabled false
set --global tide_right_prompt_items "os" "status" "cmd_duration" "context" "jobs" "direnv" "bun" "node" "python" "rustc" "java" "php" "ruby" "go" "gcloud" "kubectl" "terraform" "aws" "elixir" "zig" "time"
set --global tide_prompt_add_newline_before true

set --global tide_prompt_icon_connection "󰇘"
set --global tide_pwd_bg_color "33373e"

set --global tide_vi_mode_icon_default "NORMAL"
set --global tide_character_vi_icon_default "󰅁"
set --global tide_vi_mode_bg_color_default "89ca78"

set --global tide_vi_mode_icon_insert "INSERT"
set --global tide_character_icon "󰅂"
set --global tide_vi_mode_bg_color_insert "61afef"

set --global tide_vi_mode_icon_visual "VISUAL"
set --global tide_character_vi_icon_visual "󰅂"
set --global tide_vi_mode_bg_color_visual "d19a66"

set --global tide_vi_mode_icon_replace "REPLACE"
set --global tide_character_vi_icon_replace "󰅂"
set --global tide_vi_mode_bg_color_replace "d55fde"

set --global tide_git_icon ""
set --global tide_git_bg_color_unstable "d19a66"
set --global tide_git_color_staged "005869"
set --global tide_git_color_untracked "6f2e2d"

set --global tide_time_format "%Y/%m/%d %T"

# neovim
set -gx EDITOR nvim
# setup mise
/opt/homebrew/bin/mise activate fish | source

if type "zoxide" > /dev/null 2>&1;
  zoxide init fish | source
end
#########
# alias #
#########
abbr -a paths "echo \$PATH | tr ' ' '\n'"
# sc で ~/.config/fish/config.fish を再読み込み
abbr -a sc source ~/.config/fish/config.fish
# c で clear
abbr -a c 'clear && ll'
# pbc で pbcopy
abbr -a pbc pbcopy
# vim で nvim
abbr -a vim nvim

if type "bat" > /dev/null 2>&1;
  abbr -a oldcat /bin/cat
  abbr -a cat bat
end

if type "procs" > /dev/null 2>&1;
  abbr -a oldps /bin/ps
  abbr -a ps procs
end

if type "lsd" > /dev/null 2>&1;
  abbr -a oldls /bin/ls
  alias ls='lsd --git'
  alias la='lsd --all --git '
  alias ll="lsd --long --git" 
  alias lla="lsd --long --all --git"
  alias lt="lsd --tree --all --icon never"
  alias ld="lsd --directory-only --tree --icon never"
else
  abbr -a ls ls -Gh
  abbr -a la ls -aGh
  abbr -a ll ls -lGh
  abbr -a lla ls -laGh
  abbr -a lt tree
  abbr -a ld tree -d
end

# ディスク使用量を表示する
if type "dust" > /dev/null 2>&1;
  abbr -a disk dust
end

#  ハイパーリンク切れをチェックする
if type "lychee" > /dev/null 2>&1;
  abbr -a hlink lychee
end

# diffをcolordiffで上書き
if type "colordiff" > /dev/null 2>&1;
  abbr -a olddiff /usr/bin/diff
  abbr -a diff colordiff
end

if type "gh" > /dev/null 2>&1;
  # PATを使わないと、`mise outdated`等でrate limitにひっかかってしまう
  set --g MISE_GITHUB_TOKEN (gh auth token)

  function review
    # カレントディレクトリのリポジトリのPRを選択して、prismで開いてpr reviewする
    gh prism "$(gh pr list | fzf --preview 'gh pr view {1}' | awk '{print $1}')"
  end

  function remote
    # カレントリポジトリをブラウザで開く
    gh browse
  end
end

if type "ghq" > /dev/null 2>&1;
  # ローカルにあるgitリポジトリを選択してpathに移動
  function repo
    set -l selected_repo (ghq list -p | peco --prompt="SELECT REPOSITORY >")
    if test -n "$selected_repo"
        cd $selected_repo
    end
  end

end

# if type "hub" > /dev/null 2>&1;
#   # 選択したリモートリポジトリをGithubで開く
#   function remote
#     set -l current_dir (basename (pwd))
#     set -l repo (ghq list | peco --query=$current_dir --prompt="SELECT REPOSITORY >")
#     if test -n "$repo"
#         hub browse $repo
#     end
#   end
# end

# if type "git" > /dev/null 2>&1;
# end

#################
# KeyBindings   #
#################
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert

    # yy で クリップボードにコピー
    bind yy fish_clipboard_copy
    bind p fish_clipboard_paste
    # コマンド履歴を見る
    bind \cr peco_select_history
    # プロセスをキルする(要ps/procs対応)
    bind \cx\ck peco_kill

    # fzf
    bind \cx\cf '__fzf_find_file' # (要sd/sed対応)
    bind \ctr '__fzf_reverse_isearch'
    bind \ed '__fzf_cd' # (要sd/sed 対応)
end

# aws cli の補完
complete -c aws -f -a '(
  begin
    set -lx COMP_SHELL fish
    set -lx COMP_LINE (commandline)
    aws_completer
  end
)'

#################
# Plugin の設定 #
#################
# yuys13/fish-autols
set -U autols_cmd ll
# fzf
set -U FZF_LEGACY_KEYBINDINGS 0

if status is-interactive
    # Commands to run in interactive sessions can go here
end


# Added by Antigravity
fish_add_path /Users/sugawarayss/.antigravity/antigravity/bin
