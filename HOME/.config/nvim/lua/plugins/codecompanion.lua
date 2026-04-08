return {
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
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
          "<Leader>cc", -- Command+Ctrl+i
          "<Cmd>CodeCompanionChat Toggle<CR>",
          mode = { "n", "v" },
          icon = "🤖",
          desc = "CodeCompanion - LLMとのChatをトグル",
        },
        {
          "<Leader>cf",
          function()
            require("codecompanion").prompt("fix")
          end,
          mode = "v",
          icon = "🤖",
          desc = "CodeCompanion - LLMで選択範囲を修正する",
        },
        {
          "<Leader>ce",
          function()
            require("codecompanion").prompt("explain")
          end,
          mode = "v",
          icon = "🤖",
          desc = "CodeCompanion - LLMで選択範囲を実装内容を説明する",
        },
        {
          "<Leader>cl",
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
            model = "claude-opus-4.5",
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
            model = "claude-opus-4.5",
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
          fold_context = true,
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
        spinner = {},
      },
      -- チャット履歴管理設定
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
