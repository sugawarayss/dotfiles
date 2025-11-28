-- スクロールバー拡張
return {
  "petertriho/nvim-scrollbar",
  lazy = true,
  event = { "BufReadPre" },
  config = function()
    local color_palette = require("onedark.colors")
    require("scrollbar").setup({
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = false,
      throttle_ms = 100,
      handle = {
        color = color_palette.diff_text, -- #32526c
      },
      marks = {
        Search = { color = color_palette.cyan }, -- #5fafb9
        Error = { color = color_palette.red }, -- #e16d77
        Warn = { color = color_palette.yellow }, -- #dfbe81
        Info = { color = color_palette.green }, -- #99bc80
        Hint = { color = color_palette.blue }, -- #68aee8
        Misc = { color = color_palette.purple }, -- #c27fd7
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        search = true,
      },
    })
  end,
}
