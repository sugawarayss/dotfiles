-- カラーテーマ
return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      show_end_of_buffer = false,
      dim_inactive = {
        -- focusを失ったウィンドウの背景色を暗くする
        enabled = true,
        shade = "dark",
        percentage = 1.0,
      },
      styles = {
        comments = {}
      },
      integrations = {
        aerial = true,
        alpha = true,
        fidget = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        gitsigns = true,
        hop = true,
        markdown = true,
        mason = true,
        noice = true,
        cmp = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        nvimtree = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = false,
          },
        },
        -- notify = true,
        sandwich = true,
        which_key = true
      }
    })
    vim.cmd [[colorscheme catppuccin]]
  end
}
