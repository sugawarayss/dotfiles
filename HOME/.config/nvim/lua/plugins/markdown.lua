return {
  -- markdownをプレビューできるプラグイン
  {
    "iamcco/markdown-preview.nvim",
    -- 遅延読み込みする
    lazy = true,
    -- markdownファイルを開いた時にロードする
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- markdownのSyntaxとキーマップを拡張するプラグイン
  {
    "ixru/nvim-markdown",
    ft = { "markdown"}
  },
  -- markdownレンダリング
  {
    "MeanderingProgrammer/markdown.nvim",
    lazy = true,
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    build = ":RenderMarkdownToggle" ,
    config = function()
      require("render-markdown").setup()
    end,
  }
}
