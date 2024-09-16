-- 翻訳プラグイン
return {
  {
    "voldikss/vim-translator",
    lazy = true,
    keys = {
      { "<C-t>j", "<cmd>Translate<CR>", mode = "n", desc = "カーソル位置の単語を日本語に翻訳" },
      { "<C-t>e", "<cmd>Translate --target_lang=en<CR>", mode = "n", desc = "カーソル位置の単語を英語に翻訳"},
    },
    config = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_default_engines = { 'google' }
      vim.g.translator_history_enable = true
    end
  },
  {
    "potamides/pantran.nvim",
    lazy = true,
    keys = {
      { "<leader>tr", "<cmd>Pantran<CR>", mode = "n", desc = "Show Tranlate Window" },
    },
    config = function()
      require("pantran").setup({
        ui = {
          width_percentage = 0.8,
          height_percentage = 0.8,
        },
        window = {
          title_border = {"┤ ", " ├"},
          window_config = {border = "rounded"},
        },
        default_engine = "google",
        engines = {
          goolge = {
            default_source = "ja",
            default_target = "en",
          },
        },
        controls = {
          mappings = {
            -- TODO: Pantranのマッピングのカスタマイズ
            edit = {
              n = {
                ["j"] = "gj",
                ["k"] = "gk"
              },
              i = {
                ["<C-y>"] = false,
              }
            },
            select = {},
          },
        },
      })
    end
  }
}
