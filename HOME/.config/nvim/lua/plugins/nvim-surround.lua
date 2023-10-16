return {
  "kylechui/nvim-surround",
  lazy = true,
  varsion = "*",
  event = "BufReadPre",
  config = function()
    require("nvim-surround").setup()
  end
}
