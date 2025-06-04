-- treesitter を利用してカーソル位置に対応するノードを選択するプラグイン
return {
  "atusy/treemonkey.nvim",
  enabled = true,
  init = function()
    vim.keymap.set({ "x", "o" }, "m", function()
      require("treemonkey").select({
        ignore_injections = true,
        highlight = {
          -- highlight を hop.nvim の表示に合わせる
          label = "HopNextKey", -- #ff007c
          first_selected_label = "HopNextKey1", -- #00dfff
          first_selected_node = "HopNextKey2", -- #2b8db3
          backdrop = "HopUnmatched", -- #666666
        },
      })
    end)
  end,
}
