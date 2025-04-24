
############
# set PATH #
############
fish_add_path /opt/homebrew/bin
# RUST
fish_add_path $HOME/.cargo/bin
# psql
fish_add_path /opt/homebrew/opt/libpq/bin
# mysql
fish_add_path /opt/homebrew/opt/mysql-client/bin


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
# set PATH $ANDROID_HOME/tools $PATH
fish_add_path $ANDROID_HOME/tools
# set PATH $ANDROID_HOME/platform-tools $PATH
fish_add_path $ANDROID_HOME/platform-tools

# vi モードのインジケータを常に表示する
set -g theme_display_vi yes

# ユーザ名とホスト名を常に表示する
set -g theme_display_user yes
set -g theme_display_hostname yes

# 日付の表示書式を変更する
set -g theme_date_format "+[%Y/%m/%d %H:%M:%S]"

# プロンプトから入力欄の前に改行をする
set -g theme_newline_cursor yes


# 改行後入力欄の前に表示する文字を設定する
set -g theme_newline_prompt "\e[32m\e[m "

# setup mise
/opt/homebrew/bin/mise activate fish | source

#########
# alias #
#########
abbr -a paths "echo \$PATH | tr ' ' '\n'"
# sc で ~/.config/fish/config.fish を再読み込み
abbr -a sc source ~/.config/fish/config.fish
# c で clear
abbr -a c clear
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
  alias la='lsd --all --header --size bytes --git --group-directories-first'
  alias ll="lsd --long --header --size bytes --git --group-directories-first --date '+%Y-%m-%dT%H:%M:%S'"
  alias lla="lsd --long --all --header --size bytes --git --group-directories-first --date '+%Y-%m-%dT%H:%M:%S'"
  alias lt="lsd --tree"
  alias ld="lsd --directory-only --tree --icon never"
else
  abbr -a ls ls -Gh
  abbr -a la ls -aGh
  abbr -a ll ls -lGh
  abbr -a lla ls -laGh
  abbr -a lt tree
  abbr -a ld tree -d
end

# if type "fd" > /dev/null 2>&1;
#   alias oldfind="/usr/bin/find"
#   alias find='fd'
# end

# sedをsdで上書き
# if type "sd" > /dev/null 2>&1;
#   alias oldsed="/usr/bin/sed"
#   alias sed="sd"
# end

# grepをrgで上書き
# if type "rg" > /dev/null 2>&1;
#   alias oldgrep="/usr/bin/grep"
#   alias grep="rg"
# end

# diffをcolordiffで上書き
if type "colordiff" > /dev/null 2>&1;
  abbr -a olddiff /usr/bin/diff
  abbr -a diff colordiff
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

if type "hub" > /dev/null 2>&1;
  # 選択したリモートリポジトリをGithubで開く
  function remote
    set -l current_dir (basename (pwd))
    set -l repo (ghq list | peco --query=$current_dir --prompt="SELECT REPOSITORY >")
    if test -n "$repo"
        hub browse $repo
    end
  end
end

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

###################
# function の定義 #
###################
function notify
  echo "command execution is finished" | say -v Ava
end

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
