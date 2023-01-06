local u = require("utils")
local opt = { silent = true }
-- Telescope
require("telescope").setup({
  extentions = {
    coc = {
      theme = "ivy",
      prefer_locations = ture,
    }
  },
})
require("telescope").load_extension("coc")

-- Ctrl+p で曖昧ファイル検索
u.keymap("n", "<C-p>", ":Telescope find_files hidden=true theme=get_dropdown<CR>", opt)
-- Ctrl+g で曖昧ファイル内文字列検索
u.keymap("n", "<C-g>", ":Telescope live_grep theme=get_dropdown<CR>", opt)
-- Ctrl+b でプロジェクト内のTODOを検索
u.keymap("n", "<C-b>", ":TodoTelescope theme=get_dropdown<CR>", opt)

-- Coc系のコマンド
u.keymap("n", ";d", ":Telescope coc definitions<CR>", opt)
u.keymap("n", ";y", ":Telescope coc type_definitions<CR>", opt)
u.keymap("n", ";i", ":Telescope coc implementations<CR>", opt)
u.keymap("n", ";r", ":Telescope coc references<CR>", opt)
