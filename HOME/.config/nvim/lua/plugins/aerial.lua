require("aerial").setup({
  on_attach = function (bufnr)
    vim.keymap.set('n', '<leader>k', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '<leader>j', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
