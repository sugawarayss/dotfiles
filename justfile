# 共通の変数
pwd := `pwd`

# デフォルトはタスクのリスト表示
default: _list

# claude code 用設定ファイル
claude:
  @type -q npm || mise install node@latest
  @type -q claude || npm install -g @anthropic-ai/claude-code
  @test -d ~/.claude || mkdir -p ~/.claude
  @test -L ~/.claude/CLAUDE.md || ln -s {{pwd}}/HOME/claude/CLAUDE.md ~/.claude/CLAUDE.md
  @test -L ~/.claude/settings.json || ln -s {{pwd}}/HOME/claude/settings.json ~/.claude/settings.json
  @claude mcp add-json {{pwd}}/HOME/claude/mcp_config.json

# 定義済タスクリスト表示
_list:
  @just --list

# zshの設定ファイルを展開
zsh:
  @test -L ~/.zsh.d || ln -s {{pwd}}/HOME/.zsh.d ~/.zsh.d
  @test -L ~/.zshrc || ln -s {{pwd}}/HOME/.zshrc ~/.zshrc
  @test -L ~/.zprofile || ln -s {{pwd}}/HOME/.zprofile ~/.zprofile
  @echo "you need run 'source ~/.zshrc && source ~/.zprofile'"

# fish の設定ファイルを展開
fish:
  @test -L ~/.config/fish/config.fish || ln -s {{pwd}}/HOME/.config/fish/config.fish ~/.config/fish/config.fish
  @test -L ~/.config/fish/conf.d/bobthefish.fish || ln -s {{pwd}}/HOME/.config/fish/conf.d/bobthefish.fish ~/.config/fish/conf.d/bobthefish.fish
  # デフォルトシェルをfishに変更
  echo $(which fish) | sudo tee -a /etc/shells
  chsh -s $(which fish)
  @echo "you need restart your terminal for switch to fish shell"

# fishプラグインマネージャ
fisher:
  # fisher のインストール
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  @test -L ~/.config/fish/fish_plugins || ln -s {{pwd}}/HOME/.config/fish/fish_plugins ~/.config/fish/fish_plugins
  fisher update

#  Brewfile からパッケージをインストール
brew-restore:
  # Brewfile から全てのパッケージをインストール
  @brew bundle --file {{pwd}}/homebrew/Brewfile

# Brewfile を更新
brew-dump:
  @brew bundle dump --force --file {{pwd}}/homebrew/Brewfile

_macos-general-settings:
  # スクロールバーを常時表示
  @defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

_macos-dock-settings:
  # デフォルトアプリをDockから除去
  @defaults write com.apple.dock persistent-apps -array
  # 起動中のアプリのみをDockに表示
  @defaults write com.apple.dock static-only -bool true

_macos-finder-settings:
  # ステータスバーを表示
  @defaults write com.apple.finder ShowStatusBar -bool true
  # パスバーを表示
  @defaults write com.apple.finder ShowPathbar -bool true
  # タブバーを表示
  @defaults write com.apple.finder ShowTabView -bool true
  # すべての拡張子のファイルを表示
  @defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # 隠しファイルを表示
  @defaults write com.apple.finder AppleShowAllFiles -bool true
  # 検索時にデフォルトでカレントディレクトリを検索
  @defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  # Finderを再起動
  @killall Finder

_macos-screenshot-settings:
  # スクリーンショットの保存先
  @defaults write com.apple.screencapture location ~/SCREENSHOTS
  # スクリーンショットファイル名称
  @defaults write com.apple.screencapture name screenshot
  # ファイル名称に日付を含めない
  @defaults write com.apple.screencapture include-date -bool false
  # フローティングサムネイルを非表示
  @defaults write com.apple.screencapture show-thumbnail -bool false

# macOSの設定変更
[macos]
system-preferences: _macos-general-settings _macos-dock-settings _macos-finder-settings _macos-screenshot-settings

# raycastの設定変更
raycast:
  # 起動キーを<Option-Space> に変更
  @defaults write com.raycast.macos raycastGlobalHotkey -string "Option-49"
  # ナビゲーションスタイルをvimに変更
  @defaults write com.raycast.macos navigationCommandStyleIdentifierKey vim
  # デフォルトのスニペットディレクトリを設定
  @defaults write com.raycast.macos NSNavLastRootDirectory -string "{{pwd}}/raycast/snippets"

# git の設定ファイルを展開
_git-config:
  # gitの設定ファイル
  @test -L ~/.gitconfig || ln -s {{pwd}}/HOME/.config/git/.gitconfig ~/.gitconfig
  # gitignore
  @test -L ~/.config/git/ignore || ln -s {{pwd}}/HOME/.config/git/ignore ~/.config/git/ignore
  # コミットテンプレート
  @test -L ~/.config/git/.commit_template || ln -s {{pwd}}/HOME/.config/git/.commit_template ~/.config/git/.commit_template

# gh コマンドの設定ファイルを展開
_gh-config:
  # gh の設定ファイル
  @test -L ~/.config/gh || ln -s {{pwd}}/HOME/.config/gh ~/.config/gh
  # gh-dash の設定ファイル
  @test -L ~/.config/gh-dash || ln -s {{pwd}}/HOME/.config/gh-dash ~/.config/gh-dash

# gh コマンドの拡張をインストール
_gh-extensions:
  # gh-dash 拡張のインストール
  @gh extension install dlvhdr/gh-dash
  # gh-notify 拡張のインストール
  @gh extension install meiji163/gh-notify
  # gh-copilot 拡張のインストール
  @gh extension install github/gh-copilot

