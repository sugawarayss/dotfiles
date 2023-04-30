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
autoload -Uz compinit && compinit
## タブ補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 日本語ファイル名を表示可能にする
setopt print_eight_bit

# aws cli コマンド補完
#autoload bashcompinit && bashcompinit
#autoload -Uz compinit && compinit
# compinit
# 補完を有効化
#complete -C '/usr/local/bin/aws_completer' aws

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
if type starship > /dev/null 2>&1; then
  # starshipがinstall済ならPROMPTのセットアップはしない
else
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
  BUFFER=$(\history -n -r 1 | gum filter --value="$LBUFFER")
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
  gum filter --value="$LBUFFER"
}

function peco-cdr() {
  if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    local destination="$(peco-get-destination-from-cdr)"
    if [ -n "$destination" ]; then
      BUFFER="cd $destination"
      zle accept-line
    else
      zle reset-prompt
    fi
  else
    cdr -l | awk '{print $2}' | gum filter | cd
  fi
}
# cdr with peco はCtrl+Eに割り当てる
zle -N peco-cdr
bindkey '^E' peco-cdr

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  alias phis='peco-select-history'
  alias pcdr='peco-cdr'
fi
###############
# Aliasの設定 #
###############
# vimでneovimを起動
if type "nvim" > /dev/null 2>&1; then
  alias vim="nvim"
fi

# brew実行時のみ、pyenvがPATHに含まれないようにする。（configファイルが複数あると怒られることを回避）
alias brew="PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"
BREWPREFIX=$(brew --prefix)

# homebrewで入れたctagsを使うためのalias
alias ctags="${BREWPREFIX}/bin/ctags"
# brew listから選択してuninstall

# catをbatで上書き
if type "bat" > /dev/null 2>&1; then
  alias oldcat="/bin/cat"
  alias cat="bat"
  alias catl='(){bat $1 -l $(bat -L | gum filter | cut -d ":" -f 1)}'
fi

# lsをexaで上書き
if type "exa" > /dev/null 2>&1; then
  alias oldls="/bin/ls"
  alias ls='exa -@ --git'
  alias la='exa --long --all --header --created --modified --bytes --icons --git --time-style=long-iso --group-directories-first'
  alias ll='exa --long --header --created --modified --bytes --icons --git --time-style=long-iso --group-directories-first'
  alias lla="exa --long --all --header --created --modified --bytes --icons --git --time-style=long-iso --group-directories-first"
  alias lt="exa -T --icons"
  alias ld="exa --long --only-dirs --header --created --modified --bytes --icons --git --time-style=long-iso --group-directories-first"
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
  alias pcd='cd $(fd -t d | gum choose --header="Change Directory To...")'
else
  alias pcd='cd $(find . --maxdepth 1 --type d | gum choose --header="Change Directory To...")'
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
alias -g lp='$(aws configure list-profiles | gum choose --header="AWS Profile...")'

# gcloud系のalias
alias gcswpj="gx"

# adb系のalias
alias -g dv='$(adb devices | tail -n +2 | gum filter --prompt="SELECT SIRIAL NO >" | head -n 1 | sd "\s+\w+$" "")'

# kiconia works - kobashi project で使用するlocalstack のalias
alias -g localstackendpoint='$(echo "--endpoint-url=http://s3.localhost.localstack.cloud:4566")'

if type brew > /dev/null 2>&1; then
  ###########################
  # zsh-completions         #
  # zsh-autosuggestions     #
  ###########################
  FPATH=${BREWPREFIX}/share/zsh-completions:$FPATH
  source ${BREWPREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -Uz compinit && compinit

  ###########################
  # zsh-syntax-highlighting #
  ###########################
  source ${BREWPREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
fi

###############
# gcloud関連  #
###############
# プラグイン
if type gcloud > /dev/null 2>&1; then
  source ${BREWPREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
  source ${BREWPREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

function gcloud-activate() {
  name="$1"
  project="$2"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
function gx-complete() {
  _values $(gcloud config configurations list | awk '{print $1}')
}

# gcloudでactiveなprojectをgum filterで選択して切り替える関数
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | gum filter --prompt="SELECT GCP PROJECT >")
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
# 指定バケットをls -lRするやつ
function file-list-s3(){
  # aws s3 ls s3://\${bucket}[/prefix/] --profile \${profile} --recursive
  local profile="$(aws configure list-profiles | gum filter)"
  local bucket="$(aws s3 ls --profile ${profile} | cut -d " " -f 3 | gum filter)"
  if [ $# = 0 ]; then
    print -z "aws s3 ls s3://$bucket --profile $profile --recursive"
  else
    print -z "aws s3 ls s3://$bucket/$@ --profile $profile --recursive"
  fi
}

# 指定のファイルをローカルにDLするやつ
function download-s3(){
  local profile="$(aws configure list-profiles | gum filter)"
  local bucket="$(aws s3 ls --profile ${profile} | cut -d " " -f 3 | gum filter)"
  local file="$(aws s3 ls s3://$bucket --profile $profile --recursive | sd " +" " " | cut -d " " -f 4 | gum filter)"
  if [ $# = 0 ]; then
    print -z "aws s3 cp s3://$bucket/$file ./"
  else
    print -z "aws s3 cp s3://$bucket/$file $@"
  fi
}

# asdf用にパスを通す
. /opt/homebrew/opt/asdf/libexec/asdf.sh
# starshipを起動
eval "$(starship init zsh)"
# pipenv補完設定
if type pipenv > /dev/null 2>&1; then
  eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"
fi

