-- 一括コメントアウト
return {
  "tpope/vim-commentary",
  -- 遅延読み込みする
  lazy = true,
  -- バッファがウィンドウに表示された時にロードする
  event = { "BufWinEnter" },
}
