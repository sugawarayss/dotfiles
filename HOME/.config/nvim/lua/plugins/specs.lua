-- カーソルが大きく移動した時にエフェクトを表示する
return {
  "edluffy/specs.nvim",
  lazy = true,
  event = { "BufRead" },
  keys = {
    {"<M-s><M-p>", function() require("specs").toggle() end, desc = "Toggle Cursor Effect"},
    { "n", "n:lua require('specs').show_specs()<CR>", mode = "n", { noremap = true, silent = true }, desc = "Jump Cursor Next with Effect"},
    { "N", "N:lua require('specs').show_specs()<CR>", mode = "n", { noremap = true, silent = true }, desc = "Jump Cursor Prev with Effect"},
  },
  config = function ()
    require("specs").setup ({
      show_jumps = true,
      min_jump = 10,
      popup = {
        delay_ms = 0,
        inc_ms = 10,
        blend = 80,
        width = 20,
        winhl = "Search",
        fader = require("specs").linear_fader,
        resizer = require("specs").shrink_resizer
      },
      ignore_filetypes = {},
      ignore_buftypes = {
        nofile = true,
      },
    })
    require("specs").toggle()
  end
}
