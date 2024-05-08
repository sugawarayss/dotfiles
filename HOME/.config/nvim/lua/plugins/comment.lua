-- コメント系プラグイン
return {
  "numToStr/Comment.nvim",
  dependencies =  {
    "joosepAlviste/nvim-ts-context-commentstring",
  },
  opts = {
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    extra = {
      above = "gc0",
      below = "gco",
      eol = "gcA",
    },
    mappings = {
      basic = true,
      extra = true,
    },
    pre_hook = nil,
    post_hook = nil,
  },
  lazy = false,
  config = function()
    require("ts_context_commentstring").setup({
      -- disable default autocmd
      enable_autocmd = false,
    })
    require("Comment").setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end
}
