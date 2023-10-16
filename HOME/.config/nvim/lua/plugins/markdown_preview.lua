-- markdownをプレビューできるプラグイン
return {
  "iamcco/markdown-preview.nvim",
  -- 遅延読み込みする
  lazy = true,
  -- markdownファイルを開いた時にロードする
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
}
