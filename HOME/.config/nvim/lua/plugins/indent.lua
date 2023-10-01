local indent_blankline_ok, indent_blankline = pcall(require, "ibl")
if not indent_blankline_ok then
  return
end

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

local indent_block_highlight = {
  "CursorColumn",
  "Whitespace",
}

indent_blankline.setup({
  indent = {
    smart_indent_cap = false,
  },
  whitespace = {
    highlight = indent_block_highlight,
    remove_blankline_trail = false,
  },
  scope = {
    enabled = true,
    show_end = false,
    inject_languages = false,
    highlight = { "Function", "Label" },
  },
})
