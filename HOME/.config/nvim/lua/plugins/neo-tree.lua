-- File Explorer プラグイン
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = true,
    keys = {
      { "<C-t><C-t>", ":Neotree toggle<CR>", mode = "n", desc = "Toggle File Exploer" },
      { "<M-g><M-s>", ":Neotree float git_status<CR>", mode = "n", desc = "Show Git Status by Neotree"},
    },
    depencencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "MunifTanjim/nui.nvim" },
      -- { "3rd/image.nvim" },
    },
    config = function ()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only workd on Windows
          },
          follow_current_file = {
            enabled = true, -- focus があるbufferに追従する
            leave_dirs_open = true, -- ディレクトリを開いたままにする
          },
        },
        window = {
          mappings = {
            ["<C-s>"] = "open_split",  -- 水平分割で開く
            ["<C-v>"] = "open_vsplit",  -- 垂直分割で開く
            ['<tab>'] = function (state) -- ファイルを開いてもNeotreeを閉じない
              local node = state.tree:get_node()
              if require("neo-tree.utils").is_expandable(node) then
                state.commands["toggle_node"](state)
              else
                state.commands['open'](state)
                vim.cmd('Neotree reveal')                  
              end
            end,
            -- ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true}},
          },
        }
      })
    end,
  },
  -- {  -- Vim上で画像を表示するプラグイン
  --   "3rd/image.nvim",
  --   lazy = false,
  --   config = function ()
  --     package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
  --     package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
  --     require("image").setup({
  --       backend = "kitty",
  --       integrations = {
  --         markdown = {
  --           enabled = true,
  --           clear_in_insert_mode = false,
  --           download_remote_images = true,
  --           only_render_image_at_cursor = false,
  --           filetypes = { "markdown", "vimwiki" }
  --         },
  --         neorg = {
  --           enabled = true,
  --           clear_in_insert_mode = false,
  --           download_remote_images = true,
  --           only_render_image_at_cursor = false,
  --           filetypes = { "norg" },
  --         },
  --         html = {
  --           enabled = false,
  --         },
  --         css = {
  --           enabled = false,
  --         },
  --       },
  --       max_width = nil,
  --       max_height = nil,
  --       max_width_window_percentage = nil,
  --       max_height_window_percentage = 50,
  --       window_overlap_clear_enabled = false,
  --       window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --       editor_only_render_when_forcused = false,
  --       tmux_show_only_in_active_window = false,
  --       hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  --     })
  --   end,
  -- },
}
