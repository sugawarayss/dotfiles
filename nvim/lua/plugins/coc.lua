local u = require("utils")
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

vim.g.coc_node_path = os.getenv("HOME") .. "/.asdf/shims/node"
--vim.g.coc_enable_locationlist = 1
vim.g.coc_global_extensions = {
    "coc-docker",        -- https://www.npmjs.com/package/coc-docker
    "coc-diagnostic",    -- https://www.npmjs.com/package/coc-diagnostic
    "coc-pyright",       -- https://www.npmjs.com/package/coc-pyright
    "coc-python",        -- https://www.npmjs.com/package/coc-python
    "coc-go",            -- https://www.npmjs.com/package/coc-go
    "coc-rust-analyzer", -- https://www.npmjs.com/package/coc-rust-analyzer
    "coc-lua",           -- https://www.npmjs.com/package/coc-lua
    "coc-json",          -- https://www.npmjs.com/package/coc-json
    "coc-toml",          -- https://www.npmjs.com/package/coc-toml
    "coc-yaml",          -- https://www.npmjs.com/package/coc-yaml
    "coc-syntax",        -- https://www.npmjs.com/package/coc-syntax
    "coc-spell-checker", -- https://www.npmjs.com/package/coc-spell-checker
}

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Coc Keymaps
u.keymap("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
u.keymap("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
u.keymap("n", "gd", "<Plug>(coc-definition)")
u.keymap("n", "gy", "<Plug>(coc-type-definition")
u.keymap("n", "gi", "<Plug>(coc-implementation)")
u.keymap("n", "gr", "<Plug>(coc-references)")
u.keymap("n", "gh", ":<C-u>call CocAction('doHover')<CR>")
