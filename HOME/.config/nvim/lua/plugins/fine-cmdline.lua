-- Normalモード時に":"でcommand lineをfloating windowで表示
vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", {noremap = true, silent = true})

require("fine-cmdline").setup({
  popup = {
    enter = true,
    focusable = true,
    zindex = 50,
    position = {
      row = 5,
      col = 0,
    },
    relative = "cursor",
    border = {
      style = "rounded",
      text = {
        top = "Vim Cmmand Line",
        top_align = "left",
      },
      padding = {
        top = 1,
        bottom = 1,
        left = 2,
        right = 2,
      }
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }
})
