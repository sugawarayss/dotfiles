-- バッファのサイズ調整するプラグイン
return {
  {
    "anuvyklack/windows.nvim",
    event = { "VimEnter" },
    cond = function()
      return not vim.g.vscode
    end,
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
            -- snacks_picker_list = 2,
            -- sagaoutline = 2,
          },
        },
        ignore = {
          buftype = { "quickfix" },
          filetype = {
            "snacks_picker_list",
            "snacks_terminal",
            "snacks_layout_box",
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
        {
          "<S-M-CR>",
          "<cmd>WindowsMaximize<CR>",
          mode = "n",
          desc = "Windows - カーソルがあるウィンドウを最大化する",
        },
        {
          "<S-M-e>",
          "<cmd>WindowsEqualize<CR>",
          mode = "n",
          desc = "Windows - カーソルがあるウィンドウの幅を最大化する",
        },
      })
    end,
  },
  { "anuvyklack/middleclass" },
  { "anuvyklack/animation.nvim" },
}
