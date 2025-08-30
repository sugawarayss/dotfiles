-- csv file syntax highlighter
return {
  "mechatroner/rainbow_csv",
  -- 遅延読み込みする
  lazy = true,
  -- csvファイルを開いた時にロードする
  ft = { "csv" },
}
