return {
  -- markdownをレンダリング
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "obsidian_markdown", "codecompanion" },
    cond = function()
      return not vim.g.vscode
    end,
    opts = {
      preview = {
        filetypes = { "markdown", "obsidian_markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
}
