-- BookMark Plugin
return {
  "tomasky/bookmarks.nvim",
  lazy = true,
  event = { "VimEnter" },
  keys = {
    { "mm", function() require("bookmarks").bookmark_toggle() end, mode = "n", desc = "ブックマークをトグル" },
    { "mi", function() require("bookmarks").bookmark_ann() end,    mode = "n", desc = "ブックマークの注釈を追加/編集" },
    { "mc", function() require("bookmarks").bookmark_clean() end,  mode = "n", desc = "全てのブックマークを除去" },
    { "mn", function() require("bookmarks").bookmark_next() end,   mode = "n", desc = "次のブックマークにジャンプ" },
    { "mp", function() require("bookmarks").bookmark_prev() end,   mode = "n", desc = "前のブックマークにジャンプ" },
    { "ml", function() require("bookmarks").bookmark_list() end,   mode = "n", desc = "QuickFix にブックマーク一覧を表示" },
  },
  config = function()
    require("bookmarks").setup({
      save_file = vim.fn.stdpath("data").."/bookmarks",
    })
  end
}
