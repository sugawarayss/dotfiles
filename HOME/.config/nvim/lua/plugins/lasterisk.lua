-- * コマンドを便利にするプラグイン
local ok, hlslens = pcall(require, "hlslens")
return {
  {
    "rapan931/lasterisk.nvim",
    event = { "BufReadPre" },
    init = function()
      local wk = require("which-key")
      wk.add({
        {
          "*",
          function()
            require("lasterisk").search({ silent = true })
            if ok then
              -- vscodeの場合、hlslensを無効にしているので、有効時のみstartを呼び出す
              hlslens.start()
            end
          end,
          mode = "n",
          desc = "Lasterisk - カーソル位置の単語を検索してハイライト",
        },
        {
          "g*",
          function()
            require("lasterisk").search({ is_whole = false, silent = true })
            if ok then
              -- vscodeの場合、hlslensを無効にしているので、有効時のみstartを呼び出す
              hlslens.start()
            end
          end,
          mode = { "n", "x" },
          desc = "Lasterisk - 単語区切りせずにカーソル位置の単語を検索してハイライト",
        },
      })
    end,
  },
}
