-- Insert Mode で <C-CR> で任意の囲い文字を抜けるプラグイン
return {
  "ysmb-wtsg/in-and-out.nvim",
  event = { "InsertEnter" },
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<C-CR>",
        function()
          require("in-and-out").in_and_out()
        end,
        mode = "i",
        icon = "🪽",
        desc = "InAndOut - 囲い文字の外にジャンプ",
      },
    })
  end,
  opts = { addtitional_targets = { "“", "”" } },
}
