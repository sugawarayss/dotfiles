## Pythonコード実装のルール

pythonファイルの変更後には、プロジェクトで利用しているLinter/TypeCheckerでチェックを実施し指摘が無いことを確認する。

- `ruff` - Linting Rule は pyproject.toml に記載されている
- `ty` または `mypy` - Check Rule は pyproject.toml に記載されている

<exception>
`tests/test_*.py` において、テストケースの実施のために必要な実装が、ルール違反となる場合は指摘を無視するコメントを入れて抑制してよい。
</exception>

### Pythonicな実装

#### 数値の範囲チェックは連結する

```python
# BAD
if 18 <= age and age < 60:

# GOOD
if 18 <= age < 60:
```

#### 候補との一致判定には `in` 演算子を使用する

```python
# BAD
if role == "admin" or role == "editor":

# GOOD
if role in ("admin", "editor"):
```

#### ループインデックスが必要な場合は `enumerate` を使用する

```python
# BAD
for i in range(len(my_list)):
    print(f"{i+1}: {my_list[i]}")

# GOOD
for i, elem in enumerate(my_list):
    print(f"{i+1}: {elem}")
```

#### 複数のコレクションを並列に扱う場合は `zip` を使用する

```python
# BAD
for i, name in enumerate(names):
    score = scores[i]
    print(f"{name}: {score}")

# GOOD
for name, score in zip(names, scores, strict=True):
    print(f"{name}: {score}")
```

#### 単純な変換・フィルタにはループの代わりに内包表記を使用する

```python
# BAD
squares = []
for x in nums:
    if x % 2 == 0:
        squares.append(x ** 2)

# GOOD
squares = [x ** 2 for x in nums if x % 2 == 0]
```

#### `__init__` のみのデータ保持クラスには `dataclass` を使用する

```python
# BAD
class Point:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

# GOOD
@dataclass
class Point:
    x: float
    y: float
```

### 型システムと型アノテーション

- すべての関数シグネチャとクラス属性への型ヒントを付与する
- ダックタイピングには `Protocol` を使用する
- 複雑な型は `TypeAlias`（または `type` 文）でエイリアスを定義する
- 値域を絞りたい定数には `Literal` 型を使用する
- 構造化された辞書には `TypedDict` を使用する

```python
# BAD
def get_user(id):
    ...

UserRole = str  # 任意の文字列を受け付けてしまう

# GOOD
def get_user(id: int) -> User:
    ...

UserRole: TypeAlias = Literal["admin", "editor", "viewer"]
```

### スタイル

パフォーマンスには寄与しないが、可読性が向上するので理由が無ければ遵守する。

#### メドッド定義にはdocstringを書く

`reStrucredText`型式のdocstringで記述する。

```python
def is_even(x: int) -> bool:
    """
    数値が偶数であるか判定する

    :param x: 判定対象の数値
    :return: True: 偶数 / Fasle: 奇数
    :raises: ValueError
    """
    if not isinstance(x, int):
        raise ValueError("arg `x` must be int")
    return x % 2 == 0
```

#### メソッド呼び出しやインスタンスの生成時にはキーワード付き引数を使用する

呼び出し時にどの引数への値の受け渡しかを読み取り易くする目的であるので、定義を変更する必要はない。

```python
# BAD
z: int = add(1, 2)

# GOOD
z: int = add(x=1, y=2)
```

### エラーハンドリング

#### try/exceptのスコープをリファクタで後退させない

パフォーマンス改善などのリファクタで、既存のtry/except境界（例: ユーザー単位）を外側（例: 組織単位）に持ち出す場合、1件の失敗がその外側の粒度全体を未捕捉例外でクラッシュさせないか確認する。エラー処理の粒度は変更前後で保つ（[[design_principles]]の「リファクタ時の注意」参照）。

#### try/except内の例外発生源を削除してハンドラを無意味化しない

