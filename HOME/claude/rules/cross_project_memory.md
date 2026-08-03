# プロジェクト横断メモリ（Obsidian vault）

プロジェクトごとの内部メモリ（`~/.claude/projects/<project-hash>/memory/`）とは別に、プロジェクトを横断して残す価値がある知見は Obsidian vault にも書き出します。

保存先: `/Users/sugawarayss/PROJECTS/sugawarayss/obsidian_notes/ClaudeCode/`

## 使い方

- vault のディレクトリ構成・各カテゴリの説明・書式は `ClaudeCode/index.md` と各フォルダの `index.md` を参照する。作業前に一度読むこと。
- 新規ノートは `templates/claudecode-*.md`（`claudecode-feedback` / `claudecode-project` / `claudecode-reference` / `claudecode-knowledge`）のテンプレートを元に作成する。
- カテゴリ（User / Feedback / Projects / Reference / Knowledge）の判断基準は内部メモリと同じ考え方を使う。

## obsidian CLI を積極的に使う

`obsidian` コマンド（vault名: `obsidian_notes`）が使える環境では、生ファイルの直接編集より優先してこちらを使う。Obsidian アプリの索引（リンク・タグ・プロパティ）が即座に整合するため。

- 重複確認: 新規作成前に `obsidian search query="<keyword>" path="ClaudeCode"` や `obsidian backlinks path="ClaudeCode/..."` で既存ノートの有無・関連ノートを確認する。
- 新規作成: `obsidian create vault=obsidian_notes path="ClaudeCode/Feedback/<name>.md" template=claudecode-feedback open` のようにテンプレート指定で作成する（`{{title}}` / `{{date}}` は自動解決される）。
- 追記: 既存ノートへの追記は `obsidian append path="..." content="..."` を使い、上書きしない。
- frontmatter 操作: `obsidian property:set name=<name> value=<value> path="..."`。
- Obsidian アプリが起動しておらず CLI が使えない場合のみ、Read/Write/Edit による直接編集にフォールバックする。

## いつ書くか

- 内部メモリに保存する基準を満たし、かつ他のプロジェクトでも参照する価値がある場合。
- ユーザーから明示的に「vault に残しておいて」等の指示があった場合。

## 何を書かないか

- 特定プロジェクトの実装詳細やコードから読み取れること（プロジェクト固有の内部メモリ、または当該リポジトリ内のドキュメントに任せる）。
- 一時的な作業状況や、内部メモリに書くほどでもない些細な内容。

## 事前確認

- 対象の vault ディレクトリ（`ClaudeCode/User`, `ClaudeCode/Feedback` など）が存在するか、参照するノートが実在するかを事前に確認してから書き込む。過去にこの指示が書かれた時点の構成から変わっている可能性がある。
