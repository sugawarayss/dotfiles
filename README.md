# Dotfiles

my dotfiles

## Structure

```text
.
├── chrome_extensions/
├── HOME/
│   ├── .config/
│   │   ├── fish/
│   │   ├── fzf/
│   │   ├── gh/
│   │   ├── gh-dash/
│   │   ├── ghostty/
│   │   ├── git/
│   │   ├── glide/
│   │   ├── herdr/
│   │   ├── karabiner/
│   │   ├── lazydocker/
│   │   ├── lazygit/
│   │   ├── lazysql/
│   │   ├── lsd/
│   │   ├── markdownlint/
│   │   ├── mcphub/
│   │   ├── mise/
│   │   ├── mise.toml
│   │   ├── nvim
│   │   │   ├── lua/
│   │   │   │   ├── lsp/
│   │   │   │   ├── plugins/
│   │   │   │   └── prompts/
│   │   │   └── snippets/
│   │   ├── pinact/
│   │   ├── starship.toml
│   │   ├── wezterm/
│   │   ├── yamllint/
│   │   ├── yazi
│   │   ├── zed
│   │   └── zellij
│   ├── .warp/
│   ├── claude/
│   ├── crit/
│   └── skkeleton/
├── homebrew
│   └── Brewfile
├── images/
├── IntelliJ/
│   ├── .ideavimrc
│   ├── FileWatcher
│   └── LogFormat
├── justfile
├── raycast/
├── README.md
└── setup.sh
```

## SetUP

- Run **initialize** shell script

    ```shell
    /bin/zsh setup.sh
    ```

- 2回目以降は `mise bootstrap` で、dotfilesのsymlink・macOSの設定・ログインシェル・追加セットアップを反映する（設定: `HOME/.config/mise/conf.d/bootstrap.toml`）

    ```shell
    mise bootstrap --dry-run  # 変更内容の確認
    mise bootstrap
    ```
