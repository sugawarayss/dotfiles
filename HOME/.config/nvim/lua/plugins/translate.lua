vim.g.translator_target_lang = "ja"
vim.g.translator_default_engines = { 'google' }
vim.g.translator_history_enable = true

vim.keymap.set("n", "<C-t>j", "<cmd>Translate<CR>")
vim.keymap.set("n", "<C-t>e", "<cmd>Translate --target_lang=en<CR>")


local pantran_ok, pantran = pcall(require, "pantran")
if not pantran_ok then
  return
end

pantran.setup({
  default_engine = "google",
  controls = {
    mappings = {
      edit = {
        n = {
          ["j"] = "gj",
          ["k"] = "gk"
        },
        i = {
          ["<C-y>"] = false,
        }
      },
      select = {},
    },
  },
})
vim.keymap.set("n", "<leader>tr", "<cmd>Pantran<CR>")
