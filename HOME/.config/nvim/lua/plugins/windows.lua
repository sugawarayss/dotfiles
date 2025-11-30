return {
  {
    "anuvyklack/windows.nvim",
    event = { "VimEnter" },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      local wk = require("which-key")
      require("windows").setup({
        autowidth = {
          enable = false,
          winwidth = 5,
          filetype = {
            help = 2,
            -- snacks_picker_list = 2,
            -- sagaoutline = 2,
          },
        },
        ignore = {
          buftype = { "quickfix" },
          filetype = {
            "snacks_picker_list",
            "snacks_terminal",
            "sagaoutline",
            "undotree",
            "gundo",
          },
        },
        animation = {
          enable = true,
          duration = 300,
          fps = 30,
          easing = "in_out_sine",
        },
      })
      wk.add({
        { "<S-M-CR>", "<cmd>WindowsToggleAutowidth<CR>", mode = "n", desc = "カーソルがあるウィンドウを最大化する" },
        { "<S-M-k>", "<cmd>WindowsMaximizeVertically<CR>", mode = "n", desc = "カーソルがあるウィンドウの幅を最大化する" },
        { "<S-M-j>", "<cmd>WindowsMaximizeVertically<CR>", mode = "n", desc = "カーソルがあるウィンドウの幅を最大化する" },
        { "<S-M-h>", "<cmd>WindowsMaximizeHorizontally<CR>", mode = "n", desc = "カーソルがあるウィンドウの高さを最大化する" },
        { "<S-M-l>", "<cmd>WindowsMaximizeHorizontally<CR>", mode = "n", desc = "カーソルがあるウィンドウの高さを最大化する" },
      })
    end,
  },
  { "anuvyklack/middleclass" },
  { "anuvyklack/animation.nvim" },
}
