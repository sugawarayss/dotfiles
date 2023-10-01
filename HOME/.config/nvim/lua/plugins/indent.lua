local indent_blankline_ok, indent_blankline = pcall(require, "ibl")
if not indent_blankline_ok then
  return
end

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

indent_blankline.setup {
  show_end_of_line = true,
  space_char_blankline = "",
}
