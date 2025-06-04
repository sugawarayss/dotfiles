-- Insert Mode で <C-CR> で任意の囲い文字を抜けるプラグイン
return {
  "ysmb-wtsg/in-and-out.nvim",
  keys = {
    {
      "<C-CR>",
      function()
        require("in-and-out").in_and_out()
      end,
      mode = "i",
    },
  },
  opts = { addtitional_targets = { "“", "”" } },
}
