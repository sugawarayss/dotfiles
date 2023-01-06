local keyset = vim.keymap.set
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
local opts2 = {noremap = true, expr = true, replace_keycodes = false}

vim.g.coc_node_path = os.getenv("HOME") .. "/.asdf/shims/node"
--vim.g.coc_enable_locationlist = 1
vim.g.coc_global_extensions = {
    "coc-spell-checker",
    "coc-highlight",
    "coc-floaterm",
    "coc-lists",
    "coc-docker",
    "coc-diagnostic",
    "coc-git",
    "coc-xml",
    "coc-yaml",
    "coc-toml",
    "coc-json",
    "coc-syntax",
    "coc-pyright",
    "coc-go",
    "coc-rust-analyzer",
    "coc-deno",
    "coc-markdown-preview-enhanced",
    "coc-markdownlint",
}

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Coc Keymaps
keyset("i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "\<TAB>" : coc#refresh()]], opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts2)
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#:confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keyset("n", "gd", "<Plug>(coc-definition)")
keyset("n", "gy", "<Plug>(coc-type-definition")
keyset("n", "gi", "<Plug>(coc-implementation)")
keyset("n", "gr", "<Plug>(coc-references)")
keyset("n", "gh", ":<C-u>call CocAction('doHover')<CR>")
