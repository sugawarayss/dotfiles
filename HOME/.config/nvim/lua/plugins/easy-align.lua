-- 記号で整列するプラグイン
return {
  "junegunn/vim-easy-align",
  keys = {
    -- vipga でパラグラフ単位で整列
    { "al", "<Plug>(EasyAlign)", mode = "x", desc = "選択範囲を整列" },
    -- motion や text object で整列
    { "al", "<Plug>(EasyAlign)", mode = "n", desc = "記号で整列" },
  },
}
