local opt = { silent = true }
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "lpoto/telescope-docker.nvim",
      "tom-anders/telescope-vim-bookmarks.nvim",
      "stevearc/aerial.nvim",
    },
    lazy = false,
    keys = {
      {"<C-p>", "<cmd>Telescope find_files hidden=true<CR>", mode = "n", opt},
      {"<C-g>", "<cmd>Telescope live_grep hidden=true<CR>", mode = "n", opt},
      {"<C-b>", "<cmd>TodoTelescope<CR>", mode = "n", opt},
      {"gr", "<cmd>Telescope lsp_references<CR>", mode = "n", opt},
      {"<S-g>b", "<cmd>Telescope git_branches<CR>", mode = "n", opt},
      {"<M-d><M-c>", "<cmd>Telescope docker containers theme=ivy<CR>", mode = "n", opt},
      {"<M-d><M-i>", "<cmd>Telescope docker images theme=ivy<CR>", mode = "n", opt},
      {"<M-d><M-p>", "<cmd>Telescope docker compose theme=ivy<CR>", mode = "n", opt},
      {"<M-d><M-l>", "<cmd>Telescope docker files theme=ivy<CR>", mode = "n", opt},
      {"<M-h>", "<cmd>Telescope command_history<CR>", mode = "n", opt},
      {"<F5>", "<cmd>Telescope buffers show_all_buffers=true<CR>", mode = "n", opt},
      {"<M-b><M-m>", "<cmd>Telescope vim_bookmarks all<CR>", mode = "n", opt},
      {"<M-o><M-l>", "<cmd>Telescope aerial<CR>", mode = "n", opt},
      {"<M-k><M-m>", "<cmd>Telescope keymaps<CR>", mode = "n", opt},
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
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
          layout_strategy = "flex",
          layout_config = {
            width = 0.9,
            height = 0.5,
            vertical = { prompt_position= "top", preview_cutoff = 150, preview_width = 0.3 },
            horizontal = { prompt_position = "top", preview_cutoff = 150, preview_width = 0.3 },
          },
          winblend = 30,         --ウィンドウを若干半透明にする
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
              ['<C-t>'] = action_layout.toggle_preview,
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
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("noice")
      telescope.load_extension("docker")
      telescope.load_extension("aerial")
      telescope.load_extension("vim_bookmarks")
      vim.api.nvim_set_hl(0, "FloatBorder", {bg="#313244"})
      vim.api.nvim_set_hl(0, "NormalFloat", {bg="#313244"})
      vim.api.nvim_set_hl(0, "TelescopeNormal", {bg="#313244", fg="#94E2D5"})
      vim.api.nvim_set_hl(0, "TelescopeBorder", {bg="#313244", fg="#94E2D5"})
    end
}
