-- telescopeでチートシートを表示できる
return {
  {
    "sudormrfbin/cheatsheet.nvim",
    lazy = true,
    -- キーが押された時にロードする
    keys = {
      {"<C-c><C-s>", "<cmd>Cheatsheet<CR>", mode = "n", desc = "チートシートを表示"}
    },
    config = function()
      require("cheatsheet").setup({
        bundled_cheatsheets = {
          disabled = {
            "default",
            "nerd-fonts",
            "unicode",
            "regex",
            "netrw",
            "markdown",
          },
        },
        include_only_installed_plugins = true,
        telescope_mappings = {
          ["<CR>"]   = require("cheatsheet.telescope.actions").select_or_fill_commandline,
          ["<C-CR>"] = require("cheatsheet.telescope.actions").select_or_execute,
          ["<C-Y>"]  = require("cheatsheet.telescope.actions").copy_cheat_value,
          ["<C-E>"]  = require("cheatsheet.telescope.actions").edit_user_cheatsheet,
        },
      })
    end
  },
  { "nvim-telescope/telescope.nvim", lazy = true },
  { "nvim-lua/popup.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
}