# git 関連の設定を展開
git: _git-config _gh-config _gh-extensions

# lazygitコマンド用の設定ファイルを展開
lazygit:
  # lazygit の設定ファイル
  @test -L ~/.config/lazygit || ln -s {{pwd}}/HOME/.config/lazygit ~/.config/lazygit

# lazysqlコマンド用の設定ファイルを展開
lazysql:
  @test -L ~/.config/lazysql || ln -s {{pwd}}/HOME/.config/lazysql ~/.config/lazysql

# starship 用設定ファイルを展開
starship:
  # starship の設定ファイル
  @test -L ~/.config/starship.toml || ln -s {{pwd}}/HOME/.config/starship.toml ~/.config/starship.toml

# yazi 用設定ファイルを展開
yazi:
  # yazi の設定ファイル
  @test -L ~/.config/yazi || ln -s {{pwd}}/HOME/.config/yazi ~/.config/yazi
  # yazi のプラグインとカラーテーマのインストール
  @ya pack -a yazi-rs/flavors:catppuccin-mocha
  @ya pack -a h-hg/yamb
  @ya pack -a yazi-rs/plugins:full-border
  @ya pack -a Rolv-Apneseth/starship

# wezterm 用設定ファイルを展開
wezterm:
  # wezterm の設定ファイル・ディレクトリ
  @test -L ~/.config/wezterm || ln -s {{pwd}}/HOME/.config/wezterm ~/.config/wezterm

# JetBrains IDE - vim プラグイン用設定ファイルを展開
ideavim:
  # JetBrains IDE - vim プラグイン用設定ファイルを展開
  @test -L ~/.ideavimrc || ln -s {{pwd}}/HOME/.ideavimrc ~/.ideavimrc

# neovim 用設定ファイルを展開
neovim:
  # Neovim 設定ファイルを展開
  @test -L ~/.config/nvim || ln -s {{pwd}}/HOME/.config/nvim ~/.config/nvim
  # skk 用グローバル辞書ファイルを展開
  @test -L ~/.skk || ln -s {{pwd}}/HOME/skkeleton/dictionary ~/.skk
  # skk 用 ユーザ辞書ファイルを展開
  @test -L ~/.skkeleton || ln -s {{pwd}}/HOME/skkeleton/my_dictionary ~/.skkeleton
  # mcphub 用のMCP設定ディレクトリを展開
  @test -L ~/.config/mcphub || ln -s {{pwd}}/HOME/.config/mcphub ~/.config/mcphub

# ghostty 用設定ファイルを展開
ghostty:
  # ghostty 設定ファイルを展開
  @test -L ~/.config/ghostty || ln -s {{pwd}}/HOME/.config/ghostty ~/.config/ghostty

# zed 用設定ファイルを展開
zed:
  # zed 設定ファイルを展開
  @test -L ~/.config/zed/settings.json || ln -s {{pwd}}/HOME/.config/zed/settings.json ~/.config/zed/settings.json
  # zed キーマップ設定ファイルを展開
  @test -L ~/.config/zed/keymap.json || ln -s {{pwd}}/HOME/.config/zed/keymap.json ~/.config/zed/keymap.json
  # zed タスク設定ファイルを展開
  @test -L ~/.config/zed/tasks.json || ln -s {{pwd}}/HOME/.config/zed/tasks.json ~/.config/zed/tasks.json

# 各種リンターの設定ファイルを展開
linters:
  # yamllint 設定ファイルを展開
  @test -L ~/.config/yamllint || ln -s {{pwd}}/HOME/.config/yamllint ~/.config/yamllint
  # markdownlint 設定ファイルを展開
  @test -L ~/.markdownlintrc || ln -s {{pwd}}/HOME/.config/markdownlint/.markdownlintrc ~/.markdownlintrc

# ファイルの関連付け設定
apps:
  @duti -s dev.zed.Zed public.plain-text all
  @duti -s dev.zed.Zed public.data all
  @duti -s dev.zed.Zed .css all
  @duti -s dev.zed.Zed .csv all
  @duti -s dev.zed.Zed .d.ts all
  @duti -s dev.zed.Zed .env all
  @duti -s dev.zed.Zed .ini all
  @duti -s dev.zed.Zed .js all
  @duti -s dev.zed.Zed .json all
  @duti -s dev.zed.Zed .jsonc all
  @duti -s dev.zed.Zed .lock all
  @duti -s dev.zed.Zed .lua all
  @duti -s dev.zed.Zed .map all
  @duti -s dev.zed.Zed .md all
  @duti -s dev.zed.Zed .mjs all
  @duti -s dev.zed.Zed .php all
  @duti -s dev.zed.Zed .py all
  @duti -s dev.zed.Zed .scss all
  @duti -s dev.zed.Zed .sh all
  @duti -s dev.zed.Zed .sql all
  @duti -s dev.zed.Zed .test.js all
  @duti -s dev.zed.Zed .test.ts all
  @duti -s dev.zed.Zed .ts all
  @duti -s dev.zed.Zed .tsx all
  @duti -s dev.zed.Zed .txt all
  @duti -s dev.zed.Zed .toml all
  @duti -s dev.zed.Zed .xml all
  @duti -s dev.zed.Zed .yaml all
  @duti -s dev.zed.Zed .fish all

# OSの設定、ツールのインストール
initial: system-preferences brew-restore 

# 各種ツールの設定ファイルを展開
setup: initial zsh starship git lazygit yazi wezterm ideavim neovim ghostty zed linters
