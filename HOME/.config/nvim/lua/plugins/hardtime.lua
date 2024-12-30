-- コマンドの矯正プラグイン
return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {},
  config = function()
    require("hardtime").setup({
      disabled_filetypes  = { "qf", "neo-tree", "lazy", "mason", "lspinfo", "noice", "help", "dapui*", "alpha" },
      max_time            = 1000,
      max_count           = 3,
      disable_mouse       = false,
      hint                = true,
      notification        = true,
      allow_different_key = true,
      enabled             = false,
    })
  end
}
