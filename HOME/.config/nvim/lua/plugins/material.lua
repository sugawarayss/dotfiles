vim.opt.termguicolors = true
vim.opt.background = "dark"

require("material").setup({
    lualine_style = "default",
    disable = {
        background = false
    },
})
vim.g.material_style = "deep ocean"
vim.cmd "colorscheme material"
