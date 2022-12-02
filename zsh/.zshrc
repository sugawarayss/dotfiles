############
# require  #
############
# install homebrew
# brew bundle --file '~/PROJECTS/sugawarayss/dotfiles/homebrew/Brewfile'
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
# vimモードで起動
set -o vi

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

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  ##### Warp起動時にはSKIPしたい処理 - ここから
  add_newline() {
    if [[ -z $PS1_NEWLINE_LOGIN ]]; then
      PS1_NEWLINE_LOGIN=true
    else
      printf '\n'
    fi
  }
  # プロンプト表示直前にvcs_info呼び出し
  # コマンド実行結果後に改行を入れて見やすくする
  precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    # アクティブなGCPプロジェクトを表示
    #    [[ -n "$(gcloud-current)" ]] && psvar[2]="$(gcloud-current)"
        add_newline
  }

  # 右側にはカレントディレクトリのパスを表示
  RPROMPT='[%F{green}%d%f]'

  # vimモードの現在モードをプロンプトに表示
  function zle-line-init zle-keymap-select {
    case $KEYMAP in
      vicmd)
        PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%F{blue}%m%f [%F{cyan}NORMAL%f] : %1(v|%F{red}%1v%f|) $ "
        ;;
      main|viins)
        PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%F{blue}%m%f [%F{magenta}INSERT%f] : %1(v|%F{red}%1v%f|) $ "
        ;;
    esac
    zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select
  ##### Warp起動時にはSKIPしたい処理 - ここまで
fi
###############
# cdrコマンド #
###############
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
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
  oldsed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
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

###############
# Aliasの設定 #
###############
# vimでneovimを起動
alias vim="nvim"

# brew実行時のみ、pyenvがPATHに含まれないようにする。（configファイルが複数あると怒られることを回避）
alias brew="PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"

# catをbatで上書き
if type "bat" > /dev/null 2>&1; then
  alias oldcat="/bin/cat"
  alias cat="bat"
  alias catl='(){bat $1 -l $(bat -L | peco | cut -d ":" -f 1)}'
fi

# lsをexaで上書き
if type "exa" > /dev/null 2>&1; then
  alias oldls="/bin/ls"
  alias ls='exa --git'
  alias la='exa -lahUmB'
  alias ll="exa -lhUmB"
  alias lla="exa -lahUmB"
  alias lt="exa -T"
  alias ld="exa -lDhUmB"
else
  alias ls="ls -Gh"
  alias la="ls -aGh"
  alias ll="ls -lGh"
  alias lla="ls -laGh"
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
  alias pcd='cd $(fd -t d | peco)'
else
  alias pcd='cd $(find . -maxdepth 1 -type d | peco)'
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
# pecoを使って調べたdockerコンテナに入る
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

# Git/Github系のalias
# ブランチを簡単切り替え。 使用: git checkout lb
alias -g lb='$(git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sd "^\*| " "")'
# ローカルにあるgitリポジトリを選択してpathに移動
alias repo='cd $(ghq list -p | peco)'
# 選択したリモートリポジトリをGithubで開く
alias remote='$(hub browse $(ghq list | peco))'

# AWS CLI系のalias
alias profiles='aws configure list-profiles'
# aws cliでprofileを楽に指定する
alias -g lp='$(aws configure list-profiles | peco --prompt "AWS PROFILE>")'
alias tailcwlog='tail-cloudwatch-log'
alias scan='scan-dynamodb-table'
alias lss3='file-list-s3'
alias dls3="download-s3"

# gcloud系のalias
alias gcswpj="gx"

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
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 6type syntax highlight
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

###############
# gcloud関連  #
###############
# プラグイン
source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc

function gcloud-activate() {
  name="$1"
  project="$2"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
function gx-complete() {
  _values $(gcloud config configurations list | awk '{print $1}')
}

# gcloudでactiveなprojectをpecoで選択して切り替える関数
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | peco --prompt "SELECT PROJECT>")
    name=$(echo "${line}" | awk '{print $1}')
  else
    line=$(gcloud config configurations list | grep "$name")
  fi
  project=$(echo "${line}" | awk '{print $4}')
  gcloud-activate "${name}" "${project}"
}
compdef gx-complete gx

# gcloud設定名からプロジェクト名を取得する
function gcloud-alias() {
    gcloud config configurations list | grep "^$1" | head -1 | awk '{print $4}'
}

# 現在の設定を取得する
function gcloud-current() {
    cat $HOME/.config/gcloud/active_config
}

###############
# AWS CLI関連 #
###############
function ssh2ec2() {
  local profile=$(aws configure list-profiles | peco --prompt="SELECT profile > " --query "$LBUFFER")
  if [[ ${profile} =~ liftspot ]]; then
    if [[ ${profile} =~ stg ]]; then
      local pemfile=$(find  pem ~/.ssh | grep liftspot | peco --prompt="SELECT file of ${profile} > " --query "stg")
    else
      local pemfile=$(find  pem ~/.ssh | grep liftspot | peco --prompt="SELECT file of ${profile} > " --query "prd")
    fi
  else
    local  pemfile=$(find  pem ~/.ssh | grep -v liftspot | peco --prompt="SELECT file of ${profile} > ")
  fi
  # local jq_option="\".Reservations[].Instances[] | [[.Tags[] | select(.Key == \"Name\").Value][0], \"ssh ec2-user@\" + .NetworkInterfaces[].Association.PublicIp + \" -i ${pemfile}\"] | @tsv' | column -t -s \"\`printf '\t'\`\""
  local host_ip="$(aws ec2 describe-instances --profile ${profile}\
  | jq -r '.Reservations[].Instances[] | [[.Tags[] | select(.Key == "Name").Value][0], .NetworkInterfaces[].Association.PublicIp] | @tsv'\
  | column -t -s "`printf '\t'`"\
  | peco --prompt="SELECT host > "\
  | grep -o -e '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')" # GNU grepの場合は grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'とすること
  if [ -n "$host_ip" ]; then
    echo $BUFFER
    BUFFER="ssh ec2-user@${host_ip} -i ${pemfile}"
    zle redisplay
  fi
}
zle -N ssh2ec2
# Ctrl + Lに割り当てる
bindkey '^L' ssh2ec2

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
