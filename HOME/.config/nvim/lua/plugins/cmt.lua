return {
  "yuki-yano/cmt.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "gc", "<Plug>(cmt:line:toggle)", mode = { "n", "x" }, desc = "行コメントをトグル(オペレータ)" },
    { "gcc", "<Plug>(cmt:line:toggle:current)", mode = "n", desc = "行コメントをトグル(カーソル行)" },
    { "gw", "<Plug>(cmt:block:toggle)", mode = { "n", "x" }, desc = "ブロックコメントをトグル(オペレータ)" },
    { "gww", "<Plug>(cmt:block:toggle:current)", mode = "n", desc = "ブロックコメントをトグル(カーソル行)" },
    { "gco", "<Plug>(cmt:open-below-comment)", mode = "n", desc = "コメント行を下に追加" },
    { "gcO", "<Plug>(cmt:open-above-comment)", mode = "n", desc = "コメント行を上に追加" },
  },
  config = function()
    local color_palette = require("onedark.colors")
    vim.g.cmt_mixed_mode_policy = {
      typescriptreact = "first-line",
      javascriptreact = "first-line",
      default = "mixed",
    }
    -- filetype毎のフォールバック設定
    vim.g.cmt_block_fallback = {
      tsx = { line = "// %s", block = { "{/*,", "*/}" } },
    }
    -- cmt.nvimをバイパスするfiletype
    vim.g.cmt_disabled_filetypes = {
      -- "csv",
    }

    -- コメントアウト/アンコメント時のハイライト設定
    vim.api.nvim_set_hl(0, "CmtToggleCommented", { bg = color_palette.dark_cyan })
    vim.api.nvim_set_hl(0, "CmtToggleUncommented", { bg = color_palette.diff_text })
    vim.g.cmt_toggle_highlight = {
      enabeld = true,
      duration = 200,
    }
  end,
}
