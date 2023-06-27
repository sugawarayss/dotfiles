vim.g["fern#default_hidden"] = true --隠しファイルは表示する
local u = require("utils")
local opt = { noremap = true, silent = true }
--  <C-n> で Fernのトグル
u.keymap("n", "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=50<CR>", opt)
u.keymap("n", "<C-s>", "<Plug>(fern-action-open:split)")
u.keymap("n", "<C-v>", "<Plug>(fern-action-open:vsplit)")
