return {
  "haya14busa/vim-edgemotion",
  event = { "BufReadPre" },
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<M-j>",
        "<Plug>(edgemotion-j)",
        mode = "n",
        icon = "🔼",
        desc = "EdgeMotion - 前方のエッヂにジャンプ",
      },
      {
        "<M-k>",
        "<Plug>(edgemotion-k)",
        mode = "n",
        icon = "🔽",
        desc = "EdgeMotion - 後方のエッヂにジャンプ",
      },
    })
  end,
}
