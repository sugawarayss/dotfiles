local u = require("utils")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.g['neoterm_autoinsert'] = 1
vim.g['neoterm_autoscroll'] = 1
vim.g['neoterm_default_mod'] = "botright"
--vim.g['neoterm_size'] = vim.fn.winheight(0)//3

--autocmd = autocmd("VimResized", {
--    group = augroup("AutoTermHeight", {clear = false}),
--    callback = function()
--        print(vim.fn.winheight(0))
--        vim.g['neoterm_size'] = vim.fn.winheight(0)
--    end
--})


u.keymap("n", "<c-t><c-t>", ":Ttoggle<CR>")
u.keymap("t", "<c-t><c-t>", "<c-\\><c-n>:Tclose!<CR>")
