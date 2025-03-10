-- yazi (file explorer) plugin
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = { "folke/snacks.nvim", lazy = true },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<Leader>e", mode = { "n", "v" }, "<cmd>Yazi<cr>",
      desc = "現在のファイルをyaziで開く",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      open_file_in_vertical_split = "<C-v>",
      open_file_in_horizontal_split = "<C-x>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
