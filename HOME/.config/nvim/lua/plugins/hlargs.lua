-- treesitter で 引数をハイライトするプラグイン
return {
  "m-demare/hlargs.nvim",
  event = { "BufReadPost" },
  config = function()
    require("hlargs").setup()
  end,
}
