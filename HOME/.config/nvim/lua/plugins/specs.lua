-- カーソルが大きく移動した時にエフェクトを表示する
return {
  "edluffy/specs.nvim",
  enabled = true,
  lazy = true,
  event = { "CursorMoved" },
  config = function ()
    require("specs").setup ({
      show_jumps = true,
      min_jump = 5,
      popup = {
        delay_ms = 0,
        inc_ms = 5,
        blend = 80,
        width = 50,
        winhl = "Pmenu",
        -- Faders:
        -- sinus_fader  ⌣/⌢\⌣/⌢\⌣/⌢\⌣/⌢
        -- linear_fader ▁▂▂▃▃▄▄▅▅▆▆▇▇██
        -- exp_fader    ▁▁▁▁▂▂▂▃▃▃▄▄▅▆▇
        -- pulse_fader  ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁
        -- empty_fader  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
        fader = require("specs").linear_fader,
        -- Resizers:
        -- shrink_resizer ░░▒▒▓█████▓▒▒░░
        -- slide_resizer  ████▓▓▓▒▒▒▒░░░░
        -- empty_resizer  ███████████████
        resizer = require("specs").shrink_resizer
      },
      ignore_filetypes = {},
      ignore_buftypes = { nofile = true },
    })
    vim.api.nvim_set_keymap('n', '<M-s><M-p>', ':lua require("specs").toggle()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'zz', 'zz:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'n', 'n:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'N', 'N:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
    require("specs").toggle()
  end
}
