-- Normalモード時に":"でcommand lineをfloating windowで表示
vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", {noremap = true})
