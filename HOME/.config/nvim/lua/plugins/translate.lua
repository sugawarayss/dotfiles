-- 翻訳プラグイン
return {
  "voldikss/vim-translator",
  lazy = true,
  config = function()
    local wk = require("which-key")
    vim.g.translator_target_lang = "ja"
    vim.g.translator_default_engines = { "google" }
    vim.g.translator_history_enable = true
    wk.add({
      { "<Leader>tj", "<cmd>TranslateW<CR>", mode = "n", icon = "󰊿", desc = "カーソル位置の単語を日本語に翻訳" },
      { "<Leader>tj", "<cmd>'<,'>TranslateW<CR>", mode = "v", icon = "󰊿", desc = "選択範囲を日本語に翻訳" },
      {
        "<Leader>te",
        "<cmd>TranslateW --target_lang=en<CR>",
        mode = "n",
        icon = "󰊿",
        desc = "カーソル位置の単語を英語に翻訳",
      },
      { "<Leader>te", "<cmd>'<,'>TranslateW --target_lang=en<CR>", mode = "v", icon = "󰊿", desc = "選択範囲を英語に翻訳" },
      {
        "<Leader>tr",
        "<cmd>TranslateR --target_lang=en<CR>",
        mode = "v",
        icon = "󰊿",
        desc = "選択範囲の日本語を英語に翻訳して置換",
      },
    })
  end,
}
