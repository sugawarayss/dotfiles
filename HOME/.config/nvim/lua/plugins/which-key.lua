-- keybindのヒントをpopupで表示する
return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      window = {
        border = "double",
        position = "bottom",
        winblend = 10
      }
    })
  end
}
