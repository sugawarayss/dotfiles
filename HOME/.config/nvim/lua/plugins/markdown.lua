return {
  --markdownのSyntaxとキーマップを拡張するプラグイン
  {
    "ixru/nvim-markdown",
    ft = { "markdown"}
  },
  -- markdownレンダリング
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
  },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
