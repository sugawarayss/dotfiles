-- コードアウトラインを表示するプラグイン
return {
  "stevearc/aerial.nvim",
  lazy = false,
  priority = 999,
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("aerial").setup({
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>k', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '<leader>j', '<cmd>AerialNext<CR>', { buffer = bufnr })
        vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
      end
    })
  end
}
