-- csvを色付け
return {
  "Decodetalkers/csv-tools.lua",
  -- 遅延読み込みする
  lazy = true,
  -- csvファイルを開いた時にロードする
  ft = { "csv" },
  config = function()
    require("csvtools").setup({
      before       = 10,
      after        = 10,
      clearafter   = true,
      showoverflow = false,
      titleflow    = true,
    })
  end
}
