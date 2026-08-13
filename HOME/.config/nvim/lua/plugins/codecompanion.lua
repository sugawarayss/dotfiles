return {
  {
    "olimorris/codecompanion.nvim",
    -- version = "^18.0.0",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCLI" },
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionChat]])
      vim.cmd([[cab cca CodeCompanionActions]])
      local wk = require("which-key")
      wk.add({
        {
          "<Leader>cch", -- Command+Ctrl+i
          "<Cmd>CodeCompanionChat Toggle<CR>",
          mode = { "n", "v" },
          icon = "🤖",
          desc = "CodeCompanion - LLMとのChatをトグル",
        },
        {
          "<Leader>cli",
          "<Cmd>CodeCompanionCLI<CR>",
          mode = "n",
          icon = "🤖",
          desc = "CodeCompanion - CLI(Claude Code)を起動",
        },
        {
          "<Leader>cfix",
          function()
            require("codecompanion").prompt("fix")
          end,
          mode = "v",
          icon = "🤖",
          desc = "CodeCompanion - LLMで選択範囲を修正する",
        },
        {
          "<Leader>cexp",
          function()
            require("codecompanion").prompt("explain")
          end,
          mode = "v",
          icon = "🤖",
          desc = "CodeCompanion - LLMで選択範囲を実装内容を説明する",
        },
        {
          "<Leader>clsp",
          function()
            require("codecompanion").prompt("lsp")
          end,
          mode = "v",
          icon = "🤖",
          desc = "CodeCompanion - LLMで選択範囲をLSPの診断結果を表示する",
        },
        {
          "<Leader>crv",
          function()
            require("codecompanion").prompt("review")
          end,
          mode = "n",
          icon = "🤖",
          desc = "CodeCompanion - LLM でコードレビューを行う",
        },
      })
    end,
    opts = {
      interactions = {
        -- チャットバッファ設定
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-5.6-terra",
          },
          roles = {
            llm = function(adapter)
              return "🤖 " .. adapter.formatted_name .. ":" -- NOTE: 末尾に半角スペースを入れるとエラーになる
            end,
            user = "👤 Me:",
          },
          opts = {
            system_prompt = require("prompts.system_prompt"),
          },
          -- チャットバッファで使用するキーマップ
          keymaps = {},
        },
        -- インラインアシスタント設定
        inline = {
          adapter = {
            name = "copilot",
            model = "claude-opus-4.6",
          },
          -- インラインアシスタントが新しいバッファを作成する際にバッファ分割の方向
          layout = "vertical",
          -- インラインアシスタントで使用するキーマップ
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
        cli = {
          agent = "claude_code",
          agents = {
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code CLI",
              providerr = "terminal",
            },
          },
        },
        shared = {
          --
          keymaps = {},
        },
      },
      -- 独自プロンプトの定義
      prompt_library = {
        markdown = {
          dirs = {
            vim.fn.stdpath("config") .. "/lua/prompts/library",
          },
        },
      },
      -- 表示設定
      display = {
        chat = {
          auto_scroll = true,
          intro_message = "`?` キーでオプションを表示、`gd` でデバッグ情報を表示するよ!",
          separator = "─", -- The separator between the different messages in the chat buffer
          show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
          show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          show_tools_processing = true, -- Show the loading message when tools are being executed?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
          fold_context = false,
          -- Change the default icons
          icons = {
            buffer_sync_all = "󰪴 ",
            buffer_sync_diff = " ",
            chat_context = "📎",
            chat_fold = " ",
            tool_pending = "🫥  ",
            tool_in_progress = " 🤔 ",
            tool_failure = "❌ ",
            tool_success = "✅ ",
            pinned_buffer = "📌 ",
            watched_buffer = "👀 ",
          },
          window = {
            -- List the chat buffer in the buffer list
            buflisted = false,
            -- Chat buffer remains open when switching tabs
            sticky = true,
            -- float|vertical|hirizontal|buffer
            layout = "vertical",
            -- for vertical layout
            full_height = true,
            -- left|right|top|bottom
            position = "right",
            width = 0.5,
            height = 1.0,
            border = "double",
            relative = "editor",
            opts = {
              breakindent = true,
              linebreak = true,
              wrap = true,
            },
          },
        },
        -- 差分表示設定
        diff = {
          enabled = true,
          threshold_for_chat = 6,
          word_highlights = {
            additions = true,
            deletions = true,
          },
        },
      },
      -- MCPHub 拡張機能設定
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
        -- チャット履歴管理設定
        history = {
          enabled = true,
          opts = {
            -- チャット履歴を開くためのキーマップ
            keymap = "gh",
            -- チャット履歴を保存するためのキーマップ
            save_chat_keymap = "sc",
            -- 自動保存するかどうか(falseの場合は ↑のキーマップでのみ保存)
            auto_save = true,
            -- 履歴を保存する日数(0の場合は無期限)
            expiration_days = 30,
            -- 曖昧検索に利用するツール
            picker = "snacks",
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
            },
            -- 新しいチャット履歴を作成する際にタイトルを自動生成するかどうか
            auto_generate_title = true,
            title_generation_opts = {
              -- タイトルを生成に利用するAIプロバイダー
              adapter = "copilot",
              model = "claude-haiku-4.5",
              --  タイトルを更新するチャット回数
              refresh_every_n_prompts = 3,
              -- タイトルを更新する最大回数
              max_refreshes = 3,
            },
            -- neovimを再起動した際に前回のチャットを復元するかどうか
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            enable_logging = false,
            --  チャット履歴の要約機能の設定
            summary = {
              -- 要約を作成するためのキーマップ
              create_summary_keymap = "gcs",
              -- 要約を閲覧するためのキーマップ
              browse_summaries_keymap = "gbs",
              generation_opts = {
                -- 要約作成するAIプロバイダ
                adapter = "copilot",
                model = "claude-haiku-4.5",
                -- コンテキストサイズ
                context_size = 90000,
                -- スラッシュコマンドの内容をコンテストに含めるか
                include_references = true,
                -- ツール実行結果をコンテキストに含めるか
                include_tool_outputs = true,
              },
            },
            memory = {
              -- チャット履歴の要約を作成する際に、メモリを自動生成するかどうか
              auto_create_memories_on_summary_generation = true,
              -- VectorCodeの実行ファイルパス
              vectorcode_exe = "vectorcode",
              tool_opts = {
                -- 取得するメモリの既定値
                default_num = 10,
              },
              -- メモリを作成する際に通知するかどうか
              notify = true,
              -- 起動時に全てのメモリをIndexするか
              index_on_startup = false,
            },
          },
        },
      },
      opts = {
        log_level = "DEBUG",
        language = "Japanese",
      },
    },
  },
  -- チャット履歴を保存/復元するプラグイン
  { "ravitemer/codecompanion-history.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", branch = "master", lazy = true },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
  -- { "j-hui/fidget.nvim" },
  { "franco-ruggeri/codecompanion-spinner.nvim" },
}
