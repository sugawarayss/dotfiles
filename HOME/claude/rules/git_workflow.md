# Git WorkFlow規約

## ブランチ戦略

意図しないデプロイやCI/CDの実行を避けるため
`develop`ブランチから作業ブランチを作成し、作業する。
**`main`ブランチへのPRは人間が実施** する。

`main` ← `develop` ← 各 `feature*`/`fix*` ブランチ、という2段構成。作業ブランチは `develop` から分岐して `develop` にマージし、`develop` から `main` へのマージ（PR）は人間が行う。

## ブランチ命名

- `feature/<内容>`: 新機能の追加
- `refactor/<内容>`: 動作に変更のない改善
- `fix/<内容>`: バグ修正
- `docs/<内容>`: 開発用資料の追加や変更
- `chore/<内容>`: ソースコード以外()の変更

### GitHub Issueやタスク管理ツールから起因する変更の場合

修正がGitHub Issue や、ClickUpなどのタスク管理サービスから起因している場合は、
その番号またはIDを先頭に付与する。

- issue番号がある場合は先頭に含める(例: `feature/123-add-login`)
- チケットIDがある場合は先頭に含める(例: `feature/<ticket-id>-add-login`)

## コミットメッセージ

`<type>: <説明>` の形式で書く。説明は命令形・簡潔に。

- `add`: 新規追加
- `update`: 既存の変更・改善
- `style`: コードフォーマットの変更
- `fix`: バグ修正
- `remove`: 削除
- `refactor`: 振る舞いを変えないコード整理
- `chore`: ソースコード以外(依存関係、ビルドやCI/CD設定)の変更

```text
# BAD
コミット

# GOOD
update: ユーザー認証のエラーハンドリングを追加
```

## コミット・PRの粒度

- 1つのコミットは1つの論理的変更に絞る(フォーマット変更と機能追加を混ぜない)。
- 1つのPRは1つの目的に絞る。レビューしやすさを優先し、無関係な変更を含めない。
- 巨大な差分になる場合は、意味のある単位でコミットを分割する。

## マージ・リベース方針

- feature/fixブランチをmainに追従させる際は、公開済みの共有ブランチに対する force-push を避ける(自分のfeatureブランチ上でのrebaseは可)。
- コンフリクト解消は自動解決に頼らず、両方の変更意図を確認してから解消する。

## `gh issue create` / `gh pr create` の本文作成

`--body "$(cat <<'EOF' ... EOF)"` のヒアドキュメント経由で本文を渡すと、全角チルダ「〜」などのconfusable Unicode文字が含まれる場合にTirithフック（`Tirith: [HIGH] Confusable Unicode characters in text`）でブロックされることがある。

- 1回ブロックされた時点で、該当しそうな文字を推測して同じヒアドキュメント方式で再試行しない（原因の特定に何度も失敗を重ねるだけで、直前と同じ理由で再ブロックされやすい）。
- 直ちに本文をスクラッチディレクトリのファイルに書き出し（`Write`ツール）、`--body-file <path>` オプションで渡す方式に切り替える。ヒアドキュメントを経由しないため同フックの対象にならない。

```bash
# NG: ヒアドキュメントで再試行を繰り返す
gh issue create --title "..." --body "$(cat <<'EOF'
...
EOF
)"

# OK: ファイル経由に切り替える
gh issue create --title "..." --body-file /path/to/scratchpad/issue-body.md
```
