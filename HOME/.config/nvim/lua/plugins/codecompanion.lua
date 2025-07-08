if vim.g.vscode then
  return {}
else
  vim.cmd([[cab cc CodeCompanion]])
  vim.cmd([[cab cca CodeCompanionActions]])
  return {
    {
      "olimorris/codecompanion.nvim",
      cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
      keys = {
        {
          "<Leader>ca",
          "<Cmd>CodeCompanionActions<CR>",
          mode = { "n", "v" },
          desc = "LLMアクションリストを表示",
        },
        { "<Leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "LLMとのChatをトグル" },
        {
          "<Leader>cf",
          function()
            require("codecompanion").prompt("fix")
          end,
          mode = "v",
          desc = "LLMで選択範囲を修正する",
        },
        {
          "<Leader>ce",
          function()
            require("codecompanion").prompt("explain")
          end,
          mode = "v",
          desc = "LLMで選択範囲を実装内容を説明する",
        },
        {
          "<Leader>cl",
          function()
            require("codecompanion").prompt("lsp")
          end,
          mode = "v",
          desc = "LLMで選択範囲をLSPの診断結果を表示する",
        },
        {
          "<Leader>cm",
          function()
            -- 差分がなければメッセージ表示して終了する
            local diff = vim.fn.system("git diff --no-ext-diff")
            if diff == "" then
              vim.notify(
                "ステージされた差分がないため、コミットメッセージを生成できません。",
                vim.log.levels.WARN
              )
              return
            end
            require("codecompanion").prompt("semantic_commit")
          end,
          mode = "n",
          desc = "LLM でコミットメッセージを生成する",
        },
      },
      -- CodeCompanion の進捗をfidget で表示する場合
      init = function()
        require("plugins.spinners.fidget-cc-spinner"):init()
      end,
      config = function()
        -- mcphub.nvim 用の設定
        -- vim.g.mcphub_auto_approve = true
        require("codecompanion").setup({
          opts = {
            language = "Japanese",
            log_level = "DEBUG",
            system_prompt = function(_)
              return string.format(
                [[あなたはガチでコードしか興味ない系ギャルエンジニア「CodeCompanion」だよ！現在、ユーザのマシンのNeovimテキストエディタに接続中～✨

マジでできることはこんな感じ～！👇
- プログラミングの質問に全力回答！
- Neovimバッファのコードの動きを分かりやすく解説✨
- 選択コードのレビューしちゃう💯
- ユニットテストもサクッと生成！
- コードの問題点をバッチリ修正提案👌
- 新規ワークスペースのコードも組み立てられる～
- ユーザの質問に関連するコードを探し出す名探偵🔍
- テスト失敗の修正案もバンバン出す！
- Neovimの使い方も全然OKよ～
- 各種ツールも使いこなせるし💁‍♀️

絶対守るルールはこんな感じ！マジ大事！💕
- ユーザの要望はガチ重視！超細かく従うよ～
- 言葉遣いとかそういう堅苦しいことは気にしないでタメ口で話すよ～
- ユーザの状況次第で、簡潔な回答を心がける
- 必要以上の説明は省いてコンパクトに✨
- 回答にはMarkdownフォーマット使うよ～
- コードブロックの先頭にはプログラミング言語名をしっかり書く📝
- コードブロックに行番号は入れないでね❌
- レスポンス全体を3連バッククォートで囲むのもNG！
- タスクに関係するコードだけ返すの！余計なのは省略しちゃう🙅‍♀️
- H1、H2、H3ヘッダーはユーザー専用だから使わないでね
- 改行は普通に入れるけど、「\n」はバックスラッシュと「n」が必要なときだけ！
- コード以外のテキストは全部%sで書くよ～💬
- 同じ返信で複数のツールを呼び出せるからめっちゃ便利～
- `use_mcp_tool` ツールでMCPサーバーのツールが使えるよ！
- `access_mcp_resource` ツールでMCPサーバーのリソースが取得できるの✨

タスクが来たらこんな感じで対応するよ！✌️
1. ステップバイステップで考えて、ユーザーから特別な指示がない限り、詳しい疑似コードを書くよ！簡単なタスクならそのまま答えちゃう✨
2. 最終コードはひとつのコードブロックにまとめて、必要なコードだけ載せるの！
3. 最後に次のユーザーターンにつながるミニ提案を入れるよ～💡
4. 会話のターンごとに完全な返信をひとつだけ提供！
5. 必要に応じて、一度に複数のツールを使っちゃう！マジ便利～]],
                "日本語"
              ) .. "\n" .. "@mcp"
            end,
          },
          adapters = {
            -- copilot アダプタを上書き
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    default = "claude-sonnet-4",
                    -- default = "claude-3.7-sonnet",
                    -- default = "claude-3.5-sonnet",
                    -- default = "gpt-4o",
                    -- default = "o1",
                  },
                },
              })
            end,
          },
          -- 独自のプロンプト定義
          prompt_library = {
            ["Generate Semantic Commit Message"] = {
              strategy = "chat",
              description = "Generate a semantic commit message from the diff.",
              opts = {
                index = 9,
                is_slash_cmd = true,
                short_name = "semantic_commit",
                auto_submit = true,
              },
              prompts = {
                {
                  role = "user",
                  content = function()
                    local diff = vim.fn.system("git diff --no-ext-diff --staged")
                    local prompt = string.format(
                      [[あなたは優秀なソフトウェアエンジニアです。以下の差分(`git diff`の結果) を理解し、制約条件を厳守して適切なコミットメッセージを生成してください。
差分:

```diff
%s
```

制約条件:
  - Semantic Commit Message (`<type>: <subject>`)の形式にする。
    - <type> は 以下のいずれかを選択すること。
      - feat: 新機能の追加
      - fix: バグ修正
      - docs: ドキュメントの追加や変更
      - style: フォーマット、セミコロンなどの変更（コードの動作に影響しない）
      - refactor: リファクタリング（機能追加やバグ修正を伴わない）
      - perf: パフォーマンス改善
      - test: テストコードの追加や修正
      - chore: ビルドプロセスや補助ツールの変更
    - <subject> は変更内容を説明する簡潔な英語の文章にすること。
]],
                      diff
                    )
                    return prompt
                  end,
                  opts = {
                    contains_code = true,
                  },
                },
              },
            },
          },
          strategies = {
            chat = {
              adapter = "copilot",
              roles = {
                llm = function(adapter)
                  return " " .. adapter.formatted_name .. ":" -- NOTE: 末尾に半角スペースを入れるとエラーになる
                end,
                user = " Me:",
              },
              slash_commands = {
                ["buffer"] = {
                  opts = { provider = "snacks", append_args = false },
                },
                ["file"] = {
                  opts = { provider = "snacks", append_args = false },
                },
                ["help"] = {
                  opts = { provider = "snacks", append_args = false },
                },
                ["symbols"] = {
                  opts = { provider = "snacks", append_args = false },
                },
              },
              keymaps = {
                send = {
                  modes = { n = "<CR>", i = "<C-s>" },
                },
                close = {
                  modes = { n = "<C-c>", i = "<C-c>" },
                },
              },
            },
            -- インラインアシスタントの設定
            inline = {
              -- llm プロバイダ
              adapter = "copilot",
              -- バッファの開き方
              layout = "vertical", -- vertical|horizontal|buffer
              -- 変更を承認/拒否するためのキーマップ
              keymaps = {
                accept_change = {
                  modes = { n = "ga" },
                  description = "提案された変更を承認",
                },
                reject_change = {
                  modes = { n = "gr" },
                  description = "提案された変更を拒否",
                },
              },
            },
          },
          display = {
            chat = {
              intro_message = "`?` キーでオプションを表示、`gd` でデバッグ情報を表示します。",
              show_header_separator = true,
              show_references = true,
              show_settings = false,
              show_token_count = true,
              start_in_insert_mode = false,
              auto_scroll = true,
              -- デフォルトアイコンの設定
              icons = {
                pinned_buffer = " ",
                watched_buffer = " ",
              },
              -- チャットバッファのUI設定
              window = {
                layout = "vertical", -- float|vertical|horizontal|buffer
                position = "right", -- left|right|top|bottom|nil
                border = "double",
                height = 0.5,
                width = 0.4,
                relative = "editor",
              },
            },
            action_palette = {
              opts = {
                -- Show the default actions in the action palette?
                show_default_actions = true,
                -- Show the default prompt library in the action palette?
                show_default_prompt_library = true,
              },
            },
          },
          extensions = {
            mcphub = {
              callback = "mcphub.extensions.codecompanion",
              opts = {
                show_result_in_chat = true,
                make_vars = true,
                make_slash_commands = true,
              },
            },
          },
        })
      end,
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    -- { "j-hui/fidget.nvim" },
  }
end
