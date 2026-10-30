-- スクロールバー拡張
return {
  "petertriho/nvim-scrollbar",
  lazy = true,
  event = { "BufReadPre" },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    vim.g.scrollbar_v2_notice = false
    local palette = require("kanagawa.colors").setup().theme
    require("scrollbar").setup({
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = true,
      throttle_ms = 100,
      handle = {
        text = "",
        blend = 0,
        color = palette.ui.special, -- #32526c
        highlight = "CursorColumn",
        hide_if_all_visible = true,
      },
      marks = {
        Search = { color = palette.syn.string },
        Warn = { color = palette.syn.constant },
        Info = { color = palette.syn.fun },
        Hint = { color = palette.syn.parameter },
        Misc = { color = palette.syn.statement },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "snacks_terminal",
        "snacks_picker_list",
        "blink-cmp-menu",
        "noice",
        "prompt",
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = true,
      },
    })
  end,
}
