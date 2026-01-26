-- 単語単位でジャンプできるようにするプラグイン
return {
  "smoka7/hop.nvim",
  enabled = true,
  version = "*",
  event = "VeryLazy",
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<Leader>w",
        function()
          require("hop").hint_words({
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          })
        end,
        mode = "n",
        icon = "",
        desc = "Hop - 単語単位で先頭にジャンプ",
      },
      {
        "<Leader>b",
        function()
          require("hop").hint_words({
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          })
        end,
        mode = "n",
        icon = "",
        desc = "Hop - カーソル以前の単語単位で先頭にジャンプ",
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
        icon = "",
        desc = "Hop - 単語単位で末尾にジャンプ",
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
        icon = "",
        desc = "Hop - カーソル以前の単語単位で末尾にジャンプ",
      },
    })
  end,
  config = function()
    require("hop").setup({})
  end,
}
