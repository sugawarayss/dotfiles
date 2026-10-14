# セキュリティ

言語・フレームワークを問わず全コードに適用する。認証・ユーザー入力・シークレット・APIエンドポイント・ファイルアップロードを扱う実装では、`security-checklist` スキルの詳細チェックリストも参照する。

## コミット前の必須チェック

- [ ] シークレット（APIキー・パスワード・トークン）をハードコードしていない
- [ ] ユーザー入力をスキーマ（Pydantic / zod）で検証している
- [ ] SQLはパラメータ化クエリ / ORM経由で組み立てている（文字列連結・f-stringで組み立てない）
- [ ] ユーザー由来のHTMLを無害化せずに描画していない（`dangerouslySetInnerHTML` 等）
- [ ] 状態を変更する操作で認証・認可（所有者・ロール）を確認している
- [ ] エラーレスポンス・ログに機密情報（スタックトレース・パスワード・トークン・個人情報）を含めていない

## シークレット管理

シークレットは環境変数（または秘密情報管理サービス）から読み込み、未設定なら起動時に失敗させる。

```python
# BAD
api_key = "sk-proj-xxxxx"

# GOOD: pydantic-settings で必須項目として宣言し、未設定なら起動時に検出する
class Settings(BaseSettings):
    openai_api_key: SecretStr
```

```typescript
// GOOD
const apiKey = process.env.OPENAI_API_KEY
if (!apiKey) {
  throw new Error('OPENAI_API_KEY not configured')
}
```

- `.env` / `.env.local` は `.gitignore` に含め、コミットしない（サンプルは `.env.example` に値なしで置く）。

## セキュリティ問題を発見したときの対応

1. 現在の作業を止め、ユーザーに報告する
2. `security-reviewer` エージェントで影響範囲を分析する
3. CRITICALな問題は他の作業より先に修正する
4. シークレットが露出していた場合は、修正とあわせてローテーションが必要な旨をユーザーに伝える（git履歴に残っている可能性も含めて）
5. 同種の問題が他の箇所にないか、コードベース全体をgrepで横展開して確認する（[[design_principles]] の「変更の網羅性の原則」）
