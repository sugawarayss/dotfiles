-- インデントガイドを表示するプラグイン
return {
  "shellRaining/hlchunk.nvim",
  -- snacks.nvimでできるので無効にする
  enabled = false,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    local color_palette = require("onedarkpro.helpers").get_colors()
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
          { fg = color_palette.blue }, -- #61afef
          { fg = color_palette.red }, -- #ef596f
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
          { fg = color_palette.selection }, -- #212121
        },
      },
      line_num = {
        enable = true,
        use_treesitter = true,
        style = color_palette.cyan, -- #2bbac5
      },
      -- FIXME: blank が正しく機能しないのはプラグインバグらしい。https://github.com/shellRaining/hlchunk.nvim/issues/123
      blank = {
        enable = true,
        chars = { "․" },
        style = {
          { fg = color_palette.diff_text }, -- #005869
        },
      },
    })
  end,
}
