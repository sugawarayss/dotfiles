return {
  "junegunn/vim-easy-align",
  keys = {
    -- vipga でパラグラフ単位で整列
    { "ga", "<Plug>(EasyAlign)", mode = "x", desc="選択範囲を整列" },
    -- motion や text object で選択した範囲を整列
    { "ga", "<Plug>(EasyAlign)", mode = "n", desc="" },
  },
}
