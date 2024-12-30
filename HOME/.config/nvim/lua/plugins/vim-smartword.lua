-- w/bモーションでの移動をスマートにする
return {
  "kana/vim-smartword",
  lazy = true,
  event = { "BufReadPre" },
  keys = {
    { "w",  "<Plug>(smartword-w)",   mode = "n", desc = "前方の単語の先頭に移動" },
    { "b",  "<Plug>(smartword-b)",   mode = "n", desc = "後方の単語の先頭に移動" },
    { "e",  "<Plug>(smartword-e)",   mode = "n", desc = "前方の単語の末尾に移動" },
    { "ge", "<Plug>(smartword-ge)",  mode = "n", desc = "後方の単語の末尾に移動" },
    { "w",  "<Plug>(smartword-w)",   mode = "v", desc = "前方の単語の先頭まで選択" },
    { "b",  "<Plug>(smartword-b)",   mode = "v", desc = "後方の単語の先頭まで選択" },
    { "e",  "<Plug>(smartword-e)",   mode = "v", desc = "前方の単語の末尾まで選択" },
    { "ge", "<Plug>(smartword-ge)",  mode = "v", desc = "後方の単語の末尾まで選択" },
  }
}
