# SKILLs

## ユーザ呼び出し

frontmatter に `disable-model-invocation: true` が明記され、モデルからの自発呼び出しが無効化されているスキル。

- [improve-codebase-architecture](./improve-codebase-architecture/SKILL.md) - コードベースをスキャンして改善の機会をHTMLレポートで提示し、選択したレポートを検証する。

## モデルからも呼び出し可能

上記以外のスキル。ユーザからのトリガーフレーズに加え、モデルが状況に応じて自発的に呼び出す。

- [audit-review](./audit-review/SKILL.md) - リポジトリ全体を対象に過剰設計を検出し、削除・簡素化が必要な箇所をランク付けする。
- [codebase-design](./codebase-design/SKILL.md) - ディープモジュールを設計するための共通の規律と語彙。
- [complexity-review](./complexity-review/SKILL.md) - 差分に対する過剰設計の検出。削除対象・代替案を1行ずつ報告する。
- [diagnosing-bugs](./diagnosing-bugs/SKILL.md) - 深刻なバグやパフォーマンス低下に対する規律ある診断ループ。
- [doc-coauthoring](./doc-coauthoring/SKILL.md) - ソースコード全体を参照し、ドキュメントをmarkdownファイルとして生成する。
- [domain-modeling](./domain-modeling/SKILL.md) - プロジェクトのドメインモデルを構築し、磨き上げる。
- [explain-code](./explain-code/SKILL.md) - コードの動作を視覚的な図とアナロジーで説明する。
- [find-skills](./find-skills/SKILL.md) - 目的に合ったAgent Skillを検索・インストールする。
- [gen-pytest](./gen-pytest/SKILL.md) - pytestを使用したユニットテストコードを実装する。
- [grill-me](./grill-me/SKILL.md) - 計画や設計について、意思決定ツリーのすべての分岐が解決されるまでインタビューする。
- [grilling](./grilling/SKILL.md) - 計画やデザインについて、意思決定ツリーのすべての分岐が解決されるまでユーザーにインタビューする。
- [grill-with-docs](./grill-with-docs/SKILL.md) - 既存のドメインモデルに照らして計画を検証し、`CONTEXT.md`とADRをインラインで更新する。
- [review-local](./review-local/SKILL.md) - ローカルブランチとベースブランチのdiffを正確性・バグ観点でレビューし、critにインラインコメントとして投稿する。
- [review-pr](./review-pr/SKILL.md) - プルリクエストの品質・セキュリティ・パフォーマンス・テスト・ドキュメントをレビューする。
