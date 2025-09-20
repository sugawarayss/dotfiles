-- Mode でHighlightを設定するプラグイン
return {
  "mvllow/modes.nvim",
  event = { "VimEnter" },
  tag = "v0.2.1",
  config = function()
    local color_palette = require("onedark.colors")
    require("modes").setup({
      colors = {
        bg = "",
        -- copy = color_palette.bg_yellow,
        delete = color_palette.red,
        -- change = color_palette.orange,
        -- format = color_palette.cyan,
        insert = color_palette.blue,
        replace = color_palette.purple,
        -- select = color_palette.dark_purple,
        visual = color_palette.yellow,
      },
      -- Set opacity for cursorline and number background
      line_opacity = 0.2,
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
