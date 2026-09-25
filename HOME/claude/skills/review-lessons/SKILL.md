---
name: review-lessons
description: tuicr（review-local/review-pr/手動レビュー含む）で過去に交わされたレビュー指摘コメントを横断的に集計し、繰り返し出ているパターンを一般化してclaude/rulesとcodex/skills/coding-rulesの横断ルール、およびObsidian vaultのKnowledgeノートに反映する。「同じ指摘を何度も受ける」「レビューで毎回同じことを言われる」「過去のレビュー指摘を振り返ってルール化したい」「tuicrの指摘を一般化して」といった趣旨の発言があれば、明示的に名指しされていなくても積極的にこのスキルを使う。単発のタスク実行ではなく、レビュー資産を横断ルールへ蒸留する定期的なメンテナンス作業として扱う。
---

# Review Lessons

tuicrの永続化レビューセッションに溜まった指摘コメントは、放置すると「同じ指摘を毎回受けて毎回その場で直すだけ」で終わり、資産として蓄積されない。このスキルは、指摘の中から**繰り返し出ている・一般化する価値があるパターン**だけを抽出し、恒久的なルール（claude/rules、codex/skills/coding-rules）と横断メモリ（Obsidian）に昇格させる。

## 全体の流れ

1. `scripts/extract_comments.py` で未処理の指摘コメントを抽出する
2. ノイズ・プロジェクト固有の業務ロジックを除外し、一般化候補を絞り込む
3. 既存の claude/rules・codex/skills/coding-rules・Obsidian ClaudeCode/Knowledge,Feedback を確認し、重複を除外する
4. 候補をユーザーに提示し、反映する項目を選んでもらう（**必ず確認する。無断で書き込まない**）
5. 承認された項目を Obsidian → claude/rules → codex/skills/coding-rules の順に反映する
6. 処理済みの watermark を状態ファイルに保存する

## 1. 抽出

```bash
python3 scripts/extract_comments.py
```

標準出力にJSONが返る。`candidates` が未処理の指摘一覧（`session_key`/`repo_path`/`file`/`line`/`author`/`content`/`created_at`）、`suggested_watermarks` が今回処理する範囲のセッションごとの最大`created_at`（ステップ6で使う）。

状態ファイルは既定で `~/.config/review-lessons/state.json`。存在しないセッションキーは「未処理」扱いになり全履歴が対象になる。特定プロジェクトだけ見たい場合は `--key-prefix <prefix>` を指定する（複数指定可）。

## 2. ノイズ・対象外の除外

以下は候補から人力で除外する（スクリプトは`execute-plan-and-pr`が付ける`対応:`メモしか除外しないため、残りはここで判断する）:

- スキルやツールの動作確認用テストコメント（「テストコメント」「動作確認です」等、内容から明らかなもの）
- 「Commit対象外にして良いです」のようなスコープ指示（レビュー指摘ではなくユーザーからの作業指示）
- そのプロジェクト固有の業務ロジックバグで、他プロジェクトや他コードに一般化しようがないもの（例: 「有給休暇の期限計算が1日ずれている」のような固有ドメインの計算誤り）。これは元のプロジェクトの課題管理には残るべきだが、cross-projectなルールにはしない
- リポジトリ固有のアーキテクチャ規約違反（例: 「repository層はread-onlyという、このプロジェクト内だけの取り決めに反する」）。これは該当プロジェクト自身の`CLAUDE.md`や規約ドキュメントに書くべき事柄であり、claude/rulesやcodex/skills/coding-rules（全プロジェクト横断）には書かない。見つけた場合はユーザーに「プロジェクト側のドキュメントへの反映を検討してください」と伝えるに留める

## 3. 一般化の基準

**同種の指摘が複数のプロジェクト・セッションにまたがって繰り返されている**ことが最有力のシグナルだが、それだけが条件ではない。単発でも、既存ルールの記述を具体的に補強・拡張できる高品質な指摘（見逃されがちな境界ケースを言語化しているなど）は一般化candidate に含めてよい。逆に、頻度が高くても内容が特定の業務ドメインに強く紐づく場合は2.の基準で除外する。

