---
description: "pytestを使用したユニットテストコードを実装します。"
---

## タスク

pytest を用いたユニットテストを実装する。

## 前提

- pytestの設定は `pyproject.toml`に記載しているので、設定は不要です。
- プロジェクトルートに `uv.lock` というファイルが存在する場合は `uv` を使用しているので、pytest の実行は `uv run pytest` コマンドで行います。
- pytestプラグインが利用可能な場合があるので、以下のコマンドを実行して、インストールされているpytestプラグインを確認する。
  - `uv pip list | grep pytest`

## テストコード実装のルール

- テスト対象は python のclass や function である。
- テストコードは `./tests/` 配下に作成すること。
- テスト対象コードの変更は絶対にしないこと。
- 共通のセットアップは `conftest.py` を作成すること。
- テストコードは `正常系` の関数と、`異常系` の関数に分割すること
  - `正常系`の関数名には `__correct` という接尾辞を付けること。
    - 想定の範囲内である値の組み合わせパターンが正確に処理されることを確認するテストケース群とする。
    - テスト関数にはdocstringに`正常系:`から始まるテスト内容を端的に表すコメントを記載すること
  - `異常系`の関数名には `__incorrect` という接尾辞を付けること。
    - 想定の範囲外である値の組み合わせパターンで、エラーが発生することを確認するテストケース群とする。
    - テスト関数にはdocstringに`異常系:`から始まるテスト内容を端的に表すコメントを記載すること
- データベースや、外部のAPIを呼出し等 を行う実装は必ずモックを使用すること。
  - モックには [`pytest-mock`](https://pytest-mock.readthedocs.io/en/latest/usage.html)のみを利用すること。
  - httpリクエストのモックには `pytest-httpserver` を利用すること。
- 日付を固定する必要がある場合は `freezegun` のみを利用すること。
  - freezegunの[ドキュメント](https://github.com/spulec/freezegun/blob/master/README.rst)を参考にする
  - freezegun.freeze_time("2012-01-14")` のように使用して日時を固定する
- 引数の値の範囲が複数考えられる場合は、上限または下限等の境界値近辺の値をテストすること。
  - `@pytest.mark.parametrize` を利用して、1つのテスト関数で複数ケースを表現すること。

## テストコード実装例

```python

import pytest
from datetime import datetime

from foo import add_num, add_days

class TestSample:
  @pytest.mark.parametrize(
  ("move_to", "after_days", "expected"),
  [
      ("2025-01-01", 1, datetime(2025, 1, 2)),
      ("2025-02-01 00:00:00", 2, datetime(2025, 2, 3, 0, 0, 0))
  ],
  )
  def test_add_days__correct(freezer, move_to, after_days, expected):
    """正常系: 日時の加算"""
    freezer.move_to(move_to)
    now = datetime.now()
    result = add_days(base=now, after=after_days)
    assert result == expected

  @pytest.mark.parametrize(
    ("base", "after_days", "expected"),
    [
      ("2026-01-01", 1, ValueError),
      (datetime(2026, 2, 1), "2", ValueError),
      (None, 1, ValuError),
      (datetime(2026, 3, 1), None, ValueError),
      (None, None, ValueError),
    ]
  )
  def test_add_days__incorrect(freezer, base, after_days, expeted):
    """異常系: 無効な値"""
    with pytest.raises(expected):
      add_days(base=base, after=after_days)


  @pytest.mark.parametrize(
    ("params", "expected"),
    [
      # 1以上
      ((1, 2), 3),
      ((2, 1), 3),
      ((2, 3), 5),
      ((3, 2), 5),
      # 10以下まで
      ((8, 9), 17),
      ((9, 8), 17),
      ((9, 10), 19),
      ((10, 9), 19),
    ]
  )
  def test_add_nums__correct(params, expected):
    """正常系: 1以上10以下の整数加算"""
    x, y = params
    result = add_num(x=x, y=y)
    assert result == expected


  @pytest.mark.parametrize(
    ("params", "expected"),
    [
      # 1より小さいのはNG
      ((1, 0), ValueError),
      ((0, 1), ValueError),
      # 10より大きいのはNG
      ((10, 11), ValueError),
      ((11, 10), ValueError),
      # NoneはNG
      ((None, 1), ValueError),
      ((1, None), ValueError),
      # int以外はNG
      (("1", 2), ValueError),
      ((1, "2"), ValueError),
    ],
  )
  def test_add_nums__incorrect(params, expected):
    """異常系: 範囲外の整数、または不正な値"""
    with pytest.raises(expected):
      x, y = params
      add_num(x=x, y=y)


```
