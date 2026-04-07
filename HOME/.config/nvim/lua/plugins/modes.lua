-- Mode でHighlightを設定するプラグイン
return {
  "mvllow/modes.nvim",
  event = { "VimEnter" },
  tag = "v0.3.0",
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    require("modes").setup({
      colors = {
        bg = "",
        -- copy = palette.bg_yellow,
        delete = palette.syn.special3,
        -- change = palette.orange,
        -- format = palette.cyan,
        insert = palette.ui.bg_m1,
        -- replace = palette.purple,
        -- select = palette.dark_purple,
        visual = palette.ui.bg_visual,
      },
      -- Set opacity for cursorline and number background
      line_opacity = 0.8,
      -- Enable cursor highlights
      set_cursor = false,
      -- Enable cursorline initially, and disable cursorline for inactive windows
      -- or ignored filetypes
      set_cursorline = false,
      -- Enable line number highlights to match cursorline
      set_number = false,
      -- Enable sign column highlights to match cursorline
      set_signcolumn = false,
      -- Disable modes highlights in specified filetypes
      -- Please PR commonly ignored filetypes
      ignore = {
        "NvimTree",
        "TelescopePrompt",
        "snacks_picker_list",
        "snacks_dashboard",
        "snacks_terminal",
        "sagaoutline",
      },
    })
  end,
}
