# SKILLs

## ユーザ呼び出し

frontmatter に `disable-model-invocation: true` が明記され、モデルからの自発呼び出しが無効化されているスキル。

- [improve-codebase-architecture](./improve-codebase-architecture/SKILL.md) - コードベースをスキャンして改善の機会をHTMLレポートで提示し、選択したレポートを検証する。

## モデルからも呼び出し可能

上記以外のスキル。ユーザからのトリガーフレーズに加え、モデルが状況に応じて自発的に呼び出す。

- [audit-review](./audit-review/SKILL.md) - リポジトリ全体を対象に過剰設計を検出し、削除・簡素化が必要な箇所をランク付けする。
- [codebase-design](./codebase-design/SKILL.md) - ディープモジュールを設計するための共通の規律と語彙。
- [diagnosing-bugs](./diagnosing-bugs/SKILL.md) - 深刻なバグやパフォーマンス低下に対する規律ある診断ループ。
- [domain-modeling](./domain-modeling/SKILL.md) - プロジェクトのドメインモデルを構築し、磨き上げる。
- [find-skills](./find-skills/SKILL.md) - 目的に合ったAgent Skillを検索・インストールする。
- [grill-with-docs](./grill-with-docs/SKILL.md) - 既存のドメインモデルに照らして計画を検証し、`CONTEXT.md`とADRをインラインで更新する。
- [outdated-report](./outdated-report/SKILL.md) - `brew outdated`/`mise outdated` の更新候補について変更点を調べ、解説とアップグレード推奨度を出力する。
- [review-local](./review-local/SKILL.md) - ローカルブランチとベースブランチのdiffを正確性・バグ観点でレビューし、critにインラインコメントとして投稿する。
- [review-pr](./review-pr/SKILL.md) - プルリクエストの品質・セキュリティ・パフォーマンス・テスト・ドキュメントをレビューする。
- [security-checklist](./security-checklist/SKILL.md) - 認証・入力・シークレット・API追加時のセキュリティチェックリストと実装パターン集。
