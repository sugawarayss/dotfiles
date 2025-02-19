-- treesitter を利用してカーソル位置に対応するノードを選択するプラグイン
return {
  "atusy/treemonkey.nvim",
  init = function()
    vim.keymap.set({"x", "o"}, "m", function()
      require("treemonkey").select({ ignore_injections = false })
    end)
  end
}
