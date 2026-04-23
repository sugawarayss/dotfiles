return {
  -- w/bモーションでの移動をスマートにする
  {
    "kana/vim-smartword",
    lazy = false,
    event = { "BufReadPre" },
    init = function()
      local wk = require("which-key")
      wk.add({
        { "w", "<Plug>(smartword-w)", mode = "n", desc = "SmartWord - 前方の単語の先頭に移動" },
        { "b", "<Plug>(smartword-b)", mode = "n", desc = "SmartWord - 後方の単語の先頭に移動" },
        { "e", "<Plug>(smartword-e)", mode = "n", desc = "SmartWord - 前方の単語の末尾に移動" },
        { "ge", "<Plug>(smartword-ge)", mode = "n", desc = "SmartWord - 後方の単語の末尾に移動" },
        { "w", "<Plug>(smartword-w)", mode = "v", desc = "SmartWord - 前方の単語の先頭まで選択" },
        { "b", "<Plug>(smartword-b)", mode = "v", desc = "SmartWord - 後方の単語の先頭まで選択" },
        { "e", "<Plug>(smartword-e)", mode = "v", desc = "SmartWord - 前方の単語の末尾まで選択" },
        { "ge", "<Plug>(smartword-ge)", mode = "v", desc = "SmartWord - 後方の単語の末尾まで選択" },
      })
      -- Terminal バッファでは無効化する
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          local opts = { buffer = true }
          vim.keymap.set("n", "w", "w", opts)
          vim.keymap.set("n", "b", "b", opts)
          vim.keymap.set("n", "e", "e", opts)
          vim.keymap.set("n", "ge", "ge", opts)
        end
      })
    end,
  },
  -- google/budox で日本語の単語区切りで移動できるように
  {
    "atusy/budouxify.nvim",
    enabled = true,
    dependencies = {
      "atusy/budoux.lua",
    },
    event = { "BufReadPre" },
    config = function()
      vim.keymap.set("n", "W", function()
        local pos = require("budouxify.motion").find_forward({
          head = true,
        })
        if pos then
          vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
        end
      end)
      vim.keymap.set("n", "E", function()
        local pos = require("budouxify.motion").find_forward({
          head = false,
        })
        if pos then
          vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
        end
      end)
    end,
  },
}
