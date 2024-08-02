# require  #
############
# 1. generate github access token
#    (https://github.com/settings/tokens)
#    # attach repo permission
# 2. setup hub
#   `hub browse`
#      > github.com username: {YOUR_ACCOUNT_NAME}
#      > github.com password for {YOUR_ACCOUNT_NAME} (never stored): {YOUR_ACCOUNT_ACCESS_TOKEN}

############
# 環境変数 #
############
# see $HOME/.zprofile

## 色を使用出来るようにする
autoload -Uz colors ; colors
## 補完機能を有効にする
## タブ補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 日本語ファイル名を表示可能にする
setopt print_eight_bit

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
# vimモードで起動
set -o vi

##########
# PROMPT #
##########
if type starship > /dev/null 2>&1; then
  # starshipを起動
  eval "$(starship init zsh)"
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
# gumコマンド #
################
function gum-select-history() {
  BUFFER=$(\history -n -r 1 | gum filter --value="$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
# history with gumはCtrl+Rに割り当てる
zle -N gum-select-history
bindkey '^R' gum-select-history

# search a destination from cdr list
function gum-get-destination-from-cdr() {
  cdr -l | \
  oldsed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  gum filter --value="$LBUFFER"
}

function gum-cdr() {
  if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    local destination="$(gum-get-destination-from-cdr)"
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
# cdr with gum はCtrl+Eに割り当てる
zle -N gum-cdr
bindkey '^E' gum-cdr

BREWPREFIX=$(brew --prefix)

# 分割した設定ファイルをsourceする
ZSHHOME="${HOME}/.zsh.d"
if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
  # .profile.zsh を先にロード
    profile_zsh="$ZSHHOME/profile.zsh"
    if [ -f "$profile_zsh" -o -h "$profile_zsh" ] && [ -r "$profile_zsh" ]; then
      . "$profile_zsh"
    fi
  # 他の *.zsh をロード
  for i in $ZSHHOME/*; do
    if [ "$i" != "$profile_zsh" ]; then
      [[ ${i##*/} = *.zsh ]] && [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    fi
  done
fi

# pnpm
export PNPM_HOME="/Users/sugawarayss/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# ImageMagick
export DYLD_LIBRARY_PATH="$BREWPREFIX/lib"
# ImageMagick END

# cd の履歴からディレクトリを高速移動できるコマンド
eval "$(zoxide init zsh)"
