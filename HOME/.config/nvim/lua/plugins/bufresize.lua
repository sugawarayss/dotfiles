-- バッファーを閉じた時に、いい感じにウィンドウをリサイズする
return {
  "kwkarlwang/bufresize.nvim",
  lazy = true,
  event = { "VimEnter" },
  config = function()
    local opts = { noremap = true, silent = true }
    require("bufresize").setup({
      register = {
        keys = {
          -- バッファ幅を調整
          -- { "n", "<M-h>", "5<C-w><", opts },
          -- { "n", "<M-l>", "5<C-w>>", opts },
          -- バッファ高を調整
          { "n", "<M-y>", "5<C-w>+", opts },
          { "n", "<M-u>", "5<C-w>-", opts },
        },
        trigger_events = { "BufWinEnter", "WinEnter" },
      },
      resize = {
        keys = {},
        trigger_events = { "VimResized" },
        increment = 5,
      },
    })
  end,
}
