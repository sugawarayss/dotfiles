export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/bin"
# manコマンドでbatを使って色付けページャーにする
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Apple Silicon用とIntel用homebrewにパスを通す
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# pyenvをPATHに登録
# export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# pyenvを初期化する
eval "$(pyenv init -)"

# Poetryのパスを通す
export PATH="$PATH:$HOME/.poetry/bin"

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
# export PATH=$HOME/anyenv/envs/nodenv

# Nvm(node)
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# adb command
# export PATH=$PATH:/Users/inap/Library/Android/sdk/platform-tools

# golang(goenv)
# export GOENV_ROOT="$HOME/.anyenv/envs/goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# export GOENV_DISABLE_GOPATH=1
eval "$(goenv init -)"
# export GOPATH=$HOME/go
# export PATH="$GOROOT/bin:$PATH"
# export PATH="$GOPATH/bin:$PATH"

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

## react-native用環境変数
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

## jdk
#export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
#export JAVA_HOME=`/usr/libexec/java_home -v 15`

## Neovim用環境変数
# path
export XDG_CONFIG_HOME=~/.config
