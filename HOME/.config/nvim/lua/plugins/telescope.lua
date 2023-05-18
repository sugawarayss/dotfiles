local u = require("utils")
local opt = { silent = true }
-- Telescope
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending", --検索結果を上から下に並べる
    winblend = 20, --ウィンドウを若干半透明にする
    file_ignore_patterns = { --検索結果に含めないファイルを指定
      "^.git/",
      "^node_modules/",
      "^__pycache__/",
    },
  },
  extentions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {

      }
    }
  },
})
require("telescope").load_extension("ui-select")

vim.g["fern#default_hidden"] = true --隠しファイルは表示する

-- Ctrl+p で曖昧ファイル検索
u.keymap("n", "<C-p>", ":Telescope find_files hidden=true<CR>", opt)
-- Ctrl+g で曖昧ファイル内文字列検索
u.keymap("n", "<C-g>", ":Telescope live_grep<CR>", opt)
-- Ctrl+b でプロジェクト内のTODOを検索
u.keymap("n", "<C-b>", ":TodoTelescope<CR>", opt)
-- gr で カーソル下変数参照一覧を検索
u.keymap("n", "gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opt)
