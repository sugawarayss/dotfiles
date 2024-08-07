-- diff view を表示するためのプラグイン
return {
  "sindrets/diffview.nvim",
  lazy = true,
  event = { "BufReadPre" },
  keys = {
    { "<Leader>df", "<cmd>DiffviewOpen HEAD~1<CR>", mode = "n", desc = "Open Diff View" },
    { "<Leader>dh", "<cmd>DiffviewFileHistory<CR>", mode = "n", desc = "Open File History" },
    { "<Leader>dc", "<cmd>DiffviewClose<CR>", mode = "n", desc = "Close Diff View"},
  },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      hg_cmd = { "hg" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
      },
    })
  end
}
