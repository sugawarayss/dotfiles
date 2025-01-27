-- カラーコードを色付け と カラーピッカーを表示するプラグイン
return {
  "uga-rosa/ccc.nvim",
  event = { "BufReadPre" },
  config = function()
    vim.opt.termguicolors = true
    local ccc = require("ccc")
    ccc.setup({
      highlighter = {
        auto_enable = true,
        lsp = true,
      }
    })
  end
}
