-- 翻訳プラグイン
return {
  {
    "voldikss/vim-translator",
    keys = {
      { "<C-t>j", "<cmd>Translate<CR>", mode = "n", desc = "Translate word on cursor to Japanese" },
      { "<C-t>e", "<cmd>Translate --target_lang=en<CR>", mode = "n", desc = "Translate word on cursor to English"},
    },
    config = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_default_engines = { 'google' }
      vim.g.translator_history_enable = true
    end
  },
  {
    "potamides/pantran.nvim",
    keys = {
      { "<leader>tr", "<cmd>Pantran<CR>", mode = "n", desc = "Show Tranlate Window" },
    },
    config = function()
      require("pantran").setup({
        default_engine = "google",
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
