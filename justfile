# 共通の変数
pwd := `pwd`

# デフォルトはタスクのリスト表示
default: _list


# 定義済タスクリスト表示
_list:
  @just --list

#  Brewfile からパッケージをインストール
brew-restore:
  # Brewfile から全てのパッケージをインストール
  @brew bundle --file {{pwd}}/homebrew/Brewfile

# Brewfile を更新
brew-dump:
  @brew bundle dump --force --file {{pwd}}/homebrew/Brewfile


# skk 辞書ファイルのユーザ辞書をdumpする
skk-dump:
  # 上書きする
  @cp -f ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/my_dictionary {{pwd}}/HOME/skkeleton/my_dictionary

# OSの設定、ツールのインストール
# OSの設定は mise bootstrap に移行
initial: brew-restore

