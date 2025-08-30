-- カラーテーマ
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    require("tokyonight").setup({
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
      },
    })
    vim.cmd.colorscheme("tokyonight-moon")
  end,
}
