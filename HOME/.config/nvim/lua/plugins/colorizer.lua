-- カラーコードを色付け
return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "*", -- Highligt all files
    })
  end
}
