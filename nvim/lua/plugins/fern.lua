local u = require("utils")

--  <C-n> で Fernのトグル
u.keymap("n", "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>")
