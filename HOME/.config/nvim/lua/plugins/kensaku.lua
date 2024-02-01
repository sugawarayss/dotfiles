-- 検索で日本語をローマ字で検索できるようにするプラグイン
return {
  -- 日本語をローマ字で検索できる
  {
    "lambdalisue/kensaku.vim",
    dependencies = {
      "vim-denops/denops.vim"
    },
  },
  -- 日本語をローマ字で検索できるKensakuコマンドを使えるようにする
  {
    "lambdalisue/kensaku-command.vim",
    lazy=true,
    event = "BufReadPre",
    dependencies = {
      "lambdalisue/kensaku.vim"
    },
  },
  -- /コマンドでローマ字で日本語を検索できるようにする
  {
    "lambdalisue/kensaku-search.vim",
    lazy=true,
    event = "BufReadPre",
    dependencies = {
      "lambdalisue/kensaku.vim"
    },
    config = function()
      vim.keymap.set('c', '<CR>', '<Plug>(kensaku-search-replace)<CR>', {noremap = true, silent = true})
    end,
  },
}
