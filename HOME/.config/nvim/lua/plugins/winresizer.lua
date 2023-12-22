-- ウィンドウサイズを調整できる
return {
  "simeji/winresizer",
  -- 遅延読み込みする
  lazy = true,
  -- 新しいバッファの編集を開始する時にファイルを読み込む前にロードする
  event = { "BufReadPre" }
}
