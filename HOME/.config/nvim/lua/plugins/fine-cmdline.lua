local fine_cmdline_ok, fine_cmdline = pcall(require, "fine-cmdline")
if not fine_cmdline_ok then
  return
end

fine_cmdline.setup({
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

local u = require("utils")
-- Normalモード時に":"でcommand lineをfloating windowで表示
u.keymap("n", ":", "<cmd>FineCmdline<CR>")

