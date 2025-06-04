-- バッファーを閉じた時に、いい感じにウィンドウをリサイズする
return {
  "kwkarlwang/bufresize.nvim",
  lazy = true,
  event = { "VimEnter" },
  config = function()
    require("bufresize").setup({
      resize = {
        keys = {},
        trigger_events = { "VimResized" },
        increment = 5,
      },
    })
  end,
}
