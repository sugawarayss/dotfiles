-- 単語単位でジャンプできるようにするプラグイン
return {
  "smoka7/hop.nvim",
  enabled = true,
  version = "*",
  event = "VeryLazy",
  keys = {
    {
      "<Leader>w",
      function()
        require("hop").hint_words({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        })
      end,
      mode = "n",
      desc = "単語単位で先頭にジャンプ",
    },
    {
      "<Leader>b",
      function()
        require("hop").hint_words({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        })
      end,
      mode = "n",
      desc = "カーソル以前の単語単位で先頭にジャンプ",
    },
    {
      "<Leader>e",
      function()
        require("hop").hint_words({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          hint_position = require("hop.hint").HintPosition.END,
        })
      end,
      mode = "n",
      desc = "単語単位で末尾にジャンプ",
    },
    {
      "<Leader>ge",
      function()
        require("hop").hint_words({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          hint_position = require("hop.hint").HintPosition.END,
        })
      end,
      mode = "n",
      desc = "カーソル以前の単語単位で末尾にジャンプ",
    },
  },
  config = function()
    require("hop").setup({})
  end,
}
