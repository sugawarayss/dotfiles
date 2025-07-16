-- ウィンドウサイズを調整できる
vim.g.winresizer_enable = 1
-- GUI VIM では動作させない
vim.g.winresizer_gui_enable = 0
-- リサイザーは<ESC> で終了する
vim.g.winresizer_finish_with_escape = 1
-- 左右のサイズ変更単位
vim.g.winresizer_vert_resize = 10
-- 上下のサイズ変更単位
vim.g.winresizer_horiz_resize = 3
-- サイズ変更モードの開始キー
vim.g.winresizer_start_key = "<C-S-E>"
-- GUI VIM でのサイズ変更モード開始キー
vim.g.winresizer_gui_start_key = "<C-S-A>"
-- 左方向へサイズ変更を指示するキー(h)
vim.g.winresizer_keycode_left = 104
-- 右方向へサイズ変更を指示するキー(l)
vim.g.winresizer_keycode_right = 108
-- 下方向へサイズ変更を指示するキー(j)
vim.g.winresizer_keycode_down = 106
-- 上方向へサイズ変更を指示するキー(k)
vim.g.winresizer_keycode_up = 107
-- フォーカスモードに入るキー(f)
vim.g.winresizer_keycode_focus = 102
-- 移動モードに入るキー(m)
vim.g.winresizer_keycode_move = 109
-- リサイズモードに入るキー(r)
vim.g.winresizer_keycode_resize = 114
-- モードをローテーションするキー(e)
--     リサイズ→ 移動 → フォーカス → リサイズ
vim.g.winresizer_keycode_mode = 101
-- リサイズを確定するキー(Enter)
vim.g.winresizer_keycode_finish = 13
-- リサイズをキャンセルするキー(q)
vim.g.winresizer_keycode_cancel = 113

return {
  "simeji/winresizer",
  -- 新しいバッファの編集を開始する時にファイルを読み込む前にロードする
  event = { "BufReadPre" },
}
