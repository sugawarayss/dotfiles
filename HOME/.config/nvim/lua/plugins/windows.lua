return {
  "anuvyklack/windows.nvim",
  event = { "VimEnter" },
  dependencies = {
    { "anuvyklack/middleclass" },
    { "anuvyklack/animation.nvim" },
  },
  config = function()
    vim.o.winwidth = 10
    vim.o.winminwidth = 10
    vim.o.equalalways = false
    local wk = require("which-key")
    require("windows").setup({
      autowidth = {
        enable = true,
        winwidth = 5,
        filetype = {
          help = 2,
        },
      },
      ignore = {
        buftype = { "quickfix" },
        filetype = { "snacks_picker_list", "undotree", "gundo" },
      },
      animation = {
        enable = true,
        duration = 300,
        fps = 30,
        easing = "in_out_sine",
      },
    })
    wk.add({
      { "<S-M-CR>", "<cmd>WindowsMaximize<CR>", mode = "n", desc = "サイズ調整" },
      { "<S-M-k>", "<cmd>WindowsMaximizeVertically<CR>", mode = "n", desc = "縦方向でサイズ調整" },
      { "<S-M-j>", "<cmd>WindowsMaximizeVertically<CR>", mode = "n", desc = "縦方向でサイズ調整" },
      { "<S-M-h>", "<cmd>WindowsMaximizeHorizontally<CR>", mode = "n", desc = "横方向でサイズ調整" },
      { "<S-M-l>", "<cmd>WindowsMaximizeHorizontally<CR>", mode = "n", desc = "横方向でサイズ調整" },
    })
  end,
}
