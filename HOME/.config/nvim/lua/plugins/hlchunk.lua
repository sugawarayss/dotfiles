-- インデントガイドを表示するプラグイン
return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter" },
  config = function()
    local color_palette = require("hybrid.colors").setup()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        style = {
          { fg = color_palette.bright_blue },  -- "#5f819c"
          { fg = color_palette.bright_red },   -- "#d54e53"
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
      },
      indent = {
        enable = true,
        use_treesitter = false,
        chars = {
          "▏",
        },
        style = {
            { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") }
        },
      },
      line_num = {
          enable = true,
          use_treesitter = true,
          style = color_palette.bright_magenta,  -- "#c397dB"
      },

      blank = {
          enable = true,
          chars = {
              "․",
          },
          style = {
              vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
          },
      },
    })
  end
}
