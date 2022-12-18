local u = require("utils")

vim.g.coc_node_path = os.getenv("HOME") .. "/.asdf/shims/node"
--vim.g.coc_enable_locationlist = 1
vim.g.coc_global_extensions = {
    "coc-docker", "coc-diagnostic", "coc-pyright", "coc-json", "coc-syntax"
}

-- Coc Keymaps
u.keymap("n", "[coc]", "<Nop>", opts)
u.keymap("n", "<Space>c", "[coc]")
u.keymap("n", "[coc]f", "<Plug>(coc-format)", term_opts)
u.keymap("n", "[coc]<Space>", ":<C-u>CocList<CR>", term_opts)
u.keymap("n", "[coc]rn", "<Plug>(coc-rename)", term_opts)
u.keymap("n", "[coc]h", ":<C-u>call CocAction('doHover')<CR>", term_opts)
u.keymap("n", "[coc]d", "<Plug>(coc-definition)", term_opts)
u.keymap("n", "[coc]rf", "<Plug>(coc-references)", term_opts)
