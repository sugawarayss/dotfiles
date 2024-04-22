-- BookMark Plugin
return {
  "tomasky/bookmarks.nvim",
  lazy = true,
  event = { "VimEnter" },
  keys = {
    { "mm", function() require("bookmarks").bookmark_toggle() end, mode = "n", desc = "Toggle Bookmark" },
    { "mi", function() require("bookmarks").bookmark_ann() end, mode = "n", desc = "Add or edit Bookmark Annotation" },
    { "mc", function() require("bookmarks").bookmark_clean() end, mode = "n", desc = "Clean All Bookmarks in local buffer" },
    { "mn", function() require("bookmarks").bookmark_next() end, mode = "n", desc = "Jump to next mark in local buffer" },
    { "mp", function() require("bookmarks").bookmark_prev() end, mode = "n", desc = "Jump to previous mark in local buffer" },
    { "ml", function() require("bookmarks").bookmark_list() end, mode = "n", desc = "Show marked file list in quickfix window"},
  },
  config = function()
    require("bookmarks").setup({
      save_file = vim.fn.stdpath("data").."/bookmarks",
    })
  end
}
