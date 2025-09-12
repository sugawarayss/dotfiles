-- インデントガイドを表示するプラグイン
return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter" },
  config = function()
    local color_palette = require("onedark.colors")
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
          { fg = color_palette.blue }, -- #68aee8
          { fg = color_palette.red }, -- #e16d77
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
      },
      indent = {
        enable = true,
        exclude_filetypes = {
          "", -- 空のファイルタイプを対象外にしないとエラー
        },
        use_treesitter = true,
        chars = { "│" },
        style = {
          { fg = color_palette.diff_change }, -- #203444
        },
      },
      line_num = {
        enable = true,
        use_treesitter = true,
        style = color_palette.cyan, -- #51a8b3
      },
      -- FIXME: blank が正しく機能しないのはプラグインバグらしい。https://github.com/shellRaining/hlchunk.nvim/issues/123
      blank = {
        enable = true,
        chars = { "․" },
        style = {
          { fg = color_palette.diff_text }, -- #32526c
        },
      },
    })
  end,
}
