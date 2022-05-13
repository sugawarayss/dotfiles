############
# require  #
############
# install homebrew
# `brew install zsh-syntax-highlighting`
# `brew install zsh-completions`
# `brew install zsh-autosuggestions`
# `brew install peco`
# `brew install hub`
# `brew install gh`
# `brew install ghq`
# `brew install exa`
# `brew install bat`
# `brew install fd`
# `brew install sd`
# `brew install procs`
# `brew install ripgrep`
# brew install colordiff
# go get github.com/mattn/qq/...

# 1. generate github access token
#    (https://github.com/settings/tokens)
#    # attach repo permission
# 2. setup hub
#   `hub browse`
#      > github.com username: {YOUR_ACCOUNT_NAME}
#      > github.com password for {YOUR_ACCOUNT_NAME} (never stored): {YOUR_ACCOUNT_ACCESS_TOKEN}
# 3. setup ghq
#   `git config --global ghq.root {YOUR_LOCAL_REPOSITRY_ROOT}`
#   `ghq root`
#      > {full path of your}
# 4.(if you want change root)
#    edit .gitconfig
#    `vi ~/.gitconfig`
#      > [ghq]
#      >   root = {YOUR_REPO_ROOT}

############
# 環境変数 #
############
# see $HOME/.zprofile
typeset -U path cdpath fpath manpath # パスの重複登録を避ける
export LANG=ja_JP.UTF-8
export KCODE=u           # KCODEにUTF-8を設定
## 色を使用出来るようにする
autoload -Uz colors ; colors
## 補完機能を有効にする
autoload -Uz compinit ; compinit
## タブ補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 日本語ファイル名を表示可能にする
setopt print_eight_bit

# aws cli コマンド補完
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
compinit
# 補完を有効化
complete -C '/usr/local/bin/aws_completer' aws

##################
# ヒストリの設定 #
##################
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# 同時起動したzsh間でヒストリを共有する
setopt share_history
# 重複をヒストリに記録しない
setopt hist_ignore_all_dups
# historyコマンドは記録しない
setopt hist_no_store
# 開始と終了を記録
setopt EXTENDED_HISTORY
# 全履歴を一覧表示する
function history-all { history -E 1 }

##########
# PROMPT #
##########
# vcs_infoロード
autoload -Uz vcs_info
# PROMPT変数内で変数参照する
setopt prompt_subst
# vcsの表示
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "*"
zstyle ':vcs_info:*' formats '(%b%c%u)'
zstyle ':vcs_info:*' actionformats '(%b(%a)%c%u)'
# プロンプト表示直前にvcs_info呼び出し
#precmd () {
#    psvar=()
#    LANG=en_US.UTF-8 vcs_info
#    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
#}

# コマンド実行結果後に改行を入れて見やすくする
add_newline() {
    if [[ -z $PS1_NEWLINE_LOGIN ]]; then
        PS1_NEWLINE_LOGIN=true
    else
        printf '\n'
    fi
}
precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    add_newline
}

#add-zsh-hook precmd _update_vcs_info_msg
PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%F{blue}localhost%f:%1(v|%F{red}%1v%f|) $ "
RPROMPT='[%F{green}%d%f]'

###############
# cdrコマンド #
###############
autoload -Uz add-zsh-hock
autoload -Uz chpwd_recent_dirs cdr add-zsh-hock
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi
################
# pecoコマンド #
################
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
# history with pecoはCtrl+Rに割り当てる
zle -N peco-select-history
bindkey '^R' peco-select-history

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
# cdr with peco はCtrl+Eに割り当てる
zle -N peco-cdr
bindkey '^E' peco-cdr

# nvim with peco
function peco-nvim {
  local file="$( fd . -d 1 -t f | sed -e 's;\./;;' | peco )"
    if [ ! -z "$file" ] ; then
        nvim "$file"
    fi
}

###############
# AWS CLI関連 #
###############
function tail-cloudwatch-log() {
  # aws logs tail ${logGroupName} [--filter {filter_strings}] [--since {10m | 1h}]
  local profile="$(aws configure list-profiles | peco)"
  local logGroup=$(aws logs describe-log-groups --profile ${profile} | jq ".logGroups[].logGroupName" | peco | sd "\"" "")
    if [ $# = 0 ]; then
      print -z "aws logs tail ${logGroup}"
    else
      print -z "aws logs tail ${logGroup} $@"
    fi
}

# 指定DynamoDBテーブルをscanする
function scan-dynamodb-table() {
  local profile="$(aws configure list-profiles | peco)"
  local table="$(aws dynamodb list-tables --profile ${profile} | jq ".TableNames[]" | sd "\"" "" | peco)"
  print -z "aws dynamodb scan --table-name $table --profile $profile"
}

