return {
  -- 日本語をローマ字で検索できる
  {
    "lambdalisue/kensaku.vim",
    event = "BufReadPre",
    dependencies = {
      "vim-denops/denops.vim"
    },
  },
  -- 日本語をローマ字で検索できるKensakuコマンドを使えるようにする
  {
    "lambdalisue/kensaku-command.vim",
    event = "BufReadPre",
    dependencies = {
      "lambdalisue/kensaku.vim"
    },
  },
  -- /コマンドでローマ字で日本語を検索できるようにする
  {
    "lambdalisue/kensaku-search.vim",
    event = "BufReadPre",
    dependencies = {
      "lambdalisue/kensaku.vim"
    },
  },
}
