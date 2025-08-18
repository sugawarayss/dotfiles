-- バッファを入れ替えるプラグイン
return {
  "caenrique/swap-buffers.nvim",
  enabled = true,
  keys = {
    {
      "<C-M-l>",
      "<cmd>lua require('swap-buffers').swap_buffers('l')<CR>",
      mode = "n",
      desc = "バッファ右と入れ替える",
    },
    {
      "<C-M-h>",
      "<cmd>lua require('swap-buffers').swap_buffers('h')<CR>",
      mode = "n",
      desc = "バッファ左と入れ替える",
    },
    {
      "<C-M-k>",
      "<cmd>lua require('swap-buffers').swap_buffers('k')<CR>",
      mode = "n",
      desc = "バッファ上と入れ替える",
    },
    {
      "<C-M-j>",
      "<cmd>lua require('swap-buffers').swap_buffers('j')<CR>",
      mode = "n",
      desc = "バッファ下と入れ替える",
    },
  },
  config = function()
    require("swap-buffers").setup({
      ignore_filetypes = { "neo-tree", "toggleterm" },
    })
  end,
}
