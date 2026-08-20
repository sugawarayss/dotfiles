return {
  "ChmaraX/herdr-nvim",
  lazy = false,
  config = function()
    require("herdr-nvim").setup({
      prefix = "<leader>a",
      keymaps = true,
      clear_after_send = true,
    })
  end,
}
