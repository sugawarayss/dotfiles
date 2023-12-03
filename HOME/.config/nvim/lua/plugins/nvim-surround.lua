-- 囲う系の操作を簡単にするプラグイン
return {
  "kylechui/nvim-surround",
  lazy = true,
  version = "*",
  event = "BufReadPre",
  config = function()
    require("nvim-surround").setup()
  end
}
