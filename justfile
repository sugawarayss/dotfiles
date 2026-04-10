# 共通の変数
pwd := `pwd`

# デフォルトはタスクのリスト表示
default: _list

# claude code 用設定ファイル
claude:
  # @type -q npm || mise install node@latest
  # @type -q claude || npm install -g @anthropic-ai/claude-code
  @test -d ~/.claude || mkdir -p ~/.claude
  # @test -L ~/.claude/CLAUDE.md || ln -s {{pwd}}/HOME/claude/CLAUDE.md ~/.claude/CLAUDE.md
  @test -L ~/.claude/settings.json || ln -s {{pwd}}/HOME/claude/settings.json ~/.claude/settings.json
  # @test -L ~/.claude/mcp_config.json || ln -s {{pwd}}/HOME/claude/mcp_config.json ~/.claude/mcp_config.json
  # @test -L ~/.claude/commands || ln -s {{pwd}}/HOME/claude/commands ~/.claude/commands
  @test -L ~/.claude/skills || ln -s {{pwd}}/HOME/claude/skills ~/.claude/skills
  @test -L ~/.claude/statusline.sh || ln -s  {{pwd}}/HOME/claude/statusline.sh ~/.claude/statusline.sh


claude-mcp:
  # mcpを追加
  claude mcp add aws-knowledge --transport stdio --scope user -- uvx fastmcp run https://knowledge-mcp.global.api.aws
  claude mcp add context7 --transport stdio --scope user -- npx -y @upstash/context7-mcp
  claude mcp add serena --transport stdio --scope user -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --project-from-cwd
  claude mcp add playwright --transport stdio --scope user -- npx @playwright/mcp@latest


node:
  # npmの設定ファイルを展開
  @test -L ~/.npmrc || ln -s {{pwd}}/HOME/.npmrc ~/.npmrc

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
  @test -d ~/.config/fish || mkdir -p ~/.config/fish
  @test -d ~/.config/fish/conf.d || mkdir -p ~/.config/fish
  # 設定ファイルを展開
  @test -L ~/.config/fish/config.fish || ln -s {{pwd}}/HOME/.config/fish/config.fish ~/.config/fish/config.fish
  @test -L ~/.config/fish/conf.d/bobthefish.fish || ln -s {{pwd}}/HOME/.config/fish/conf.d/bobthefish.fish ~/.config/fish/conf.d/bobthefish.fish
  # デフォルトシェルをfishに変更
  echo $(which fish) | sudo tee -a /etc/shells
  chsh -s $(which fish)
  @echo "you need restart your terminal for switch to fish shell"

# fishプラグインマネージャ
fisher:
  @test -L ~/.config/fish/fish_plugins || ln -s {{pwd}}/HOME/.config/fish/fish_plugins ~/.config/fish/fish_plugins
  # fisher のインストール
  @type -q fisher || curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  fisher update

# fzfコマンドのデフォルトオプション
fzf:
  @test -L ~/.config/fzf || ln -s {{pwd}}/HOME/.config/fzf ~/.config/fzf

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

# Karabiner-Elementsの設定ファイルを展開
karabiner:
  @test -d ~/.config/karabiner || mkdir -p ~/.config/karabiner
  @test -L ~/.config/karabiner/karabiner.json || ln -s {{pwd}}/HOME/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

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
  # git-delta用のtheme設定
  @test -L ~/.config/git/themes.gitconfig || ln -s {{pwd}}/HOME/.config/git/themes.gitconfig ~/.config/git/themes.gitconfig
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
  # gh-prism 拡張(PR review)のインストール
  @gh extension install kawarimidoll/gh-prism

# git 関連の設定を展開
git: _git-config _gh-config _gh-extensions

# lsd (ls 代替コマンド)の設定ファイル
lsd:
  @test -d ~/.config/lsd || mkdir ~/.config/lsd
  @test -L ~/.config/lsd/config.yaml || ln -s {{pwd}}/HOME/.config/lsd/config.yaml ~/.config/lsd/config.yaml

# lazygitコマンド用の設定ファイルを展開
lazygit:
  # lazygit の設定ファイル
  @test -L ~/.config/lazygit || ln -s {{pwd}}/HOME/.config/lazygit ~/.config/lazygit

# lazysqlコマンド用の設定ファイルを展開
lazysql:
  @test -L ~/.config/lazysql || ln -s {{pwd}}/HOME/.config/lazysql ~/.config/lazysql

# lazydockerコマンド用の設定ファイルを展開
lazydocker:
  @test -L ~/.config/lazydocker || ln -s {{pwd}}/HOME/.config/lazydocker ~/.config/lazydocker
