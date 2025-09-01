-- snacks.nvim で skkeleton を使えるようにする
return {
  "urugus/skkeleton-snacks",
  event = "BufReadPre",
  dependencies = {
    "vim-skk/skkeleton",
    "folke/snacks.nvim",
  },
  config = function()
    require("skkeleton_snacks").setup({
      toggle_key = "<C-j>",
      debug = false,
    })
  end,
}
