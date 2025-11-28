-- カーソルが当たった単語をハイライトする
return {
  "ya2s/nvim-cursorline",
  lazy = false,
  config = function()
    local color_palette = require("onedark.colors")
    require("nvim-cursorline").setup({
      cursorline = {
        enable = false,
      },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = false, bold = true, bg = color_palette.diff_change },
      },
    })
  end,
}
