return {
  -- markdownをレンダリング
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "obsidian_markdown", "codecompanion" },
    cond = function()
      vim.g.markview_blink_loaded = true
      return not vim.g.vscode
    end,
    opts = {
      experimental = {
        -- テキストファイルをNeovim内で開く(file_open_commandの設定も必要)
        prefer_nvim = true,
        file_open_command = "tabnew",
        date_formats = {
          "^%d%d%d%d%-%d%d%-%d%d$",
        },
        date_time_formats = {
          "^%a%a%a %a%a%a %d%d %d%d%:%d%d%:%d%d ... %d%d%d%d$", --- UNIX date time
          "^%d%d%d%d%-%d%d%-%d%dT%d%d%:%d%d%:%d%dZ$", --- ISO 8601
        },
      },
      preview = {
        filetypes = { "markdown", "obsidian_markdown", "codecompanion" },
        ignore_buftypes = { "blink-cmp-documentation" },
      },
    },
  },
}
