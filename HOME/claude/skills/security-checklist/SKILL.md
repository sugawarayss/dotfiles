---
name: security-checklist
description: >
  認証・認可の実装、ユーザー入力やファイルアップロードの処理、シークレットの扱い、APIエンドポイントの追加、
  決済・個人情報など機密データの保存・送信、外部APIとの連携を実装・レビューするときに使う、セキュリティチェックリストと実装パターン集。
  「セキュリティ観点で確認して」「この実装は安全？」「security-checklist」「/security-checklist」と言われた場合や、
  上記に該当する実装に着手する場合に使用する。差分のレビューコメント投稿は review-local / review-pr が担い、このスキルはその観点・基準を提供する。
---

# セキュリティレビュー

横断ルール [[security]]（`rules/security.md`）のコミット前チェックを、項目ごとに詳細化したチェックリスト。
対象コードに関係する節だけを確認し、該当しない節は飛ばしてよい。

## 1. シークレット管理

```python
# BAD
api_key = "sk-proj-xxxxx"
db_password = "password123"

# GOOD
class Settings(BaseSettings):
    openai_api_key: SecretStr
    database_url: PostgresDsn
```

- [ ] APIキー・トークン・パスワードがソースコードに含まれていない
- [ ] `.env` 系ファイルが `.gitignore` に含まれている
- [ ] git履歴にシークレットが残っていない（`git log -p -S '<キーの一部>'` 等で確認）
- [ ] 本番のシークレットはデプロイ先の秘密情報管理機能に置かれている
- [ ] `SecretStr` 等を使い、`repr` やログに値が出ないようにしている

## 2. 入力検証

境界（APIリクエスト・フォーム・外部APIレスポンス・ファイル）で必ずスキーマ検証してから内部に渡す。

```python
class CreateUserRequest(BaseModel):
    email: EmailStr
    name: str = Field(min_length=1, max_length=100)
    age: int = Field(ge=0, le=150)
```

```typescript
const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().min(0).max(150),
})
const validated = CreateUserSchema.parse(input)
```

ファイルアップロードは、サイズ・MIMEタイプ・拡張子を**許可リスト**で検証する。保存時のファイル名にユーザー入力をそのまま使わない（パストラバーサル対策）。

- [ ] 全てのユーザー入力をスキーマで検証している
- [ ] 文字列長・数値範囲・列挙値に上限/下限を設けている
- [ ] 拒否リストではなく許可リストで検証している
- [ ] アップロードのサイズ・種類・拡張子を制限している
- [ ] ファイルパスにユーザー入力を直接連結していない

## 3. SQLインジェクション

```python
# BAD
db.execute(text(f"SELECT * FROM users WHERE email = '{email}'"))

# GOOD
db.execute(select(User).where(User.email == email))
db.execute(text("SELECT * FROM users WHERE email = :email"), {"email": email})
```

- [ ] クエリはORM / パラメータ化で組み立てている
- [ ] 並び替えカラム名など識別子をユーザー入力から受ける場合は、許可リストで照合している

## 4. 認証・認可

- 認可チェックは操作の**前**に、サーバー側で行う（フロントエンドの表示制御だけに頼らない）。
- 他人のリソースへのアクセス（IDOR）を防ぐため、IDで取得したリソースの所有者・所属組織を確認する。

```python
@router.delete("/users/{user_id}")
def delete_user(user_id: int, current_user: User = Depends(get_current_user)):
    if not current_user.is_admin:
        raise HTTPException(status_code=403)
    ...
```

- トークンは `localStorage` ではなく `HttpOnly; Secure; SameSite` のcookieに保存する（XSSでの窃取を防ぐ）。

- [ ] 全ての状態変更エンドポイントに認証がかかっている
- [ ] リソース単位の所有者・組織チェックがある
- [ ] ロール判定が共通の依存関数・ヘルパーに集約されている（エンドポイントごとの手書きになっていない）
- [ ] セッション・トークンに有効期限がある

## 5. XSS

- Reactの自動エスケープに任せ、`dangerouslySetInnerHTML` は原則使わない。使う場合は DOMPurify 等で許可タグを絞って無害化する。
- `href` にユーザー入力を入れる場合は `javascript:` スキームを拒否する。

- [ ] ユーザー由来のHTMLを無害化している
- [ ] CSPヘッダーを設定している

## 6. CSRF

- cookie認証で状態変更を受け付ける場合、`SameSite` 属性とCSRFトークン（またはOriginヘッダー検証）で防ぐ。
- Bearerトークン（Authorizationヘッダー）のみで認証するAPIは対象外。

- [ ] cookie認証の状態変更操作にCSRF対策がある
- [ ] CORSの許可オリジンを明示しており、`*` と credentials を併用していない

## 7. レート制限

- [ ] ログイン・パスワードリセット・OTP検証など総当たりされうるエンドポイントに回数制限がある
- [ ] 検索・エクスポート・外部API呼び出しなど高コストな処理に制限がある

## 8. 機密データの露出

```python
# BAD
logger.info("login: email=%s password=%s", email, password)
return JSONResponse({"error": str(exc), "trace": traceback.format_exc()}, status_code=500)

# GOOD
logger.info("login: user_id=%s", user.id)
logger.exception("unexpected error")
return JSONResponse({"error": "Internal Server Error"}, status_code=500)
```

- [ ] ログにパスワード・トークン・カード番号・個人情報を出していない
- [ ] ユーザー向けエラーは汎用メッセージにし、詳細はサーバーログのみに残している
- [ ] レスポンススキーマで返却フィールドを明示している（ORMモデルをそのまま返さず、パスワードハッシュ等が漏れない）

## 9. 依存関係

```bash
pnpm audit
uvx pip-audit
```

- [ ] 既知の脆弱性がない（または影響なしと判断済み）
- [ ] ロックファイル（`pnpm-lock.yaml` / `uv.lock`）をコミットしている
- [ ] CIでは `pnpm install --frozen-lockfile` / `uv sync --locked` を使っている
- [ ] Dependabot / Renovate 等で更新を追跡している

## 10. セキュリティテスト

認証・認可・入力検証の拒否ケースはテストで固定する（[[pytest_coding]] に従う）。

- [ ] 未認証で 401 になる
- [ ] 権限不足・他人のリソースで 403 / 404 になる
- [ ] 不正な入力で 422（または 400）になる
- [ ] レート制限の超過で 429 になる（制限を実装した場合）

## 報告フォーマット

チェック結果は、問題のある項目だけを重大度順に報告する。

```text
[CRITICAL|HIGH|MEDIUM|LOW] <ファイル>:<行> <問題点> → <修正案>
```

CRITICAL（シークレット露出・認可漏れ・インジェクション）が見つかった場合は、[[security]] の「セキュリティ問題を発見したときの対応」に従う。

## 参考

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [FastAPI Security](https://fastapi.tiangolo.com/tutorial/security/)
- [Next.js Security](https://nextjs.org/docs/app/guides/data-security)
