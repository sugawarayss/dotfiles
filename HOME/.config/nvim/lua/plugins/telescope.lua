-- Fuzzy Finder プラグイン
local opt = { silent = true }
return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "lpoto/telescope-docker.nvim",
      "stevearc/aerial.nvim",
      {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        dependencies = {
          "kkharji/sqlite.lua",
          -- Only required if using match_algorithm fzf
          { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
          -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
          { "nvim-telescope/telescope-fzy-native.nvim" },
        }
      },
    },
    keys = {
      {"<F3>", "<cmd>Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>", mode = "n", opt, desc = "ファイル名で検索"},
      {"<F4>", "<cmd>Telescope live_grep hidden=true<CR>", mode = "n", opt, desc = "ファイル内容で検索"},
      {"<F5>", "<cmd>Telescope smart_open<CR>", mode = "n", opt, desc = "Smart Search"},
      {"<C-t><C-d>", "<cmd>TodoTelescope keywords=TODO,FIXME,WARN<CR>", mode = "n", opt, desc = "TODO 検索"},
      {"gr", "<cmd>Telescope lsp_references<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of References"},
      {"<M-g><M-b>", "<cmd>Telescope git_branches<CR>", mode = "n", opt, desc = "Git ブランチを検索"},
      {"<M-d><M-c>", "<cmd>Telescope docker containers theme=ivy<CR>", mode = "n", opt, desc = "Docker コンテナを検索"},
      {"<M-d><M-i>", "<cmd>Telescope docker images theme=ivy<CR>", mode = "n", opt, desc = "Docker イメージを検索"},
      {"<M-d><M-p>", "<cmd>Telescope docker compose theme=ivy<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Docker Compose"},
      {"<M-d><M-l>", "<cmd>Telescope docker files theme=ivy<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Dockerfile"},
      {"<C-c><C-h>", "<cmd>Telescope command_history<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Command History"},
      {"<C-b><C-f>", "<cmd>Telescope buffers show_all_buffers=true<CR>", mode = "n", opt, desc = "バッファを検索"},
      {"<C-b><C-m>", "<cmd>Telescope bookmarks list<CR>", mode = "n", opt, desc = "ブックマークを検索"},
      {"<M-k><M-m>", "<cmd>Telescope keymaps<CR>", mode = "n", opt, desc = "Keymap を検索"},
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local open_with_trouble = require("trouble.sources.telescope").open
      local add_to_trouble = require("trouble.sources.telescope").add
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          initial_mode = "insert",
          sorting_strategy = "ascending", --検索結果を上から下に並べる
          layout_strategy = "vertical",
          layout_config = {
            width = 0.9,
            height = 0.9,
          },
          winblend = 10,         --ウィンドウを若干半透明にする
          color_devicons = true,
          file_ignore_patterns = { --検索結果に含めないファイルを指定
            "^.git/",
            "^node_modules/",
            "^__pycache__/",
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          dynamic_preview_title = true,
          mappings = {
            n = {
              ['<ESC>'] = function(...) return actions.close(...) end,
              ['<C-t>'] = action_layout.toggle_preview,
            },
            i = {
              ['<C-c>'] = actions.delete_buffer,
              ['<C-u>'] = function(...) return actions.preview_scrolling_up(...) end,
              ['<C-d>'] = function(...) return actions.preview_scrolling_down(...) end,
              ['<C-s>'] = actions.select_horizontal,
              ['<C-x>'] = false,
              ['<C-t>'] = open_with_trouble,
            }
          }
        },
        pickers = {
          find_files = {
            layout_strategy = "vertical",
            layout_config = {
              prompt_position = "bottom",
            },
          },
          live_grep = {
            layout_strategy = "vertical",
            layout_config = {
              prompt_position = "bottom",
            },
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
          ["smart_open"] = {
            ["smart_open"] = {
              cwd_only = true,
            },
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("noice")
      telescope.load_extension("docker")
      telescope.load_extension("aerial")
      telescope.load_extension("bookmarks")
      telescope.load_extension("smart_open")
    end
}
