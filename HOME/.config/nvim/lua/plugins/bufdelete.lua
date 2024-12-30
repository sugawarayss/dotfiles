-- バッファーを消しても、ウィンドウを消さないプラグイン
return {
  "famiu/bufdelete.nvim",
  lazy = true,
  event = "BufReadPre",
  keys = {
    { ":bd<CR>",  function() require("bufdelete").bufdelete(0, false) end, desc = "バッファーを消す" },
    { ":bd!<CR>", function() require("bufdelete").bufdelete(0, true) end,  desc = "バッファーを消す(強制)" },
  }
}
