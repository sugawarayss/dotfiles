-- コードを分割したり結合したりできるようにするプラグイン
return {
  "Wansmer/treesj",
  keys = {
    { "<leader>m" }
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = true,
      check_syntax_error  = true,
      max_join_length     = 120,
      cursor_behavior     = "hold",
      notify              = true,
      dot_repeat          = true,
      on_error            = nil
    })
  end
}
