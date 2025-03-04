-- BookMark Plugin
return {
  "tomasky/bookmarks.nvim",
  lazy = true,
  event = { "VimEnter" },
  keys = {
    { ";m", function() require("bookmarks").bookmark_toggle() end, mode = "n", desc = "ブックマークをトグル" },
    { ";i", function() require("bookmarks").bookmark_ann() end,    mode = "n", desc = "ブックマークの注釈を追加/編集" },
    { ";c", function() require("bookmarks").bookmark_clean() print("Clear Bookmarks in Local Buffer") end,  mode = "n", desc = "ローカルバッファーのブックマークを除去" },
    { ";j", function() require("bookmarks").bookmark_next() end,   mode = "n", desc = "次のブックマークにジャンプ" },
    { ";k", function() require("bookmarks").bookmark_prev() end,   mode = "n", desc = "前のブックマークにジャンプ" },
    { ";l", function() require("bookmarks").bookmark_list() end,   mode = "n", desc = "QuickFix にブックマーク一覧を表示" },
    { ";x", function() require("bookmarks").bookmark_clear_all() print("Clear All Bookmarks") end, mode = "n", desc = "全てのブックマークを除去"}
  },
  config = function()
    require("bookmarks").setup({
      save_file = vim.fn.stdpath("data").."/bookmarks",
    })
  end
}
