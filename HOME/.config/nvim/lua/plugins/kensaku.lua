-- 検索で日本語をローマ字で検索できるようにするプラグイン
return {
  -- 日本語をローマ字で検索できる
  {
    "lambdalisue/kensaku.vim",
    enabled = false,
    event = "BufReadPre",
  },
  { "vim-denops/denops.vim", lazy = false },
  -- 日本語をローマ字で検索できるKensakuコマンドを使えるようにする
  {
    "lambdalisue/kensaku-command.vim",
    enabled = false,
    lazy = true,
    event = "BufReadPre",
  },
  -- /コマンドでローマ字で日本語を検索できるようにする
  {
    "lambdalisue/kensaku-search.vim",
    enabled = false,
    lazy = true,
    event = "BufReadPre",
    config = function()
      vim.keymap.set("c", "<CR>", "<Plug>(kensaku-search-replace)<CR>", { noremap = true, silent = true })
    end,
  },
}
