-- コメント系プラグイン
return {
  {
    "numToStr/Comment.nvim",
    lazy = false,
    event = { "BufReadPre" },
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
      -- pre_hook = nil,
      post_hook = nil,
    },
    config = function()
      require("ts_context_commentstring").setup({
        -- disable default autocmd
        enable_autocmd = false,
      })
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })

      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },
  -- コメントアウトをtreesitterで構文の考慮できるようにする
  {
    "joosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    event = "BufRead",
    opts = function()
      require("ts_context_commentstring").setup()
    end,
  },
}
