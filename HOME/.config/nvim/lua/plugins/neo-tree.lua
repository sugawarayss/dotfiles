return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = true,
  keys = {
    { "<C-n>", ":Neotree toggle<CR>", mode = "n", desc = "Toggle File Exploer" },
  },
  depencencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "MunifTanjim/nui.nvim" },
    { "3rd/image.nvim" },
  },
  config = function ()
    require("neo-tree").setup({
      hide_dotfiles = false,
      hide_hidden = false,
      mappings = {
        ["<C-s>"] = "open_split",
        ["<C-v>"] = "open_vsplit",
      }
    })
  end,
}
