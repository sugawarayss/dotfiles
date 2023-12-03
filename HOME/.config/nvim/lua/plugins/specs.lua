-- カーソルが大きく移動した時にエフェクトを表示する
return {
  "edluffy/specs.nvim",
  lazy = true,
  event = { "BufRead" },
  keys = {
    {"<M-s><M-p>", "n", function() require("specs").show_specs() end, desc = "Toggle Cursor Effect"},
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
    vim.api.nvim_set_keymap('n', 'n', 'n:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'N', 'N:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
    require("specs").toggle()
  end
}
