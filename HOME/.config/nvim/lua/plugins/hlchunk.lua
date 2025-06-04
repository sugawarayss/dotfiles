-- インデントガイドを表示するプラグイン
return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter" },
  config = function()
    local color_palette = require("tokyonight.colors").setup()
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
          { fg = color_palette.blue1 }, -- #2ac3de
          { fg = color_palette.red1 }, -- #db4b4b
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
      },
      indent = {
        enable = true,
        use_treesitter = true,
        chars = { "▏" },
        style = {
          { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") },
        },
      },
      line_num = {
        enable = true,
        use_treesitter = true,
        style = color_palette.magenta, --#bb9af7
      },

      blank = {
        enable = true,
        chars = { "․" },
        style = {
          vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
        },
      },
    })
  end,
}
