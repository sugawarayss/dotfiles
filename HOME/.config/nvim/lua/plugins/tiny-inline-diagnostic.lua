return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      -- diagnostic appearance one of modern|classic|minimal|powerline|ghost|simple|nonerdfont
      preset = "ghost",
      -- Make diagnostic background transparent
      transparent_bg = false,
      -- Make cursorline background transparent for diagnostics
      transparent_cursorline = true,
      -- Customize highlight groups for colors
      -- Use Neovim highlight group names or hex colors like "#RRGGBB"
      hi = {
        error = "DiagnosticError", -- Highlight for error diagnostics
        warn = "DiagnosticWarn", -- Highlight for warning diagnostics
        info = "DiagnosticInfo", -- Highlight for info diagnostics
        hint = "DiagnosticHint", -- Highlight for hint diagnostics
        arrow = "NonText", -- Highlight for the arrow pointing to diagnostic
        background = "CursorLine", -- Background highlight for diagnostics
        mixing_color = "Normal", -- Color to blend background with (or "None")
      },
      -- List of filetypes to disable the plugin for
      disabled_ft = {},
      options = {
        -- display the source of diagnostics
        show_source = {
          enabled = true,
          -- only show source if multiple sources exist for the same diagnostic
          -- if_many = false,
        },
        -- Use icons from vim.diagnostic.config instead of preset icons
        use_icons_from_diagnostic = false,
        -- use_icons_from_diagnostic = true,
        set_arrow_to_diag_color = true,
        -- update frequency in milliseconds to improve preformance
        throttle = 20,
        -- minimum number of characters before wrapping ling messages
        softwrap = 30,
        add_messages = {
          -- show full diagnostic messages
          messages = true,
          -- show diagnostic count instead of messages when cursor not on line
          display_count = true,
          -- when counting, only show the most severe diagnostic
          use_max_severity = false,
          -- show multiple icons for multiple diagnostics of same severity
          show_multiple_glyphs = true,
        },
        multilines = {
          -- Enable support for multiline diagnostic messages
          enabled = true,
          -- Always show messages on all lines of multiline diagnostics
          always_show = true,
          -- Remove leading/trailing whitespace from each line
          trim_whitespaces = false,
          -- Number of spaces per tab when expanding tabs
          tabstop = 4,
          -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
          severity = nil,
        },
        -- Show all diagnostics on the current cursor line, not just those under the cursor
        show_all_diags_on_cursorline = false,
        -- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
        show_diags_only_under_cursor = false,
        -- Display related diagnostics from LSP relatedInformation
        show_related = {
          enabled = true, -- Enable displaying related diagnostics
          max_count = 3, -- Maximum number of related diagnostics to show per diagnostic
        },
        -- Enable diagnostics display in insert mode
        -- May cause visual artifacts; consider setting throttle to 0 if enabled
        enable_on_insert = false,
        -- Enable diagnostics display in select mode (e.g., during auto-completion)
        enable_on_select = false,
      },
    })
  end,
}
