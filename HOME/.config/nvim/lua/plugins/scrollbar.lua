-- スクロールバー拡張
return {
  "petertriho/nvim-scrollbar",
  lazy = true,
  event = { "BufReadPre" },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    require("scrollbar").setup({
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = false,
      throttle_ms = 100,
      handle = {
        color = palette.ui.special, -- #32526c
      },
      marks = {
        Search = { color = palette.syn.string },
        Warn = { color = palette.syn.constant },
        Info = { color = palette.syn.fun },
        Hint = { color = palette.syn.parameter },
        Misc = { color = palette.syn.statement },
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
