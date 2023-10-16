-- telescopeでチートシートを表示できる
return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  -- 遅延読み込みする
  lazy = true,
  -- キーが押された時にロードする
  keys = {
    {"<C-c><C-s>", "<cmd>Cheatsheet<CR>", mode = "n"}
  },
  config = function()
    require("cheatsheet").setup({
      bundled_cheatsheets = {
        disabled = { "default", "unicode", "regex", "netrw", "markdown" },
      },
      include_only_installed_plugins = true,
      telescope_mappings = {
        ['<CR>'] = require('cheatsheet.telescope.actions').select_or_fill_commandline,
        ['<C-CR>'] = require('cheatsheet.telescope.actions').select_or_execute,
        ['<C-Y>'] = require('cheatsheet.telescope.actions').copy_cheat_value,
        ['<C-E>'] = require('cheatsheet.telescope.actions').edit_user_cheatsheet,
      },
    })
  end
}
