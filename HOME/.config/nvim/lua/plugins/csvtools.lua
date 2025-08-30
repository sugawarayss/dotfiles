return {
  -- csvを色付け
  {
    "Decodetalkers/csv-tools.lua",
    -- 遅延読み込みする
    lazy = true,
    -- csvファイルを開いた時にロードする
    ft = { "csv" },
    config = function()
      require("csvtools").setup({
        before = 10,
        after = 10,
        clearafter = true,
        showoverflow = false,
        titleflow = true,
      })
    end,
  },
  -- csvをテーブル状に表示できるプラグイン
  {
    "hat0uma/csvview.nvim",
    ft = { "csv" },
    config = function()
      require("csvview").setup({
        view = {
          display_mode = "border",
        },
      })
    end,
  },
}
