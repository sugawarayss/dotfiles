export LANG=ja_JP.UTF-8
export KCODE=u           # KCODEにUTF-8を設定

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/bin"
# manコマンドでbatを使って色付けページャーにする
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Apple Silicon用とIntel用homebrewにパスを通す
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# homebrewでインストールしたpostgresは5433ポートに変更
export PGPORT=5433
# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# pyenvをPATHに登録
# export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# pyenvを初期化する
eval "$(pyenv init -)"

# Poetryのパスを通す
export PATH="$HOME/.poetry/bin:$PATH"

# Pipenvのvenvをプロジェクトディレクトリ内に作る
export PIPENV_VENV_IN_PROJECT=1

## pyenv-virtualenvの設定
# eval "(pyenv virtualenv-init -)" > /dev/null

# rbenvをPATHに登録
# export RBENV_ROOT="$HOME/.anyenv/envs/rbenv"
# export PATH="$RBENV_ROOT/bin:$PATH"
# rbenvを初期化する
eval "$(rbenv init -)"

# nodebrew
# export PATH=$HOME/.nodebrew/current/bin:$PATH

#nodenv
# export PATH=$HOME/.anyenv/envs/nodenv


# golang(goenv)
#export GOPATH=$HOME/go
export GOENV_ROOT="$HOME/.anyenv/envs/goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT:$PATH"
#export PATH="$GOPATH:$PATH"

# jenv
export JENV_ROOT="$HOME/.anyenv/envs/jenv"
if [ -d "${JENV_ROOT}" ]; then
  export PATH="$JENV_ROOT/bin:$PATH"
  eval "$(jenv init -)"
fi

# flutter
# gitからインストールした場合
#export FLUTTER_PATH=$HOME/flutter/bin
#export PATH="$PATH:$FLUTTER_PATH"

# fvmでインストールする場合
export PATH="$PATH:$HOME/.pub-cache/bin"

# fvmでインストールしたflutterをglobalで使うためにPATHを通す
export PATH="$PATH:$HOME/fvm/default/bin"
export FLUTTER_GIT_URL="https://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:x-oauth-basic@github.com/flutter/flutter.git"

## abdroid sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

## Neovim用環境変数
# path
export XDG_CONFIG_HOME=~/.config

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

# typescript
export PATH="$HOME/PROJECTS/sugawarayss/ts_playground/node_modules/.bin:$PATH"
typeset -U path cdpath fpath manpath # パスの重複登録を避けるexport PATH=$PATH:/Users/sugawarayasushi/PROJECTS/sugawarayss/ts_playground/node_modules/.bin
