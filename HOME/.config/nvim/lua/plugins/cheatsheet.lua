local cheatsheet_ok, cheatsheet = pcall(require, "cheatsheet")
if not cheatsheet_ok then
  return
end

cheatsheet.setup({
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

local u = require("utils")
u.keymap("n", "<C-c><C-s>", "<cmd>Cheatsheet<CR>")
