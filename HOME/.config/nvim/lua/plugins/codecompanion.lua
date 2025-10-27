return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionChat]])
      vim.cmd([[cab cca CodeCompanionActions]])
      -- CodeCompanion の進捗をfidget で表示する場合
      require("plugins.spinners.fidget-cc-spinner"):init()
      --
      local wk = require("which-key")
      wk.add({
        {
          "<Leader>cc", -- Coomand+Ctrl+i
          "<Cmd>CodeCompanionChat Toggle<CR>",
          mode = { "n", "v" },
          icon = "",
          desc = "LLMとのChatをトグル",
        },
        {
          "<Leader>cf",
          function()
            require("codecompanion").prompt("fix")
          end,
          mode = "v",
          icon = "",
          desc = "LLMで選択範囲を修正する",
        },
        {
          "<Leader>ce",
          function()
            require("codecompanion").prompt("explain")
          end,
          mode = "v",
          icon = "",
          desc = "LLMで選択範囲を実装内容を説明する",
        },
        {
          "<Leader>cl",
          function()
            require("codecompanion").prompt("lsp")
          end,
          mode = "v",
          icon = "",
          desc = "LLMで選択範囲をLSPの診断結果を表示する",
        },
        {
          "<Leader>cm",
          function()
            -- 差分がなければメッセージ表示して終了する
            local diff = vim.fn.system("git diff --no-ext-diff --staged")
            if diff == "" then
              vim.notify("ステージ済みの差分がないため、コミットメッセージを生成できません。", vim.log.levels.WARN)
              return
            end
            require("codecompanion").prompt("semantic_commit")
          end,
          mode = "n",
          icon = "",
          desc = "LLM でコミットメッセージを生成する",
        },
        {
          "<Leader>crv",
          function()
            require("codecompanion").prompt("review_local_diff")
          end,
          mode = "n",
          icon = "",
          desc = "LLM でコードレビューを行う",
        },
      })
    end,
    opts = {
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
        http = {
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
      },
      -- 独自のプロンプト定義
      prompt_library = {
        ["Review Local Diff"] = {
          strategy = "chat",
          description = "Git Diff 結果をReview",
          opts = {
            short_name = "review_local_diff",
            is_slash_cmd = true,
            auto_submit = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "user",
              content = function()
                local target_branch = vim.fn.input("差分を取得するベースブランチ名を選択 (default: main): ", "develop")
                local diff = vim.fn.system("git diff --merge-base " .. target_branch .. " HEAD")
                local prompt = string.format(
                  [[あなたはコードレビューを行う上級ソフトウェアエンジニアです。以下のコード変更を分析してください。
潜在的なバグ、パフォーマンスの問題、セキュリティ上の脆弱性、そして可読性や保守性を向上させるためにリファクタリングできる領域を特定してください。
その理由を明確に説明し、具体的な改善提案を行ってください。
エッジケース、エラー処理、ベストプラクティスとコーディング標準の遵守を考慮してください。

ベースブランチ: %s

コード差分:
```
%s
```
]],
                  target_branch,
                  diff
                )
                return prompt
              end,
            },
          },
        },
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
              description = "開いているバッファをコンテキストに挿入する",
              opts = {
                contains_code = true,
                default_params = "watch",
                provider = "snacks",
              },
            },
            ["fetch"] = {
              description = "URLの内容をコンテキストに挿入する",
              opts = {
                adapter = "jina",
                provider = "snacks",
              },
            },
            ["quickfix"] = {
              description = "Quickfix リストをコンテキストに挿入する",
              opts = {
                contains_code = true,
              },
            },
            ["file"] = {
              description = "ファイルをコンテキストに挿入する",
              opts = {
                contains_code = true,
                max_lines = 1000,
                provider = "snacks",
              },
            },
            ["help"] = {
              description = "ヘルプタグから内容をコンテキストに挿入する",
              opts = {
                contains_code = false,
                max_lines = 128,
                provider = "snacks",
              },
            },
            ["image"] = {
              description = "画像をコンテキストに挿入する",
              opts = {
                dirs = {},
                filetypes = { "png", "jpg", "jpeg", "gif", "webp" },
                provider = "snacks",
              },
            },
            ["memory"] = {
              description = "チャットバッファにメモリを挿入する",
              opts = {
                contains_code = true,
              },
            },
            ["now"] = {
              description = "現在日付と時刻をコンテキストに挿入する",
              opts = {
                contains_code = false,
              },
            },
            ["symbols"] = {
              opts = {
                contains_code = true,
                provider = "snacks",
              },
            },
            ["terminal"] = {
              description = "ターミナルのアウトプットをコンテキストに挿入",
              opts = {
                contains_code = false,
              },
            },
            ["workspace"] = {
              description = "ワークスペースファイルを読み込む",
              opts = {
                contains_code = true,
              },
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
            -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            make_tools = true,
            -- Show individual tools in chat completion (when make_tools=true)
            show_server_tools_in_chat = true,
            -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            add_mcp_prefix_to_tool_names = true,
            -- Show tool results directly in chat buffer
            show_result_in_chat = true,
            -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            format_tool = nil,
            -- MCP Resources
            -- Convert MCP resources to #variables for prompts
            make_vars = true,
            -- MCP Prompts
            -- Add MCP prompts as /slash commands
            make_slash_commands = true,
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface (auto resolved to a valid picker)
            picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil, -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = nil, -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = nil, -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end,
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },

            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = "vectorcode",
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10,
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = false,
            },
          },
        },
      },
    },
  },
  -- チャット履歴を保存/復元するプラグイン
  { "ravitemer/codecompanion-history.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", branch = "master", lazy = true },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
  -- { "j-hui/fidget.nvim" },
}
