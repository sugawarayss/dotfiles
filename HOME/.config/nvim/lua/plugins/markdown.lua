return {
  --markdownのSyntaxとキーマップを拡張するプラグイン
  {
    "ixru/nvim-markdown",
    ft = { "markdown" },
    cond = function()
      return not vim.g.vscode
    end,
  },
  -- markdownレンダリング
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "codecompanion" },
    cond = function()
      return not vim.g.vscode
    end,
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
