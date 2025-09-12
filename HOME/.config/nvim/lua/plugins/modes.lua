-- Mode でHighlightを設定するプラグイン
return {
  "mvllow/modes.nvim",
  event = { "VimEnter" },
  tag = "v0.2.1",
  config = function()
    local color_palette = require("onedark.colors")
    require("modes").setup({
      colors = {
        bg = color_palette.bg1, -- #35373b
        copy = color_palette.dark_purple, -- #854897
        delete = color_palette.dark_red, -- #914141
        insert = color_palette.dark_cyan, -- #316171
        visual = color_palette.dark_yellow, -- #8c6724
      },
      -- Set opacity for cursorline and number background
      line_opacity = 0.4,
      -- Enable cursor highlights
      set_cursor = true,
      -- Enable cursorline initially, and disable cursorline for inactive windows
      -- or ignored filetypes
      set_cursorline = false,
      -- Enable line number highlights to match cursorline
      set_number = false,
      -- Enable sign column highlights to match cursorline
      set_signcolumn = false,
      -- Disable modes highlights in specified filetypes
      -- Please PR commonly ignored filetypes
      ignore_filetypes = { "NvimTree", "TelescopePrompt" },
    })
  end,
}
