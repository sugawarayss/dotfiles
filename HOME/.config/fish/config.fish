
############
# set PATH #
############
set PATH /opt/homebrew/bin $PATH
# RUST
set PATH $HOME/cargo/bin $PATH
# psql
set PATH /opt/homebrew/Cellar/libpq/15.3_1/bin $PATH
# mysql
set PATH /opt/homebrew/opt/mysql-client/bin $PATH

#########################
# ENViRONMENT VARIABLES #
#########################
set -Ux LANG ja_JP.UTF-8
set -Ux KCODE u
set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
# Neovim
set -Ux XDG_CONFIG_HOME $HOME/.config
# direnv
set -Ux EDITOR nvim
# android sdk
set -Ux ANDROID_HOME $HOME/Library/Android/sdk
set PATH $ANDROID_HOME/tools $PATH
set PATH $ANDROID_HOME/platform-tools $PATH

# vi モードのインジケータを常に表示する
set -g theme_display_vi yes

# ユーザ名とホスト名を常に表示する
set -g theme_display_user yes
set -g theme_display_hostname yes

# 日付の表示書式を変更する
set -g theme_date_format "+[%H:%M:%S]"

# プロンプトから入力欄の前に改行をする
set -g theme_newline_cursor yes

# 改行後入力欄の前に表示する文字を設定する（Nerd Font が文字化けしてます）
set -g theme_newline_prompt "\e[32m\e[m "

# setup mise
/opt/homebrew/bin/mise activate fish | source

#########
# alias #
#########
alias vim="nvim"

if type "bat" > /dev/null 2>&1;
  alias oldcat="/bin/cat"
  alias cat="bat"
end

if type "procs" > /dev/null 2>&1;
  alias oldps="/bin/ps"
  alias ps="procs"
end

if type "lsd" > /dev/null 2>&1;
  alias oldls="/bin/ls"
  alias ls='lsd --git'
  alias la='lsd --all --header --size bytes --git --group-directories-first'
  alias ll="lsd --long --header --size bytes --git --group-directories-first --date '+%Y-%m-%dT%H:%M:%S'"
  alias lla="lsd --long --all --header --size bytes --git --group-directories-first --date '+%Y-%m-%dT%H:%M:%S'"
  alias lt="lsd --tree"
  alias ld="lsd --directory-only --tree --icon never"
else
  alias ls="ls -Gh"
  alias la="ls -aGh"
  alias ll="ls -lGh"
  alias lla="ls -laGh"
  alias lt="tree"
  alias ld="tree -d"
end

if type "fd" > /dev/null 2>&1;
  alias oldfind="/usr/bin/find"
  alias find='fd'
  # alias pcd='cd $(fd -t d | gum filter --prompt="cd to ... >")'
end

# sedをsdで上書き
if type "sd" > /dev/null 2>&1;
  alias oldsed="/usr/bin/sed"
  alias sed="sd"
end

# grepをrgで上書き
if type "rg" > /dev/null 2>&1;
  alias oldgrep="/usr/bin/grep"
  alias grep="rg"
end

# diffをcolordiffで上書き
if type "colordiff" > /dev/null 2>&1;
  alias olddiff="/usr/bin/diff"
  alias diff='colordiff'
end

if type "ghq" > /dev/null 2>&1;
  # ローカルにあるgitリポジトリを選択してpathに移動
  function repo
    set -l selected_repo (ghq list -p | gum filter --no-fuzzy --prompt="SELECT REPOSITORY >")
    if test -n "$selected_repo"
        cd $selected_repo
    end
  end

end

if type "hub" > /dev/null 2>&1;
  # 選択したリモートリポジトリをGithubで開く
  function remote
    set -l current_dir (basename (pwd))
    set -l repo (ghq list | gum filter --no-fuzzy --value=$current_dir --prompt="SELECT REPOSITORY >")
    if test -n "$repo"
        hub browse $repo
    end
  end
end

#################
# Vimモード設定 #
#################
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end
# yy で クリップボードにコピー
bind yy fish_clipboard_copy
bind p fish_clipboard_paste

if status is-interactive
    # Commands to run in interactive sessions can go here
end
