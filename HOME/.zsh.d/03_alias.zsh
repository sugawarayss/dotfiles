#########
# Alias #
#########
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  alias phis='peco-select-history'
  alias pcdr='peco-cdr'
fi

alias vim="nvim"

# brew実行時のみ、pyenvがPATHに含まれないようにする。（configファイルが複数あると怒られることを回避）
alias brew="PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"

# homebrewで入れたctagsを使うためのalias
alias ctags="$(brew --prefix)/bin/ctags"
# brew listから選択してuninstall

# catをbatで上書き
if type "bat" > /dev/null 2>&1; then
  alias oldcat="/bin/cat"
  alias cat="bat"
  alias catl='(){bat $1 -l $(bat -L | gum filter | cut -d ":" -f 1)}'
fi

# lsをlsdで上書き
if type "lsd" > /dev/null 2>&1; then
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
fi

# psをprocsで上書き
if type "procs" > /dev/null 2>&1; then
  alias oldps="/bin/ps"
  alias ps="procs"
  alias pswatch='(){procs -W $1}'
fi

# findをfdで上書き
if type "fd" > /dev/null 2>&1; then
  alias oldfind="/usr/bin/find"
  alias find='fd'
  alias pcd='cd $(fd -t d | gum filter --prompt="cd to ... >")'
else
  alias pcd='cd $(find . --maxdepth 1 --type d | gum filter --prompt="cd to...>")'
fi

# sedをsdで上書き
if type "sd" > /dev/null 2>&1; then
  alias oldsed="/usr/bin/sed"
  alias sed="sd"
fi

# grepをrgで上書き
if type "rg" > /dev/null 2>&1; then
  alias oldgrep="/usr/bin/grep"
  alias grep="rg"
fi

# diffをcolordiffで上書き
if type "colordiff" > /dev/null 2>&1; then
  alias olddiff="/usr/bin/diff"
  alias diff='colordiff'
fi

# USBデバイスをlsするalias
alias lsusb="system_profiler SPUSBDataType"

# docker系のalias
if type "docker" > /dev/null 2>&1; then
  # gum chooseを使って調べたdockerコンテナに入る
  alias de='docker exec -it $(docker ps | gum choose --header="Choose Container" | cut -d " " -f 1) /bin/bash'

  # 選択したコンテナを削除する
  alias drm='docker rm $(docker ps | gum choose --header="Choose Delete Container" | cut -d " " -f 1)'
  # 選択したdocker imageを削除する
  alias drmi='docker rm $(docker images -a | gum choose --header="Choose Delete Image" | cut -d " " -f 8)'
  # 選択したdocker volumeを削除する
  alias dvrm='docker volume rm $(docker volume ls | gum choose --header="Choose Delete Volume" | cut -d " " -f 6)'
fi

# Git/Github系のalias
if type "git" > /dev/null 2>&1; then
  # g(it)b(ranch)d(delete): 選択したブランチを削除する
  alias gdb='git delete $(git branch -l | gum filter --prompt="SELECT BRANCH >" | sd "^\*\s*" "")'
fi
if type "ghq" > /dev/null 2>&1; then
  # ローカルにあるgitリポジトリを選択してpathに移動
  alias repo='cd $(ghq list -p | gum filter --no-fuzzy --prompt="SELECT REPOSITORY >")'
fi

if type "hub" > /dev/null 2>&1; then
  # 選択したリモートリポジトリをGithubで開く
  alias remote='$(hub browse $(ghq list | gum filter --no-fuzzy --value=$(basename $(pwd)) --prompt="SELECT REPOSITORY >"))'
fi

# AWS CLI系のalias
alias profiles='aws configure list-profiles'
# aws cliでprofileを楽に指定する
alias -g lp='$(aws configure list-profiles | gum filter --prompt="AWS PROFILE >")'

alias tailcwlog='tail-cloudwatch-log'
alias scan='scan-dynamodb-table'
alias lss3='file-list-s3'
alias dls3="download-s3"

# gcloud系のalias
alias gcswpj="gx"

# adb系のalias
alias -g dv='$(adb devices | tail -n +2 | gum filter --prompt="SELECT SIRIAL NO >" | head -n 1 | sd "\s+\w+$" "")'

# kiconia works - kobashi project で使用するlocalstack のalias
alias -g localstackendpoint='$(echo "--endpoint-url=http://s3.localhost.localstack.cloud:4566")'

# xsv でcsv を扱えるように
if type "xsv" > /dev/null 2>&1; then
  alias csv='xsv'
  alias csvheader='xsv headers'
fi

# コードや標準出力を画像に変換する
if type "freeze" > /dev/null 2>&1; then
  alias freeze='freeze -c full --font.family "Hack Nerd Font" --output ~/Documents/FREEZE_CODES/frozen_code.png'
fi
