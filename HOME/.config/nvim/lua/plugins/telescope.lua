local u = require("utils")
local opt = { silent = true }
-- Telescope
require("telescope").setup({
    defaults = {
      sorting_strategy = "ascending", --検索結果を上から下に並べる
      layout_config = {
        vertical = { height = 0.5, width = 0.9 },
        horizontal = { height = 0.5, width = 0.9 },
        center = { height = 0.5, width = 0.9 },
      },
      winblend = 30,         --ウィンドウを若干半透明にする
      file_ignore_patterns = { --検索結果に含めないファイルを指定
        "^.git/",
        "^node_modules/",
        "^__pycache__/",
      },
      mappings = {
        n = {
          ['<ESC>'] = function(...) return require("telescope.actions").close(...) end,
        },
        i = {
          ['<C-c>'] = require('telescope.actions').delete_buffer,
          ['<C-u>'] = function(...) return require("telescope.actions").preview_scrolling_up(...) end,
          ['<C-d>'] = function(...) return require("telescope.actions").preview_scrolling_down(...) end,
          ["<C-s>"] = require('telescope.actions').select_horizontal,
        }
      }
    },
    pickers = {
      find_files = {
        -- theme="dropdown",
      },
      live_grep = {
        -- theme="dropdown",
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extentions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {}
      },
      ["docker"] = {
        theme = "ivy",
        binary = "docker",
        log_level = vim.log.levels.INFO,
        init_term = "split new",
      },
      ["aerial"] = {
        ["_"] = false,
        json = true,
        yaml = true,
      },
    },
  },
  require("telescope").load_extension("ui-select"),
  require("telescope").load_extension("noice"),
  require("telescope").load_extension("docker"),
  require("telescope").load_extension("aerial"),
  require("telescope").load_extension("vim_bookmarks"),
  -- 曖昧ファイル名検索
  u.keymap("n", "<C-p>", "<cmd>Telescope find_files hidden=true<CR>", opt),
  -- 曖昧ファイル内文字列検索
  u.keymap("n", "<C-g>", "<cmd>Telescope live_grep hidden=true<CR>", opt),
  -- プロジェクト内のTODOを検索
  u.keymap("n", "<C-b>", "<cmd>TodoTelescope<CR>", opt),
  -- カーソル下変数参照一覧を検索
  u.keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opt),
  -- Git ブランチ一覧からチェックアウト
  u.keymap("n", "<S-g>b", "<cmd>Telescope git_branches<CR>", opt),
  -- docker container一覧
  u.keymap("n", "<M-d><M-c>", "<cmd>Telescope docker containers theme=ivy<CR>"),
  -- docker image一覧
  u.keymap("n", "<M-d><M-i>", "<cmd>Telescope docker images theme=ivy<CR>"),
  -- docker compose一覧
  u.keymap("n", "<M-d><M-p>", "<cmd>Telescope docker compose theme=ivy<CR>"),
  -- docker files一覧
  u.keymap("n", "<M-d><M-l>", "<cmd>Telescope docker files theme=ivy<CR>"),
  -- vim コマンド履歴一覧
  u.keymap("n", "<M-h>", "<cmd>Telescope command_history<CR>"),
  -- バッファー一覧
  u.keymap("n", "<F5>", "<cmd>Telescope buffers show_all_buffers=true<CR>"),
  -- ブックマーク一覧
  u.keymap("n", "<M-b><M-m>", "<cmd>Telescope vim_bookmarks all<CR>"),
  -- アウトライン
  u.keymap("n", "<M-o><M-l>", "<cmd>Telescope aerial<CR>"),
  -- keymap一覧
  u.keymap("n", "<M-k><M-m>", "<cmd>Telescope keymaps<CR>")
)
