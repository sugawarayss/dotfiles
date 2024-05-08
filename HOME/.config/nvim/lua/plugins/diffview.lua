-- diff view を表示するためのプラグイン
return {
  "sindrets/diffview.nvim",
  lazy = true,
  event = { "BufReadPre" },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({})
  end
}