try/except境界自体を変更していなくても、リファクタでその内部から「実際に例外を送出しうる呼び出し」（例: DBへのflush/commit）を削除・置換すると、ハンドラは実質何も捕捉しなくなる。docstring等に「失敗時は例外を伝播させない」といった保証が明記されている場合、その記述と実装が乖離したまま気づかれにくい。例外を発生させる操作をtry/except内から削除・変更する際は、ハンドラが引き続き意図した失敗を捕捉できるか、ドキュメントの記述と実装が一致しているかを確認する（[[design_principles]]の「リファクタ時の注意」参照）。

#### 定期実行バッチは対象単位で障害を分離し、再実行できるようにする

複数の対象（組織・ユーザー等）を順に処理するバッチ・ワーカーでは、1対象の失敗がプロセス全体や他対象の処理を止めないようにする。

- 対象ごとのtry/exceptには、処理本体だけでなく、その対象の設定値を読んで計算する前処理（スケジュール計算・事前集計等）も含める。DBに保存された設定値は、書き込み側のバリデーション（`ge`/`le`等）と、読み出し側の障害分離の両方で守る。
- 失敗ログには、手動で再実行するのに必要なキー（対象ID・対象日など）をすべて含める。
- 遅れた分を追いついて実行する仕組みを入れる場合は、長時間停止した後に一斉実行して負荷が集中しないよう上限を設けるか、許容することを明記する。前回実行時刻をプロセス内にしか持たない場合、再起動中の予定分は失われることを仕様書に書く。

#### 汎用的な `Exception` ではなく、ドメイン固有の例外クラスを定義する

呼び出し側が `except` で特定のエラーだけを狙って捕捉できるようにする。

```python
# BAD
raise Exception("user not found")

# GOOD
class UserNotFoundError(Exception):
    pass

raise UserNotFoundError(f"user not found: id={user_id}")
```

#### 不変条件の検証と更新の間に排他を入れる

「循環しない」「上限を超えない」のように複数行にまたがる不変条件を、読み取ってから検証して更新する処理では、並行する2つのリクエストがどちらも古い状態を見て検証を通過し、結果として不変条件が破れることがある（TOCTOU）。親の行や組織の行に対する `SELECT ... FOR UPDATE`、advisory lock、DB制約などで直列化する。発生確率が低く許容する場合は、その理由をdocstringに残す。

### パフォーマンス

#### 要素数が多くなり得る場合は `generator` を使用する

リスト化して返却すると要素が全てメモリに載ってしまうため、メモリ効率が良くない

```python
# BAD
def load_value(path: Path) -> list[int]:
    ret_list = []
    with open(path, "r") as f:
        for line in f:
            ret_list.append(int(line))
    return ret_list

# GOOD
def load_value(path: Path) -> Generator[int]:
    with open(path, "r") as f:
        for line in f:
            yield int(line)
```

#### 引数に対して結果が決まる純粋関数で、計算コストが高いものは `functools.lru_cache` でキャッシュする

```python
# BAD
def fibonacci(n: int) -> int:
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# GOOD
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci(n: int) -> int:
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

#### モジュールのインポートに相対パスを使用しない

```python
# BAD
from .module import foo

# GOOD
from root.module import foo
```

#### ループ内でのN+1を避ける

バッチ処理でユーザー/レコード単位のループ内から、同じ入力（組織・期間など）に対して重複するDB問い合わせや計算を行っていないか確認する。入力が同じなら計算はループの外側で1回だけ行い、辞書等でキャッシュする。

```python
# BAD
for user in users:
    org = db.query(Organization).get(user.org_id)  # 同じorg_idでも毎回問い合わせる
    process(user, org)

# GOOD
org_cache: dict[int, Organization] = {}
for user in users:
    if user.org_id not in org_cache:
        org_cache[user.org_id] = db.query(Organization).get(user.org_id)
    process(user, org_cache[user.org_id])
```

#### 同じ条件に対する類似クエリは統合する

同じ条件（組織・期間など）に対する複数の類似クエリ（別々のチェック関数がそれぞれ発行するもの）を1クエリに統合できないか検討する。

#### 事後フィルタではなくSQL側のWHERE句で絞り込む

Python側のループで事後的にフィルタしている条件は、可能な限りSQLのWHERE句に前倒しし、不要な行の転送・処理を避ける。

```python
# BAD
records = db.query(Record).all()
active = [r for r in records if r.status == "active"]

