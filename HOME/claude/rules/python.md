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

### スタイル

パフォーマンスには寄与しないが、可読性が向上するので、

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

#### 変数への代入には型ヒントを付与する

スコープが短かくても、可能な限り型ヒントを付ける。

```python
# BAD
x = get_float_value()
y = get_int_list()

# GOOD
x: float = get_float_value()
y: list[int] = get_int_list()
```

#### メソッド呼び出しやインスタンスの生成時にはキーワード付き引数を使用する

```python
# BAD
z: int = add(1, 2)

# GOOD
z: int = add(x=1, y=2)
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
    retru n value_list

# GOOD
def load_value(path: Path) -> Generator[int]:
    with open(path, "r") as f:
        for line in f:
            yield int(line)
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
