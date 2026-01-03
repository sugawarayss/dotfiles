-- スクロールバー拡張
return {
  "petertriho/nvim-scrollbar",
  lazy = true,
  event = { "BufReadPre" },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    local color_palette = require("onedarkpro.helpers").get_colors()
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
        Search = { color = color_palette.cyan },
        Warn = { color = color_palette.yellow },
        Info = { color = color_palette.green },
        Hint = { color = color_palette.blue },
        Misc = { color = color_palette.purple },
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
