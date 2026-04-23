return {
  {
    "lewis6991/hover.nvim",
    config = function()
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      require("hover").config({
        providers = {
          "hover.providers.diagnostic",
          "hover.providers.lsp",
          "whyis.hover", -- add your configuration
        },
        preview_opts = { border = "single" },
        preview_window = true,
        title = true,
      })
    end,
  },
  {
    "takeshid/whyis.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>wf", "<cmd>Whyis float<cr>", desc = "Whyis floating window" },
      { "<leader>wl", "<cmd>Whyis right<cr>", desc = "Whyis right side" },
    },
  },
}
