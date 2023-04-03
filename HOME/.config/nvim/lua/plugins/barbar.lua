require "bufferline".setup {

}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<C-j>", "<Cmd>BufferPrevious<CR>", opts) --Ctrl + j で前のBufferに移動
map("n", "<C-k>", "<Cmd>BufferNext<CR>", opts)  --Ctrl + k で次のBufferに移動

map("n", "<leader>e", "<Cmd>BufferClose<CR>", opts)  --<leader>+eでBufferを削除