# GOOD
active = db.query(Record).filter(Record.status == "active").all()
```

#### 用途に対して過剰なデータを取得しない

取得関数を差し替える・共用する際は、呼び出し側が実際に参照する列・関連だけを取得しているか確認する。

- 参照しないリレーションを eager load（`selectinload`/`joinedload`）する関数を共用しない。用途別に取得関数を分ける。
- IDだけ使うのにエンティティ全体（重い列・暗号化列を含む）を取得しない。必要な列だけをSELECTする関数にする。
- 同じ処理内で取得済みの行を、`refresh` 等でもう一度取得しない（`refresh` は identity map を使わず必ずクエリを発行する）。取得済みのオブジェクトを保持して再利用する。

```python
# BAD: 存在確認で取得した template を捨て、commit 後に同じ行を再取得している
await get_owned_or_404(db=db, model=ShiftTemplate, id=body.template_id)
...
await db.refresh(shift, attribute_names=["shift_template"])

# GOOD
template = await get_owned_or_404(db=db, model=ShiftTemplate, id=body.template_id)
...
shift.shift_template = template
```

#### クエリ条件・実行頻度を変えたら、インデックスと対象行数の増え方を確認する

WHERE条件を削除・緩和すると、結果行数を強く絞っていた条件が外れ、テーブルの成長に比例してスキャン量が増え続けることがある。

- 新しいフィルタ・範囲条件・OR条件を追加した場合は、その列にインデックスがあるか確認する。
- 頻繁に呼ばれる処理では、集計対象期間を明示的に限定する（直近Nヶ月など）。
- 実行頻度を上げる変更（日次→毎分など）は、1回あたりのコスト×頻度で評価する。
- 対応を見送る場合は、許容できる理由と見直す条件をコメントかIssueに残す。

#### モジュールのインポートには `from x import y` を使用する

属性アクセスを実行するたびに、`__getattribute__()` や `__getattr__()` がトリガーされる。
これは内部で辞書操作を行うため、高速ではない。

```python
# BAD
import math

# GOOD
from math import sqrt
```

### 非同期・並行処理

- I/Oバウンドな処理（HTTPリクエスト、DBアクセス、ファイルI/O等）は `async`/`await` を使用する
- 非同期関数の中で同期的にブロッキングするI/O呼び出し（`requests`、`time.sleep` 等）を行わない。イベントループ全体が止まり、他のリクエスト処理も遅延する
- 対象ごとに独立したI/O呼び出し（メール送信等）をループ内で全て逐次`await`しない。処理時間が対象数に比例して伸びるため、`asyncio.gather`での並列化やコネクションの再利用を検討する

```python
# BAD
async def fetch_user(user_id: int) -> User:
    time.sleep(1)
    return requests.get(f"/users/{user_id}").json()

# GOOD
async def fetch_user(user_id: int) -> User:
    await asyncio.sleep(1)
    async with httpx.AsyncClient() as client:
        response = await client.get(f"/users/{user_id}")
        return response.json()
```

### FastAPIを使う場合

#### リクエスト/レスポンスのスキーマはdictではなくPydanticモデルで定義する

キーの欠如や型不一致を実行時のバグではなく、フレームワークによるバリデーションエラーとして検出できる。

```python
# BAD
@app.post("/users")
async def create_user(payload: dict):
    name = payload["name"]  # キー欠如やバリデーション漏れが実行時まで分からない
    ...

# GOOD
class UserCreate(BaseModel):
    name: str
    email: EmailStr

@app.post("/users")
async def create_user(payload: UserCreate):
    ...
```

#### DBセッションなど後片付けが必要なリソースは `yield` を使う依存関係でスコープを管理する

```python
# BAD
@app.get("/users/{user_id}")
async def get_user(user_id: int):
    db = SessionLocal()
    return db.query(User).get(user_id)  # セッションが閉じられない

# GOOD
async def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/users/{user_id}")
async def get_user(user_id: int, db: Session = Depends(get_db)):
    return db.query(User).get(user_id)
```
