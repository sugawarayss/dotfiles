local is_installed = vim.fn.exists('g:loaded_' .. 'kensaku_search') > 0
if is_installed then
  vim.keymap.set("c", "<CR>", "<Plug>(kensaku-search-replace)<CR>", { remap=false })
end


