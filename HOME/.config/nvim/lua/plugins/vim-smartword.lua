return {
  -- w/bモーションでの移動をスマートにする
  {
    "kana/vim-smartword",
    lazy = true,
    event = { "BufReadPre" },
    keys = {
      { "w", "<Plug>(smartword-w)", mode = "n", desc = "前方の単語の先頭に移動" },
      { "b", "<Plug>(smartword-b)", mode = "n", desc = "後方の単語の先頭に移動" },
      { "e", "<Plug>(smartword-e)", mode = "n", desc = "前方の単語の末尾に移動" },
      { "ge", "<Plug>(smartword-ge)", mode = "n", desc = "後方の単語の末尾に移動" },
      { "w", "<Plug>(smartword-w)", mode = "v", desc = "前方の単語の先頭まで選択" },
      { "b", "<Plug>(smartword-b)", mode = "v", desc = "後方の単語の先頭まで選択" },
      { "e", "<Plug>(smartword-e)", mode = "v", desc = "前方の単語の末尾まで選択" },
      { "ge", "<Plug>(smartword-ge)", mode = "v", desc = "後方の単語の末尾まで選択" },
    },
  },
  -- google/budox で日本語の単語区切りで移動できるように
  {
    "atusy/budouxify.nvim",
    -- 有効にすると vim-smartword での移動のレスポンスが悪くなるので無効化
    enabled = false,
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
