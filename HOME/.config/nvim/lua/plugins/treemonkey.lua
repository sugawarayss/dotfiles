-- treesitter を利用してカーソル位置に対応するノードを選択するプラグイン
return {
  "atusy/treemonkey.nvim",
  init = function()
    local base_opts = {
      action = require("treemonkey.actions").unite_selection,
      highlight = { backdrop = "Comment" },
      ignore_injections = true,
      experimental = { treesitter_context = true },
    }
    vim.keymap.set({"x", "o"}, "m", function()
      require("treemonkey").select(base_opts)
    end)
  end
}
