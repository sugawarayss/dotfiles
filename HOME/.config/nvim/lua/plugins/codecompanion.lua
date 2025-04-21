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
        { "<Leader>ca", "<Cmd>CodeCompanionActions<CR>",     mode = {"n", "v"}, desc = "LLMアクションリストを表示" },
        { "<Leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = {"n", "v"}, desc = "LLMとのChatをトグル" },
        { "<Leader>cf", function() require("codecompanion").prompt("fix") end, mode = "v", desc = "LLMで選択範囲を修正する" },
        { "<Leader>ce", function() require("codecompanion").prompt("explain") end, mode = "v", desc = "LLMで選択範囲を実装内容を説明する" },
        { "<Leader>cl", function() require("codecompanion").prompt("lsp") end, mode = "v", desc = "LLMで選択範囲をLSPの診断結果を表示する" },
        { "<Leader>cm", function()
          -- 差分がなければメッセージ表示して終了する
          local diff = vim.fn.system("git diff --no-ext-diff --staged")
          if diff == "" then
            vim.notify("ステージされた差分がないため、コミットメッセージを生成できません。", vim.log.levels.WARN)
            return
          end
          require("codecompanion").prompt("semantic_commit")
        end, mode = "n", desc = "LLM でコミットメッセージを生成する"}
      },
      -- CodeCompanion の進捗をfidget で表示する場合
      -- init = function()
      --   require("plugins.spinners.fidget-cc-spinner"):init()
      -- end,
      config = function()
        require("codecompanion").setup({
          opts = {
            language = "Japanese",
            log_level = "DEBUG",
          },
          adapters = {
            -- copilot アダプタを上書き
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    default = "claude-3.7-sonnet",
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
]], diff)
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
                  return " " .. adapter.formatted_name .. ":"  -- NOTE: 末尾に半角スペースを入れるとエラーになる
                end,
                user = " Me:"
              },
              slash_commands = {
                ["buffer"] = {
                  opts = { provider = "snacks" },
                },
                ["file"] = {
                  opts = { provider = "snacks" },
                },
                ["help"] = {
                  opts = { provider = "snacks" },
                },
                ["symbols"] = {
                  opts = { provider = "snacks" },
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
              }
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
                width = 0.5,
                relative = "editor",
              }
            },
            action_palette = {
              opts = {
                -- Show the default actions in the action palette?
                show_default_actions = true,
                -- Show the default prompt library in the action palette?
                show_default_prompt_library = true,
              }
            }
          }
        })
      end,
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    -- { "j-hui/fidget.nvim" },
  }
end
