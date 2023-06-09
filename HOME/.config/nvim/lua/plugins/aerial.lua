local aerial_ok, aerial = pcall(require, "aerial")
if not aerial_ok then
  return
end

aerial.setup({
  on_attach = function (bufnr)
    vim.keymap.set('n', '<leader>k', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '<leader>j', '<cmd>AerialNext<CR>', {buffer = bufnr})
    vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
  end
})
