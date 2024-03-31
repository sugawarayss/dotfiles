-- カラーテーマ
return {
  "HoNamDuong/hybrid.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("hybrid").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        folds = true,
      },
      strikethrough = true,
      inverse = true,
      transparent = false,
    })
    vim.cmd.colorscheme("hybrid")
  end,
}

