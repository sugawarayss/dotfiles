local u = require("utils")
local opt = { silent = true }
-- Telescope
-- Ctrl+p で曖昧ファイル検索
u.keymap("n", "<C-p>", ":Telescope find_files hidden=true theme=get_dropdown<CR>", opt)
-- Ctrl+g で曖昧ファイル内文字列検索
u.keymap("n", "<C-g>", ":Telescope live_grep theme=get_dropdown<CR>", opt)
-- Ctrl+d でプロジェクト内のTODOを検索
u.keymap("n", "<C-d>", ":TodoTelescope theme=get_dropdown<CR>", opt)
