if vim.g.vscode then
  return {}
else
  return {
    {
      "olimorris/codecompanion.nvim",
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
          },
          strategies = {
            chat = {
              adapter = "copilot",
              roles = {
                llm = function(adapter)
                  return " CodeCompanion (" .. adapter.formatted_name .. ") "
                end,
                user = " Me "
              },
            },
            inline = {
              adapter = "copilot",
              layout = "vertical", -- vertical|horizontal|buffer
              keymaps = {}
            },
          },
          adapters = {
            -- copilot アダプタを上書き
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    default = "claude-3.7-sonnet",
                  },
                },
              })
            end,
          },
          display = {
            chat = {
              intro_message = "`?キー`でオプションを表示、`gd` でデバッグ情報を表示します。",
              show_header_separator = true,
              show_references = true,
              show_settings = false,
              show_token_count = true,
              start_in_insert_mode = false,
              auto_scroll = false,
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
