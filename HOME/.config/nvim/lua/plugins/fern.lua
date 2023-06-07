local u = require("utils")

--  <C-n> で Fernのトグル
u.keymap("n", "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=50<CR>")
u.keymap("n", "<C-s>", "<Plug>(fern-action-open:split)")
u.keymap("n", "<C-v>", "<Plug>(fern-action-open:vsplit)")
