-- カラーコードを色付け
return {
  "norcalli/nvim-colorizer.lua",
  -- 遅延読み込みする
  lazy = true,
  -- バッファがウィンドウに表示された時にロードする
  event = { "BufReadPre" },
  config = function()
    require("colorizer").setup({
      "*", -- Highligt all files
    })
  end
}
