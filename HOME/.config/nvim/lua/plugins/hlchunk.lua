-- インデントガイドを表示するプラグイン
return {
  "shellRaining/hlchunk.nvim",
  enabled = true,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    require("hlchunk").setup({
      chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        exclude_filetypes = {
          log = false,
        },
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        style = {
          { fg = palette.syn.fun },
          { fg = palette.syn.preproc },
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
          { fg = palette.ui.bg_dim },
        },
      },
      line_num = {
        enable = true,
        use_treesitter = true,
        style = palette.syn.fun,
      },
      -- FIXME: blank が正しく機能しないのはプラグインバグらしい。https://github.com/shellRaining/hlchunk.nvim/issues/123
      blank = {
        enable = true,
        chars = { "․" },
        style = {
          { fg = palette.ui.bg_gutter },
        },
      },
    })
  end,
}
