local u = require("utils")

-- Telescope
-- Ctrl+p で曖昧ファイル検索
u.keymap("n", "<C-p>", ":Telescope find_files hidden=true theme=get_dropdown<CR>")
-- Ctrl+g で曖昧ファイル内文字列検索
u.keymap("n", "<C-g>", ":Telescope live_grep theme=get_dropdown<CR>")
