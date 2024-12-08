#!/bin/zsh

PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "PROJECT DIRECTORY: $PROJECT_DIR"

echo "--- Homebrew ---"
if ! command -v brew &> /dev/null
then
  echo -e "Homebrew is not installed. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo -e "Homebrew is already installed."
fi

echo "--- Brew Bundle ---"
if ! command -v brew &> /dev/null
then
  echo -e "  Homebrew is not installed."
else
  echo "  Install dependencies from Brewfile."
  brew bundle --file "${PROJECT_DIR}/homebrew/Brewfile"
fi

# zsh
echo "--- SetUp Zsh ---"
[ ! -L ~/.zsh.d ] && ln -s "${PROJECT_DIR}/HOME/.zsh.d ~/.zsh.d" || echo -e "\n ~/.zsh.d is already exists"
[ ! -L ~/.zshrc ] && ln -s "${PROJECT_DIR}/HOME/.zshrc ~/.zshrc" || echo -e "\n ~/.zshrc is already exists"
[ ! -L ~/.zprofile ] && ln -s "${PROJECT_DIR}/HOME/.zprofile ~/.zprofile" || echo -e "\n ~/.zprofile is already exists"
# source ~/.zshrc && source ~/.zprofile
. ~/.zshrc && . ~/.zprofile


if ! command -v task &> /dev/null
then
  echo "go-task is not installed."
  brew install go-task
else
  echo "--- Setup MacOS Settings ---"
  task macos:screenshot
  task prepare:directories
  echo "--- Setup starship ---"
  task links:starship
  echo "--- Setup GIt ---"
  task git:setup
  task lazygit
  echo "--- Setup Editor ---"
  task nvim
  task links:ideavim
  task zed:settings
  task zed:keymap
  echo "--- Setup Terminal App ---"
  task links:warp
  task links:wezterm
  echo "--- SetUp asdf ---"
  task asdf:plugins
  task asdf:latest
  task asdf:set_global
fi
