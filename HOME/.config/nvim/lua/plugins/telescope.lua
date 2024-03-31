-- Fuzzy Finder プラグイン
local opt = { silent = true }
return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "lpoto/telescope-docker.nvim",
      { "tom-anders/telescope-vim-bookmarks.nvim", dependencies = {"MattesGroeger/vim-bookmarks"}},
      "stevearc/aerial.nvim",
    },
    keys = {
      {"<C-p>", "<cmd>Telescope find_files hidden=true<CR>", mode = "n", opt, desc = "Show Fuzzy Finder by FileName"},
      {"<C-g>", "<cmd>Telescope live_grep hidden=true<CR>", mode = "n", opt, desc = "Show Fuzzy Finder by LiveGrep"},
      {"<C-t><C-d>", "<cmd>TodoTelescope<CR>", mode = "n", opt, desc = "Show Fuzzy Finder by ToDo Comment"},
      {"gr", "<cmd>Telescope lsp_references<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of References"},
      {"<M-g><M-b>", "<cmd>Telescope git_branches<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Git Branch"},
      {"<M-d><M-c>", "<cmd>Telescope docker containers theme=ivy<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Docker Containers"},
      {"<M-d><M-i>", "<cmd>Telescope docker images theme=ivy<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Docker Images"},
      {"<M-d><M-p>", "<cmd>Telescope docker compose theme=ivy<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Docker Compose"},
      {"<M-d><M-l>", "<cmd>Telescope docker files theme=ivy<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Dockerfile"},
      {"<C-c><C-h>", "<cmd>Telescope command_history<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Command History"},
      {"<F5>", "<cmd>Telescope buffers show_all_buffers=true<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Buffers"},
      {"<C-b><C-m>", "<cmd>Telescope vim_bookmarks all<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Bookmarks"},
      {"<C-k><C-m>", "<cmd>Telescope keymaps<CR>", mode = "n", opt, desc = "Show Fuzzy Finder of Keymaps"},
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local trouble = require("trouble.providers.telescope")
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
              ['<C-t>'] = trouble.open_with_trouble,
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
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("noice")
      telescope.load_extension("docker")
      telescope.load_extension("aerial")
      telescope.load_extension("vim_bookmarks")
      local color_palette = require("hybrid.colors").setup()
      vim.api.nvim_set_hl(0, "FloatBorder", {bg=color_palette.bg_hard, fg=color_palette.dull_cyan})
      vim.api.nvim_set_hl(0, "NormalFloat", {bg=color_palette.bg_hard})
      vim.api.nvim_set_hl(0, "TelescopeNormal", {bg=color_palette.bg_hard})
      vim.api.nvim_set_hl(0, "TelescopeBorder", {bg=color_palette.bg_hard, fg=color_palette.dull_cyan})
      vim.api.nvim_set_hl(0, "TelescopeTitle", {bg=color_palette.bg_hard, fg=color_palette.fg_hard, bold=true})
    end
}
