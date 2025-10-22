return {
  "haya14busa/vim-edgemotion",
  event = { "BufReadPre" },
  keys = {
    { "<M-j>", "<Plug>(edgemotion-j)", mode = "n", desc = "前方のエッヂにジャンプ" },
    { "<M-k>", "<Plug>(edgemotion-k)", mode = "n", desc = "後方のエッヂにジャンプ" },
  },
}
