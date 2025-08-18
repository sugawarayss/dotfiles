-- コードを分割したり結合したりできるようにするプラグイン
return {
  "Wansmer/treesj",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local wk = require("which-key")
    require("treesj").setup({
      use_default_keymaps = true,
      check_syntax_error = true,
      max_join_length = 120,
      cursor_behavior = "hold",
      notify = true,
      dot_repeat = true,
      on_error = nil,
    })
    wk.add({
      { "<leader>m", "<cmd>TSJToggle<CR>", mode = "n", icon = "󰙅", desc = "配列やオブジェクトを分割/結合する" },
    })
  end,
}
