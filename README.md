# dotfiles

this repository is my 
## what's inside

- ZSH dot files

  deploy to `$HOME/.zshrc`, `$HOME/.zprofile`

- GIT commit template file 

  template file of git commit message.

  deploy to `$HOME/.commit_template`

- NEOVIM setting files 

  nvim setting files (init.vim, plugin settings, color theme)
  deploy to `$HOME/.config/nvim/`

- HOMEBREW dump file

  homebrew installed formulas

- WARP

  Warp is terminal app made by Rust.
  this repository include keybind settings and workflow definitions

- raycast

  Raycast is launcher app for MacOS
  this repository include user snippets definitions

- INTELLIJ

  file
## setup
Run this:
### Update Zsh dot files
target: `$HOME/.zshrc, $HOME/.zprofile`
```bash
make zsh
source ~/.zprofile && source ~/.zshrc
```

### Update commit template of Git
target: `$HOME/.commit_template`
```bash
make git
```

### Update nvim
target: `$HOME/.config/nvim/`
```bash
make vim
```
  - required deno 
    
    if you do not install deno, run following commands
    ```bash
    asdf plugin add deno
    asdf latest deno
    #> 1.28.3
    asdf install deno 1.28.3
    asdf global deno 1.28.3
    ```

### brew bundle by Brewfile
Run: `brew bundle --file ./homebrew/Brewfile`
```bash
make homebrew
```

### workflows & keybinding
```bash
make warp
```

### setup zsh, git vim homebrew warp
```bash
make all
```
