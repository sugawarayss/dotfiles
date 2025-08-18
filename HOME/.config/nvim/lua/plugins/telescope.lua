-- Fuzzy Finder プラグイン
if not vim.g.vscode then
  return {
    {
      "nvim-telescope/telescope.nvim",
      lazy = false,
      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_layout = require("telescope.actions.layout")
        local open_with_trouble = require("trouble.sources.telescope").open
        -- local add_to_trouble = require("trouble.sources.telescope").add
        local wk = require("which-key")
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
            winblend = 10, --ウィンドウを若干半透明にする
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
                ["<ESC>"] = function(...)
                  return actions.close(...)
                end,
                ["<C-t>"] = action_layout.toggle_preview,
              },
              i = {
                ["<C-c>"] = actions.delete_buffer,
                ["<C-u>"] = function(...)
                  return actions.preview_scrolling_up(...)
                end,
                ["<C-d>"] = function(...)
                  return actions.preview_scrolling_down(...)
                end,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-x>"] = false,
                ["<C-t>"] = open_with_trouble,
              },
            },
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
          },
        })
        telescope.load_extension("docker")
        telescope.load_extension("bookmarks")
        -- キーマップを設定
        wk.add({
          -- search todo
          {
            "<leader>std",
            "<cmd>TodoTelescope keywords=TODO,FIXME,WARN<CR>",
            mode = "n",
            icon = "",
            desc = "TODO 検索",
          },
          -- ブックマーク検索(Search Book Marks)
          {
            "<leader>sbm",
            "<cmd>Telescope bookmarks list<CR>",
            mode = "n",
            icon = "󰂼",
            desc = "ブックマークを検索",
          },
          {
            "<M-d><M-c>",
            "<cmd>Telescope docker containers theme=ivy<CR>",
            mode = "n",
            icon = "󰡨",
            desc = "Docker コンテナを検索",
          },
          {
            "<M-d><M-i>",
            "<cmd>Telescope docker images theme=ivy<CR>",
            mode = "n",
            icon = "󰡨",
            desc = "Docker イメージを検索",
          },
          {
            "<M-d><M-p>",
            "<cmd>Telescope docker compose theme=ivy<CR>",
            mode = "n",
            icon = "󰡨",
            desc = "Docker Compose を曖昧検索",
          },
          {
            "<M-d><M-l>",
            "<cmd>Telescope docker files theme=ivy<CR>",
            mode = "n",
            icon = "󰡨",
            desc = "Dockerfileを曖昧検索",
          },
        })
      end,
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- telescope で docker 操作が行える拡張
    { "lpoto/telescope-docker.nvim" },
  }
else
  return {}
end
