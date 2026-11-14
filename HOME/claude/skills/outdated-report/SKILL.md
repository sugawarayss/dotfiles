---
name: outdated-report
description: >
  `brew outdated` と `mise outdated` を実行し、更新可能な各パッケージ/ツールについて
  リリースノート・CHANGELOGから変更点を調べ、解説とアップグレード推奨度を一覧で出力します。
  アップグレード自体は実行しません。
  ユーザーが「outdatedを確認して」「brewとmiseの更新内容を教えて」「アップグレードすべきものは？」
  「outdated-report」「/outdated-report」と入力した場合に使用します。
allowed-tools: Bash(brew outdated:*) Bash(brew info:*) Bash(brew uses:*) Bash(brew autoremove --dry-run) Bash(brew bundle cleanup --file=/Users/sugawarayss/PROJECTS/sugawarayss/dotfiles/homebrew/Brewfile) Bash(base64:*) Bash(mise outdated:*) Bash(mise registry:*) Bash(gh release:*) Bash(gh api:*) Bash(jq:*) WebFetch
user-invocable: true
---

Homebrew と mise の更新候補を洗い出し、変更点の解説とアップグレード推奨度をレポートする。**読み取り専用**で、`brew upgrade` / `mise upgrade` は実行しない（実行するかはユーザーが判断する）。

## 1. 更新候補を取得する

2つは独立しているので並列に実行する。

```bash
brew outdated --json=v2   # .formulae[] / .casks[]: name, installed_versions, current_version, pinned
mise outdated --json      # {<tool>: {current, latest, requested, source.path}}
```

候補が0件の側は「更新なし」とだけ書いて次へ進む。

あわせて、使われていない Homebrew パッケージも取得する（どちらも dry-run。**`--force` や `brew autoremove` 本体は実行しない**）。

```bash
brew autoremove --dry-run   # 依存元がなくなった formula（不要な依存）
brew bundle cleanup --file=/Users/sugawarayss/PROJECTS/sugawarayss/dotfiles/homebrew/Brewfile
# → "Would uninstall formulae:" / "Would uninstall casks:" の節が Brewfile 未記載のもの
#   "Would remove: ..." のキャッシュ行と "Would `brew cleanup`" 以降は無視する
```

ここで「未使用」と判定されたパッケージが outdated にも含まれている場合は、変更点の調査（ステップ2）を省き、レポートで「アップグレードより削除を推奨」とする。

## 2. 変更点の情報源を特定する

各候補について「現在のバージョン → 最新バージョン」の間の変更を調べる。情報源は次の順で探し、最初に見つかったものを使う。

| 対象 | 情報源の特定方法 |
| --- | --- |
| brew formula | `brew info --json=v2 <name>` の `.formulae[0].urls.stable.url` / `.homepage` から GitHub リポジトリを推定 |
| brew cask | `brew info --cask --json=v2 <name>` の `.casks[0].homepage` / `.url` |
| mise | `mise registry <tool>` のバックエンド（`aqua:owner/repo` / `github:owner/repo` / `ubi:owner/repo` 等）から GitHub リポジトリを特定。`core:<tool>`（node/python/go/dotnet 等）はリポジトリが出ないので、公式のリリースノート（例: nodejs/node の Releases、Python の What's New）を使う |

- GitHub リポジトリが分かれば `gh release list -R <owner/repo> --limit 30` で間のリリースを特定し、`gh release view <tag> -R <owner/repo> --json body,tagName,publishedAt` で本文を読む。複数リリースをまたぐ場合は間のリリースをすべて読む（メジャー更新の破壊的変更は途中のリリースに書かれていることが多い）。
- GitHub Releases の本文が空なら、リポジトリの `CHANGELOG.md` / `NEWS` を `gh api repos/<owner/repo>/contents/CHANGELOG.md --jq .content | base64 -d` で読む。
- GitHub 以外（公式サイトのリリースノート等）は WebFetch で読む。
- どこにも見つからなければ「変更点不明」とし、推測で内容を書かない。

候補が多い（目安10件超）場合は、Agent ツールで brew / mise などに分けて並列に調査させてよい。各agentには対象一覧と本ステップの手順、返す項目（下記レポートの1行分）を渡す。

## 3. 推奨度を判定する

| 推奨度 | 基準 |
| --- | --- |
| 🔴 高 | セキュリティ修正（CVE・脆弱性）を含む／自分が使っている機能の重大バグ修正 |
| 🟡 中 | 有用な新機能・性能改善・通常のバグ修正。破壊的変更なし |
| 🟢 低 | 依存ライブラリ（`brew uses --installed` で他から使われるだけのもの等）の軽微な更新、ドキュメント・内部変更のみ |
| ⚠️ 保留 | メジャー更新・破壊的変更あり。移行作業が必要な内容を具体的に書く |

- セキュリティ修正と破壊的変更を両方含む場合は ⚠️ とし、理由欄に「セキュリティ修正あり」を併記する。
- `pinned: true` の formula は判定はするが、表に「pin中」と明記する。
- mise で `requested` が固定バージョン（`latest` 以外）の場合、更新には設定ファイル（`source.path`）の編集が必要な旨を書く。

## 4. レポートを出力する

推奨度の高い順に並べ、brew と mise で表を分ける。

```markdown
## Homebrew（formula N件 / cask M件）

| 推奨度 | パッケージ | 現在 → 最新 | 主な変更点 | 理由 |
| --- | --- | --- | --- | --- |
| 🔴 高 | foo | 1.2.0 → 1.2.1 | CVE-2026-XXXX 修正 | セキュリティ修正 |

## mise（N件）

| 推奨度 | ツール | 現在 → 最新 | 主な変更点 | 理由 |
| --- | --- | --- | --- | --- |

## 未使用の Homebrew パッケージ

| 種別 | パッケージ | outdated | 備考 |
| --- | --- | --- | --- |
| 不要な依存 | libfoo | ✔ | `brew autoremove` で削除可 |
| Brewfile 未記載 | bar | | 使っているなら Brewfile へ追記、不要なら uninstall |

## 推奨コマンド
`brew upgrade foo bar` / `mise upgrade baz`（⚠️保留のものは除く）
```

- 「主な変更点」は1〜3項目に要約し、リリースノートの直訳を並べない。
- 情報源のURL（リリースページ）を各行に付けるか、表の後に脚注でまとめる。
- 最後の推奨コマンドは 🔴・🟡 のものだけを含める（未使用と判定したものは除く）。不要な依存があれば `brew autoremove` も併記する。Brewfile 未記載のものは手動インストールの可能性があるため、uninstall コマンドは出さずユーザーの判断に委ねる。
