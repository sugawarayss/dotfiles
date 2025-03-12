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

just initial
just setup