# 指定バケットをls -lRするやつ
function file-list-s3(){
  # aws s3 ls s3://\${bucket}[/prefix/] --profile \${profile} --recursive
  local profile="$(aws configure list-profiles | peco)"
  local bucket="$(aws s3 ls --profile ${profile} | cut -d " " -f 3 | peco)"
  if [ $# = 0 ]; then
    print -z "aws s3 ls s3://$bucket --profile $profile --recursive"
  else
    print -z "aws s3 ls s3://$bucket/$@ --profile $profile --recursive"
  fi
}

# 指定のファイルをローカルにDLするやつ
function download-s3(){
  local profile="$(aws configure list-profiles | peco)"
  local bucket="$(aws s3 ls --profile ${profile} | cut -d " " -f 3 | peco)"
  local file="$(aws s3 ls s3://$bucket --profile $profile --recursive | sd " +" " " | cut -d " " -f 4 | peco)"
  if [ $# = 0 ]; then
    print -z "aws s3 cp s3://$bucket/$file ./"
  else
    print -z "aws s3 cp s3://$bucket/$file $@"
  fi
}

###############
# Aliasの設定 #
###############
# core
# catをbatに上書き
if type "bat" > /dev/null 2>&1; then
  alias oldcat="/bin/cat"
  alias cat="bat"
  alias catl='(){bat $1 -l $(bat -L | peco | cut -d ":" -f 1)}'
fi
# lsをexaに上書き
if type "exa" > /dev/null 2>&1; then
  alias ls='exa --git'
  alias exa="exa --git"
  alias la="exa -lahUmB"
  alias ll="exa -lhUmB"
  alias lla="exa -lahUmB"
  alias lt="exa -T"
else
  alias ls="ls -Gh"
  alias la="ls -laGh"
  alias ll="ls -lGh"
fi
# psをprocsに上書き
if type "procs" > /dev/null 2>&1; then
  alias ps="procs"
  alias pswatch='(){procs -W $1}'
fi
# findをfdに上書き
#if type "fd" > /dev/null 2>&1; then
#  alias find='fd'
#  alias pcd='cd $(fd -t d | peco)'
#else
#  alias pcd='cd $(find . -maxdepth 1 -type d | peco)'
#fi

# rg関連(grep代替)
alias lsusb="system_profiler SPUSBDataType"
alias pip="$HOME/.anyenv/envs/pyenv/shims/pip"
# brew実行時のみ、pyenvがPATHに含まれないようにする。（configファイルが複数あると怒られることを回避）
# colordiff関連
if [[ -x `which colordiff` ]]; then
    alias diff='colordiff'
else
    alias diff='diff'
fi

alias brew="PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"
alias lsvim="peco-nvim"
alias vim="nvim"

# qq系
alias qq="/Users/sugawarayasushi/go/bin/qq"

# docker系のalias
# pecoを使って調べたdockerコンテナに入る
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

# Github系のalias
# ブランチを簡単切り替え。 使用: git checkout lb
alias -g lb='$(git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sd "^\*| " "")'
alias repo='cd $(ghq list -p | peco)'
alias remote='$(hub browse $(ghq list | peco))'

# AWS CLI系のalias
alias profiles='aws configure list-profiles'
alias -g lp='$(aws configure list-profiles | peco --prompt "AWS PROFILE>")'
alias tailcwlog='tail-cloudwatch-log'
alias scan='scan-dynamodb-table'
alias lss3='file-list-s3'
alias dls3="download-s3"

# adb系のalias
alias -g dv='$(adb devices | tail -n +2 | peco --prompt "SELECT SIRIAL NO>" | head -n 1 | sd "\s+\w+$" "")'

###########################
# zsh-completions         #
# zsh-autosuggestions     #
###########################
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    autoload -Uz compinit && compinit
fi
###########################
# zsh-syntax-highlighting #
###########################
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 6type syntac highlight
#    main     : 基本ハイライト。デフォルトではこれのみ有効
#    brackets : 括弧
#    pattern  : ユーザ定義
#    cursor   : カーソル
#    root     : rootユーザの場合にコマンドライン全体に適用
#    line     : コマンドライン全体に適用
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

# main config
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
# エイリアスコマンドのハイライト
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# 存在するパスのハイライト
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# グロブ
ZSH_HIGHLIGHT_STYLES[globbing]='none'

# brackets
# マッチしない括弧
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
# 括弧の階層
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
# カーソルがある場所の括弧にマッチする括弧
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'

# cursor
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

export PATH="$HOME/.poetry/bin:$PATH"

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

