local tokyonight_ok, tokyonight = pcall(require, "tokyonight")
if not tokyonight_ok then
  return
end
tokyonight.setup({
    style = "night",
  }
)



local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
if not catppuccin_ok then
  return
end

catppuccin.setup({
  flavour = "mocha",
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true,
  show_end_of_buffer = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.1,
  },
  styles = {
    comments = {}
  },
  integrations = {
    aerial = true,
    alpha = true,
    fern = true,
    fidget = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    gitsigns = true,
    hop = true,
    markdown = true,
    mason = true,
    noice = true,
    cmp = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    treesitter = true,
    telescope = {
      enabled = true,
    },
    native_lsp = {
        enabled = true,
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
        },
        inlay_hints = {
            background = true,
        },
    },
    notify = true,
    sandwich = true,
    which_key = true
  }
}
)
vim.cmd [[colorscheme catppuccin]]
