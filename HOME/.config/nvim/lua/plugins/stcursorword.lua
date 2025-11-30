-- カーソル位置の単語をハイライトするプラグイン
return {
  "sontungexpt/stcursorword",
  event = "VeryLazy",
  config = function()
    local color_palette = require("onedark.colors")
    require("stcursorword").setup({
      max_word_length = 100,
      min_word_length = 2,
      excluded = {
        filetypes = {
          "snacks_dashboard",
          "snacks_terminal",
          "snacks_picker_list",
          "sagaoutline",
        },
        buftypes = {},
        -- the pattern to match with the file path
        patterns = {},
      },
      highlight = {
        underline = false,
        bold = true,
        fg = nil,
        bg = color_palette.diff_text,
      },
    })
  end,
}
