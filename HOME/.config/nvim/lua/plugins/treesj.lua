-- コードを分割したり結合したりできるようにするプラグイン
return {
  "Wansmer/treesj",
  keys = {
    {
      "<leader>m",
      function()
        require("treesj").toggle()
      end,
      mode = "n",
      desc = "配列やオブジェクトを分割/結合する",
    },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = true,
      check_syntax_error = true,
      max_join_length = 120,
      cursor_behavior = "hold",
      notify = true,
      dot_repeat = true,
      on_error = nil,
    })
  end,
}
