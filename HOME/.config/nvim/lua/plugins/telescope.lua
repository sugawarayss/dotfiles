-- Fuzzy Finder プラグイン
local opt = { silent = true }
if not vim.g.vscode then
  return {
    {
      "nvim-telescope/telescope.nvim",
      lazy = false,
      keys = {
        -- search todo
        { "<leader>std",      "<cmd>TodoTelescope keywords=TODO,FIXME,WARN<CR>",                                 mode = "n", opt, desc = "TODO 検索" },
        -- resume
        { "<leader>r",        "<cmd>Telescope resume<CR>",                                                       mode = "n", opt, desc = "直前のTelescopeでの検索を再開"},
        -- ブックマーク検索(Search Book Marks)
        { "<leader>sbm",      "<cmd>Telescope bookmarks list<CR>",                                               mode = "n", opt, desc = "ブックマークを検索" },
        { "<M-d><M-c>",       "<cmd>Telescope docker containers theme=ivy<CR>",                                  mode = "n", opt, desc = "Docker コンテナを検索" },
        { "<M-d><M-i>",       "<cmd>Telescope docker images theme=ivy<CR>",                                      mode = "n", opt, desc = "Docker イメージを検索" },
        { "<M-d><M-p>",       "<cmd>Telescope docker compose theme=ivy<CR>",                                     mode = "n", opt, desc = "Docker Compose を曖昧検索" },
        { "<M-d><M-l>",       "<cmd>Telescope docker files theme=ivy<CR>",                                       mode = "n", opt, desc = "Dockerfileを曖昧検索" },
        -- snacks.nvim で代替
        -- { "<F4>",             "<cmd>Telescope live_grep hidden=true<CR>",                                        mode = "n", opt, desc = "ファイル内容で検索" },
        { "<Leader><Leader>", ":lua require('telescope').extensions.smart_open.smart_open({cwd_only=true})<CR>", mode = "n", opt, desc = "スマートファイル検索" },
        -- { "<M-g><M-b>",       "<cmd>Telescope git_branches<CR>",                                                 mode = "n", opt, desc = "Git ブランチを検索" },
        -- { "<C-c><C-h>",       "<cmd>Telescope command_history<CR>",                                              mode = "n", opt, desc = "コマンド履歴を曖昧検索" },
        -- { "<C-b><C-f>",       "<cmd>Telescope buffers show_all_buffers=true<CR>",                                mode = "n", opt, desc = "バッファを検索" },
        -- { "<M-k><M-m>",       "<cmd>Telescope keymaps<CR>",                                                      mode = "n", opt, desc = "Keymap を検索" },
        { "Q",                "<cmd>Telescope cmdline<CR>",                                                      mode = "n", opt, desc = "Cmdline" },
        -- { "<C-S-p>",          "<cmd>Telescope projects<CR>",                                                     mode = "n", opt, desc = "プロジェクトリストを表示"}
      },
      config = function()
        local telescope         = require("telescope")
        local actions           = require("telescope.actions")
        local action_layout     = require("telescope.actions.layout")
        local open_with_trouble = require("trouble.sources.telescope").open
        local add_to_trouble    = require("trouble.sources.telescope").add
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
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.9,
              height = 0.5,
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
                ["<ESC>"] = function(...) return actions.close(...) end,
                ["<C-t>"] = action_layout.toggle_preview,
              },
              i = {
                ["<C-c>"] = actions.delete_buffer,
                ["<C-u>"] = function(...) return actions.preview_scrolling_up(...) end,
                ["<C-d>"] = function(...) return actions.preview_scrolling_down(...) end,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-x>"] = false,
                ["<C-t>"] = open_with_trouble,
              }
            }
          },
          pickers = {
            find_files = {
              no_ignore = true,
              layout_strategy = "horizontal",
              layout_config = {
                prompt_position = "bottom",
              },
            },
            live_grep = {
              layout_strategy = "horizontal",
              layout_config = {
                prompt_position = "bottom",
              },
            },
            colorscheme = {
              enable_preview = true,
            },
          },
          extensions = {
            docker = {
              theme = "ivy",
              binary = "docker",
              compose_binary = "docker compose",
              buildx_binary = "docker buildx",
              machine_binary = "docker-machine",
              log_level = vim.log.levels.INFO,
              init_term = "split new",
            },
            -- fzfスタイルのソーター
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
            -- ファイル名での曖昧検索
            smart_open = {
              show_scores = true,
              match_algorithm = "fzf",
              disable_devicons = false,
              open_buffer_indicators = {previous = "", others = "󰺕"},
              result_limit = 40,
            },
            -- コマンド履歴を検索/実行できる拡張
            cmdline = {
              picker = {
                layout_config = {
                  width = 120,
                  height = 25,
                }
              },
              mappings = {
                complete = "<Tab>",
                run_selection = "<C-CR>",
                run_input = "<CR>",
              },
              -- overseer = { enabled = true },
           },
          },
        })
        telescope.load_extension("ui-select")
        telescope.load_extension("docker")
        telescope.load_extension("bookmarks")
        telescope.load_extension("smart_open")
      end
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- ファイル名での曖昧検索
    { "danielfalk/smart-open.nvim", branch = "0.2.x" },
    { "kkharji/sqlite.lua" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- telescope でコマンド履歴を検索/実行できる拡張
    { "jonarrien/telescope-cmdline.nvim" },
    -- telescope で docker 操作が行える拡張
    { "lpoto/telescope-docker.nvim" },
  }
else
  return {}
end
