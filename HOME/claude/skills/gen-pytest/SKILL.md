---
name: gen-pytest
argument-hint: "[テスト対象ファイルパス]"
description: "pytestを使用したユニットテストコードを実装します。"
user-invocable: true
---

## タスク

pytest を用いたユニットテストを実装する。

### 引数ありの場合

`$ARGUMENTS` を テスト対象ファイルとして使用する。

### 引数なしの場合

現状の `.tests/` に実装されているテストコードを確認し、不足しているテストケースの有無を検証する。

## 前提

- pytestの設定は `pyproject.toml`に記載しているので、設定は不要です。
- プロジェクトルートに `uv.lock` というファイルが存在する場合は `uv` を使用しているので、pytest の実行は `uv run pytest` コマンドで行います。
- pytestプラグインが利用可能な場合があるので、以下のコマンドを実行して、インストールされているpytestプラグインを確認する。
    - 利用されうるpytest プラグインは [pytest公式ドキュメントのプラグインリスト](https://docs.pytest.org/en/stable/reference/plugin_list.html) で確認できます。
    - `uv pip list | grep pytest`
    - `uv pip list | grep time_machine`

## テストコード実装のルール

**重要**: 以下のルールファイルを`Read`ツールで読み込み、詳細な観点を把握してください：

`.claude/rules/pytest_coding.md` - pytestによるpythonユニットテストコードのルール
