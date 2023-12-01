return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = true,
  keys = {
    { "<C-n>", ":Neotree toggle<CR>", mode = "n", desc = "Toggle File Exploer" },
    { "<M-g><M-s>", ":Neotree float git_status<CR>", mode = "n", desc = "Show Git Status by Neotree"},
  },
  depencencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "MunifTanjim/nui.nvim" },
    { "3rd/image.nvim" },
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
        },
      }
    })
  end,
}
