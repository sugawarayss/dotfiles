if vim.g.vscode then
  return {}
else
  vim.cmd([[cab cc CodeCompanion]])
  return {
    {
      "olimorris/codecompanion.nvim",
      cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
      keys = {
        { "<Leader>cf", "<cmd>CodeCompanion<CR>",            mode = {"n", "v"}, desc = "ユーザプロンプトを入力" },
        { "<Leader>ca", "<Cmd>CodeCompanionActions<CR>",     mode = {"n", "v"}, desc = "Copilot アクションリストを表示" },
        { "<Leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = {"n", "v"}, desc = "Copilot Chat をトグル" },
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
                    -- FIXME: claude を指定するとBad Request になる
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
            ["Review"] = {
              strategy = "inline",
              description = "Review the codes",
              opts = {
                auto_submit = true,

              },
              prompts = {
                {
                  role = "system",
                  content = "あなたは優秀なフルスタックソフトウェアエンジニアです。あなたの仕事は、コードをレビューし、問題点を指摘し、改善点を提案することです。",
                },
                {
                  role = "user",
                  content = function(context)
                    vim.print(context)
                    return "以下のコードをレビューしてください。問題が見つかった場合は改善点を提案してください。\n\n" .. "#buffer"
                  end
                }
              }
            },
            ["Refactor"] = {
              strategy = "inline",
              description = "Refactor the codes",
              opts = {
                auto_submit = true,
              },
              prompts = {
                {
                  role = "system",
                  content = "あなたは優秀なフルスタックソフトウェアエンジニアです。あなたの仕事は、コードをリファクタリングし、改善点を提案することです。",
                },
                {
                  role = "user",
                  content = function(context)
                    vim.print(context)
                    return "以下のコードをリファクタリングしてください。改善点があれば提案してください。\n\n" .. "#buffer"
                  end
                }
              }
            }
          },
          strategies = {
            chat = {
              adapter = "copilot",
              -- roles = {
              --   llm = function(adapter)
              --     return " CodeCompanion (" .. adapter.formatted_name .. ") "
              --   end,
              --   user = " Me "
              -- },
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
              auto_scroll = false,
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
