local hop_ok, hop = pcall(require, "hop")
if not hop_ok then
  return
end
hop.setup()

local directions = require("hop.hint").HintDirection

-- パターンにマッチする場所にjump
vim.keymap.set('', '<Leader>/', function()
  hop.hint_patterns()
end, {remap=true})

-- 縦方向にjump
vim.keymap.set('', '<Leader>v', function()
  hop.hint_vertical()
end, {remap=true})

-- 単語にjump
-- <Leader>wキーでカーソルより後の単語にjump
vim.keymap.set('', '<Leader>w', function()
  hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = true})
end, {remap=true})
-- <Leader>bキーでカーソルより前の単語にjump
vim.keymap.set('', '<Leader>b', function()
  hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = true})
end, {remap=true})

-- マッチする文字にjump
-- fキーでカーソルから後ろを探す
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
-- Fキーでカーソルより前を探す
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})

-- マッチする文字の直前にjump
-- tキーでカーソルから後ろを探す
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
-- Tキーでカーソルより前を探す
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})
