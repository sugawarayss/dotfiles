-- keybindのヒントをpopupで表示する
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup({
      window = {
        border = "double",
        position = "bottom",
        winblend = 10
      }
    })
  end
}
