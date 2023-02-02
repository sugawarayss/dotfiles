export LANG=ja_JP.UTF-8
export KCODE=u           # KCODEにUTF-8を設定
# manコマンドでbatを使って色付けページャーにする
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export PATH="$PATH:$HOME/.local/bin:/usr/local/bin"

################
# Homebrew関連 #
################
# Apple Silicon用とIntel用homebrewにパスを通す
if [[ $(uname -m) == "arm64" ]]; then
  export BREWPATH="/opt/homebrew/bin"
else
  export BREWPATH="/usr/local/bin"
fi
export PATH="$BREWPATH:$PATH"

# homebrewでインストールしたpostgresは5433ポートに変更
export PGPORT=5433

##############
# anyenv関連 #
##############
if type anyenv > /dev/null; then
  ANYENVPATH="$HOME/.anyenv"
  RBENV_ROOT="${ANYENVPATH}/envs/rbenv"
  PYENV_ROOT="${ANYENVPATH}/envs/pyenv"
  NODENV_ROOT="${ANYENVPATH}/envs/nodenv"
  GOENV_ROOT="${ANYENVPATH}/envs/goenv"
  JENV_ROOT="${ANYENVPATH}/envs/jenv"

  if [ -d "${ANYENVPATH}/bin" ]; then
    export PATH="$PATH:${ANYENVPATH}/bin"
    eval "$(anyenv init -)"
  fi

  if [ -d "${RBENV_ROOT}/bin" ]; then
    export PATH="$PATH:${RBENV_ROOT}/bin"
    eval "$(rbenv init -)"
  fi

  if [ -d "${PYENV_ROOT}/bin" ]; then
    export PATH="$PATH:${PYENV_ROOT}/bin"
    eval "$(pyenv init -)"
    # pyenv-virtualenvの設定
    #eval "(pyenv virtualenv-init -)" > /dev/null
  fi

  if [ -d "${NODENV_ROOT}/bin" ]; then
    export PATH="$PATH:${NODENV_ROOT}/bin"
    eval "$(nodenv init -)"
  fi

  if [ -d "${GOENV_ROOT}/bin" ]; then
    export PATH="$PATH:${GOENV_ROOT}/bin"
    eval "$(goenv init -)"
  fi

  if [ -d "${JENV_ROOT}/bin" ]; then
    export PATH="$J{ENV_ROOT}/bin:$PATH"
    eval "$(jenv init -)"
  fi
fi

########
# asdf #
########
. /opt/homebrew/opt/asdf/libexec/asdf.sh

##########
# poetry #
##########
export PATH="$HOME/.poetry/bin:$PATH"

##########
# pipenv #
##########
#PIPENV_PYTHONを指定
export PIPENV_PYTHON="$HOME/.asdf/shims/python"
# プロジェクト内に仮想環境を作成する
export PIPENV_VENV_IN_PROJECT=1

##########
# golang #
##########
export GOPATH=$HOME/go
if type asdf > /dev/null; then
  version=$(asdf current golang | awk -F' ' '{print $2}')
  export GOROOT="$HOME/.asdf/installs/golang/${version}/go"
fi
###########
# flutter #
###########
# gitからインストールした場合
#export FLUTTER_PATH=$HOME/flutter/bin
#export PATH="$PATH:$FLUTTER_PATH"

# fvmでインストールする場合
export PATH="$PATH:$HOME/.pub-cache/bin"

# fvmでインストールしたflutterをglobalで使うためにPATHを通す
export PATH="$PATH:$HOME/fvm/default/bin"
export FLUTTER_GIT_URL="https://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:x-oauth-basic@github.com/flutter/flutter.git"

###############
# abdroid sdk #
###############
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

###########
## Neovim #
###########
# path
export XDG_CONFIG_HOME=~/.config

########
# Rust #
########
export PATH=$HOME/.cargo/bin:$PATH

###############
# Amplify CLI #
###############
export PATH="$HOME/.amplify/bin:$PATH"

##############
# typescript #
##############
export PATH="$HOME/PROJECTS/sugawarayss/ts_playground/node_modules/.bin:$PATH"

typeset -U path cdpath fpath manpath # パスの重複登録を避ける

