---
paths:
  - "**/*.py"
---

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

```python
# BAD
z: int = add(1, 2)

# GOOD
z: int = add(x=1, y=2)
```

### エラーハンドリング

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