一般化するときは、個別の指摘文をそのまま転記しない。[[design_principles]]の命名規則・PoLAの考え方に倣い、「何が問題になりやすいか」「どう見つけるか」「どう直すか」を一般化した言葉で書く。

候補ごとに以下を用意してから次のステップへ進む:
- 一般化した内容（既存ルールの文体に合わせる）
- 根拠（どのプロジェクト・何件の実例か）
- 反映先候補（下記ファイル対応表のどれに書くか。新規ファイルが要るケースは稀）

## 4. 既存ルールとの重複チェック

書き込む前に、必ず以下を読んで内容が既にカバーされていないか確認する:
- `claude/rules/*.md`(このリポジトリの `HOME/claude/rules/`)
- `codex/skills/coding-rules/references/*.md`
- Obsidian `ClaudeCode/Knowledge/` と `ClaudeCode/Feedback/` の一覧（`obsidian search query="<keyword>" path="ClaudeCode"` で関連ノートを探す）

既にカバーされている指摘は「頻度が高い＝既存ルールが機能している証拠」として扱い、新規追記はしない（頻度の記録が必要なら4.の提示時にその旨を一言添えるだけでよい）。

## 5. ユーザーへの提示と承認

一般化候補（重複を除いたもの）を一覧にして提示し、どれを反映するかユーザーに確認する。**確認なしに書き込まない**（クロスプロジェクトのルールファイルは他の全プロジェクトの挙動に影響するため、一括承認ではなく項目ごとに取捨選択できるようにする）。

## 6. 反映

承認された項目ごとに、Obsidian → claude/rules → codex/skills/coding-rules の順で反映する。

### Obsidian

`ClaudeCode/Knowledge/codex-implementation-common-review-findings.md` に代表される「レビュー指摘の一般化ノート」に追記する。関連ノートが無ければ [[cross_project_memory]] の手順で `claudecode-knowledge` テンプレートから新規作成する。新規作成した場合は `ClaudeCode/Knowledge/index.md` の一覧にも追記する。上書きはせず必ず追記(`obsidian append`)にする。

### claude/rules

`HOME/claude/rules/<file>.md` に追記する。既存の見出し（節）に自然に収まるならそこに、収まらなければ新しい見出しを追加する。既存の書き方（見出しレベル、`# BAD`/`# GOOD`コード例の有無、太字での要点強調など）に揃える。

**新しいルールファイルを追加した場合**は、`HOME/claude/CLAUDE.md` の「rules/ ディレクトリとの関係」一覧にも1行追記する。

### codex/skills/coding-rules

対応するファイルへ**同じ本文**を反映する。claude/rules側とcodex側は、frontmatter（`paths:`の有無）を除いて本文が完全に同一という運用になっている（`diff`で確認済み）。claude/rules側に書いた内容を丸ごとcodex側にも書き写すこと（要約や書き換えをしない）。

ファイル対応表:

| claude/rules | codex/skills/coding-rules/references |
|---|---|
| `design_principles.md` | `design-principles.md` |
| `python.md` | `python.md` |
| `pytest_coding.md` | `pytest.md` |
| `typescript.md` | `typescript.md` |
| `react.md` | `react.md` |
| `accessibility.md` | `accessibility.md` |
| `api_design.md` | `api-design.md` |
| `docker.md` | `docker.md` |

`git_workflow.md`・`use_cli.md`・`cross_project_memory.md` はcodex側に対応ファイルが無い（ワークフロー・環境設定であり「コーディングルール」の対象外のため）。これらに該当する指摘は一般化してもcodex側には反映しない。

**新しい参照ファイルを追加した場合**は、`codex/skills/coding-rules/SKILL.md` の「ルーティング」表にも対応する`paths`条件を追記する。

## 7. 状態の更新

反映が終わったら（一部の項目がユーザーに却下された場合も含め、今回提示した候補は全て検討済みなので）、抽出時に得た `suggested_watermarks` を状態ファイルにコミットする:

```bash
echo '<suggested_watermarksのJSON>' | python3 scripts/extract_comments.py --commit-watermarks -
```

これにより次回実行時は今回処理済みのコメントを再度候補に含めない。却下された指摘も「検討済み」として扱い、二度と同じ却下判断を繰り返させない。
