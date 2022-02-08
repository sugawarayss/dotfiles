#!/bin/zsh
if [ -e "$HOME/.zshrc" ]; then
    echo "zshrc already exists"
    cp ./zsh/.zshrc $HOME/.zshrc
else
    echo "zshrc does not exist"
    echo "Copying zshrc to $HOME"
    cp ./zsh/.zshrc $HOME/.zshrc
fi

if [ -e $HOME/.zprofile ]; then
    echo "zprofile already exists"
    cp ./zsh/.zprofile $HOME/.zprofile
else
    echo "zprofile does not exist"
    echo "Copying zprofile to $HOME"
    cp ./zsh/.zprofile $HOME/.zprofile
fi

source "$HOME/.zshrc"
source "$HOME/.zprofile"

if [ -e "$HOME/.config/nvim" ]; then
    echo "nvim already exists"
    cp -r ./nvim $HOME/.config
else
    echo "nvim does not exist"
    echo "Copying nvim to $HOME/.config"
    mkdir -p $HOME/.config
    cp -r ./nvim $HOME/.config
fi

if type "brew" > /dev/null 2>&1; then
    echo "brew already exists"
    cd ./homebrew
    brew bundle
else
    echo "brew does not exist"
    echo "Installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    source "$HOME/.zprofile"
    cd ./homebrew
    brew bundle
fi
