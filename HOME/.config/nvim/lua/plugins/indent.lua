-- インデントを可視化するプラグイン
return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    vim.opt.list = true
    vim.opt.listchars:append "space:⋅"
    vim.opt.listchars:append "eol:↴"
    require("ibl").setup({
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
        highlight = { "Function", "Label" },
      },
    })
  end
}
