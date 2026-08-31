# 利用可能なCLIツール

以下に記載しているCLIツールは積極的に使用してよい
使いかたは `--help` オプションで確認する

## 直接実行が拒否されるコマンド（先に確認する）

`cat` / `find` / `head` / `tail` は `settings.json` の `permissions.deny` によりBashから直接実行できない（パイプの片側に置いた場合も拒否される）。以下の代替に置き換えてから実行する。

| 拒否されるコマンド | 代替 |
| --- | --- |
| `cat` | `bat`、または `Read` ツール |
| `find` | `fd`、または `Glob`/`Grep` ツール |
| `head` / `tail` | `Read` ツールの `offset`/`limit`、または `rg`/`fd` の出力自体を絞り込む |

## bat

    `cat` の代替。シンタックスハイライトと行番号付きでファイルの内容を表示する

## eza

    `ls` の代替。アイコン・Gitステータス・ツリー表示に対応したファイル一覧表示ツール

## fd

    `find` の代替。シンプルな構文で高速にファイル・ディレクトリを検索する

## sd

    `sed` の代替。正規表現による文字列検索・置換をシンプルな構文で行う
    例: `sd 'foo' 'bar' file.txt`（ファイル内の `foo` を `bar` に置換）

## ripgrep

    `grep` の代替。`.gitignore` を認識し高速にコード検索を行う（コマンドは `rg`）

## pandoc

    Markdown, HTML, LaTex, reStrucredTextなどの形式のファイルを、**Markdown**, **HTML**, **LaTex**,  **Word**, **PDF** などに変換するツール

## jq

    JSON データの整形・抽出・変換を行うツール
    例: `jq '.foo.bar' file.json`（`foo.bar` フィールドを抽出）

## yq

    YAML/TOML/XML データの整形・抽出・変換を行うツール（`jq` のYAML版）
    例: `yq '.foo.bar' file.yaml`（`foo.bar` フィールドを抽出）