# starship 用設定ファイルを展開
starship:
  # starship の設定ファイル
  @test -L ~/.config/starship.toml || ln -s {{pwd}}/HOME/.config/starship.toml ~/.config/starship.toml

# yazi 用設定ファイルを展開
yazi:
  # yazi の設定ファイル
  @test -L ~/.config/yazi || ln -s {{pwd}}/HOME/.config/yazi ~/.config/yazi
  # yazi/package.toml からプラグインをinstall
  @ya pkg install

# wezterm 用設定ファイルを展開
wezterm:
  # wezterm の設定ファイル・ディレクトリ
  @test -L ~/.config/wezterm || ln -s {{pwd}}/HOME/.config/wezterm ~/.config/wezterm

# JetBrains IDE - vim プラグイン用設定ファイルを展開
ideavim:
  # JetBrains IDE - vim プラグイン用設定ファイルを展開
  @test -L ~/.ideavimrc || ln -s {{pwd}}/IntelliJ/.ideavimrc ~/.ideavimrc

# neovim 用設定ファイルを展開
neovim:
  # Neovim 設定ファイルを展開
  @test -L ~/.config/nvim || ln -s {{pwd}}/HOME/.config/nvim ~/.config/nvim
  # mcphub 用のMCP設定ディレクトリを展開
  @test -L ~/.config/mcphub || ln -s {{pwd}}/HOME/.config/mcphub ~/.config/mcphub

# skkの辞書ファイルを展開
skk:
  # グローバル辞書ファイルを展開(macSKKはシンボリックリンクはNGなのでコピー)
  @test -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.L || cp -f {{pwd}}/HOME/skkeleton/dictionary/SKK-JISYO.L ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.L
  @test -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JOSYO.geo || cp -f {{pwd}}/HOME/skkeleton/dictionary/SKK-JISYO.geo ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.geo
  @test -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JOSYO.junmei || cp -f {{pwd}}/HOME/skkeleton/dictionary/SKK-JISYO.jinmei ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.jinmei
  @test -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JOSYO.propernoun || cp -f {{pwd}}/HOME/skkeleton/dictionary/SKK-JISYO.propernoun ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.propernoun
  @test -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JOSYO.station || cp -f {{pwd}}/HOME/skkeleton/dictionary/SKK-JISYO.station ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.station
  # ユーザ辞書ファイルを展開(macSKKはシンボリックリンクはNGなのでコピー)
  @test -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/my_dictionary || cp -f {{pwd}}/HOME/skkeleton/my_dictionary ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/my_dictionary

# skk 辞書ファイルのユーザ辞書をdumpする
skk-dump:
  # 上書きする
  @cp -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/my_dictionary {{pwd}}/HOME/skkeleton/my_dictionary

# ghostty 用設定ファイルを展開
ghostty:
  # ghostty 設定ファイルを展開
  @test -L ~/.config/ghostty || ln -s {{pwd}}/HOME/.config/ghostty ~/.config/ghostty

# zellij 用設定ファイルを展開
zellij:
  @test -d ~/.config/zellij || ln -s {{pwd}}/HOME/.config/zellij ~/.config/zellij
  @test -d ~/.config/zellij/plugins/ || mkdir {{pwd}}/HOME/.config/zellij/plugins
  # zellij-what-time.wasmのインストール
  @curl -L "https://github.com/pirafrank/zellij-what-time/releases/latest/download/zellij-what-time.wasm" -o {{pwd}}/HOME/.config/zellij/plugins/zellij-what-time.wasm

# borders 用設定ファイルを展開
borders:
  @test -d ~/.config/borders || ln -s {{pwd}}/HOME/.config/borders ~/.config/borders
  # @brew services restart borders

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
  @test -d ~/.config/markdownlint || ln -s {{pwd}}/HOME/.config/markdownlint ~/.config/markdownlint

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

# glide browserの設定
glide:
  @test -L ~/.config/glide || ln -s {{pwd}}/HOME/.config/glide ~/.config/glide

# chawan(TUIブラウザ)の設定ファイル
chawan:
  # ~/.config/chawan/config.toml
  @test -d ~/.config/chawan || mkdir ~/.config/chawan
  @test -L ~/.config/chawan/config.toml || ln -s {{pwd}}/HOME/.config/chawan/config.toml ~/.config/chawan/config.toml

# OSの設定、ツールのインストール
initial: system-preferences brew-restore

# 各種ツールの設定ファイルを展開
setup: initial zsh starship git lazygit yazi wezterm ideavim neovim ghostty zed linters
