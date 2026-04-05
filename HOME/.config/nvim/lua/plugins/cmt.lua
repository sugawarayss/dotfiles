-- コメント制御プラグイン
return {
  "yuki-yano/cmt.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "gc", "<Plug>(cmt:line:toggle)", mode = { "n", "x" }, desc = "行コメントをトグル(オペレータ)" },
    { "gcc", "<Plug>(cmt:line:toggle:current)", mode = { "n" }, desc = "行コメントをトグル(カーソル行)" },
    { "gCC", "<Plug>(cmt:line:toggle:with-blank:current)", mode = { "n" }, desc = "空行を含んでコメントをトグル" },
    { "gw", "<Plug>(cmt:block:toggle)", mode = { "n", "x" }, desc = "ブロックコメントをトグル(オペレータ)" },
    { "gww", "<Plug>(cmt:block:toggle:current)", mode = "n", desc = "ブロックコメントをトグル(カーソル行)" },
    { "gWW", "<Plug>(cmt:block:toggle:current)", mode = "n", desc = "空行を含んでブロックコメントをトグル" },
  },
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    vim.g.cmt_mixed_mode_policy = {
      typescriptreact = "first-line",
      javascriptreact = "first-line",
      default = "mixed",
    }
    -- filetype毎のフォールバック設定
    vim.g.cmt_block_fallback = {
      tsx = { line = "// %s", block = { "{/*,", "*/}" } },
      python = { line = "# %s", block = { '"""', '"""' } },
    }
    -- cmt.nvimをバイパスするfiletype
    vim.g.cmt_disabled_filetypes = {
      -- "csv",
    }

    -- コメントアウト/アンコメント時のハイライト設定
    vim.api.nvim_set_hl(0, "CmtToggleCommented", { bg = palette.ui.bg_p2 })
    vim.api.nvim_set_hl(0, "CmtToggleUncommented", { bg = palette.ui.bg_p1 })
    vim.g.cmt_toggle_highlight = {
      enabled = true,
      duration = 200,
    }
  end,
}
