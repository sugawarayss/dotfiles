local u = require("utils")
local opt = { silent = true }
-- Telescope
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending", --検索結果を上から下に並べる
    winblend = 5, --ウィンドウを若干半透明にする
    file_ignore_patterns = { --検索結果に含めないファイルを指定
      "^.git/",
      "^node_modules/",
      "^__pycache__/",
    },
  },
  extentions = {
    coc = {
      theme = "ivy",
      prefer_locations = ture,
    }
  },
})
require("telescope").load_extension("coc")

vim.g["fern#default_hidden"] = true --隠しファイルは表示する

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
