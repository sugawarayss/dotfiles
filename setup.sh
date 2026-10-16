#!/bin/zsh

PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "PROJECT DIRECTORY: $PROJECT_DIR"

echo "--- Homebrew ---"
if ! command -v brew &>/dev/null; then
	echo -e "Homebrew is not installed. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo -e "Homebrew is already installed."
fi

if ! command -v just &>/dev/null; then
	echo "just is not installed."
	brew install just
else
	echo "just is already installed."
fi

# just initial && just setup
just initial

echo "--- mise ---"
# mise.run のインストール先(~/.local/bin)は初回セットアップ時点ではPATHに無いため追加しておく
export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise &>/dev/null; then
	echo "mise is not installed. Installing mise..."
	curl https://mise.run | sh
else
	echo "mise is already installed."
fi

# mise bootstrap はグローバル設定(~/.config/mise)を読むため、先にリンクしておく
test -e ~/.config/mise || ln -s "$PROJECT_DIR/HOME/.config/mise" ~/.config/mise
mise bootstrap
