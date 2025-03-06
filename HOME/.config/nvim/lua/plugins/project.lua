-- プロジェクトを切り替えられるプラグイン
return {
  "ahmedkhalf/project.nvim",
  -- ファイルエクスプローラを開くと、強制的にプロジェクトルートが開かれるのが使い勝手が悪かった
  enabled = false,
  lazy = false,
  config = function()
    require("project_nvim").setup({
      manual_mode       = false,
      detection_methods = { "lsp", "pattern" },
      patterns          = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Taskfile" },
      ignore_lsp        = {},
      exclude_dirs      = {},
      silent_chdir      = true,
      scope_chdir       = "global",
      datapath          = vim.fn.stdpath("data"),
    })
  end
}
