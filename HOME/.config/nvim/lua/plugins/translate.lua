vim.g.translator_target_lang = "ja"
vim.g.translator_default_engines = { 'google' }
vim.g.translator_history_enable = true

vim.keymap.set("n", "<C-t>j", "<cmd>Translate<CR>")
vim.keymap.set("n", "<C-t>e", "<cmd>Translate --target_lang=en<CR>")
