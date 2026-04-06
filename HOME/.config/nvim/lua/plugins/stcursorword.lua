-- カーソル位置の単語をハイライトするプラグイン
return {
  "sontungexpt/stcursorword",
  event = "VeryLazy",
  config = function()
    local palette = require("kanagawa.colors").setup().theme
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
        underline = true,
        bold = true,
        fg = nil,
        bg = palette.diff.text,
      },
    })
  end,
}
