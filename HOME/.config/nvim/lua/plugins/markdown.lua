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
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    build = ":RenderMarkdown toggle" ,
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "vimwiki" },
        -- 見出しの表示設定
        heading = { border = true },
        -- code blockの表示設定
        code = {
          sign = false,
          position = 'right',
          width = 'block',
          min_width = 45,
          left_pad = 2,
          language_pad = 2,
        },
        -- tableの表示設定
        pipe_table = { 
          preset = "heavy",
          alignment_indicator = "┅",
        },
        -- call outの表示設定
        callout = { note = { rendered = '󰅾 Notary' } },
        -- インデントの表示設定
        indent = { enabled = true, per_level = 2 },
      })
    end,
  }
}
