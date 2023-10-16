-- w/bモーションでの移動をスマートにする
return {
  "kana/vim-smartword",
  lazy = true,
  event = { "BufReadPre" },
  keys = {
    {"w", "<Plug>(smartword-w)", "n"},
    {"b", "<Plug>(smartword-b)", "n"},
    {"e", "<Plug>(smartword-e)", "n"},
    {"ge", "<Plug>(smartword-ge)", "n"},
    {"w", "<Plug>(smartword-w)", "v"},
    {"b", "<Plug>(smartword-b)", "v"},
    {"e", "<Plug>(smartword-e)", "v"},
    {"ge", "<Plug>(smartword-ge)", "v"},
  }
}
