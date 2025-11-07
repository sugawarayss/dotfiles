-- バッファサイズ調整、フォーカス移動、バッファ入替ができる
return {
  "mrjones2014/smart-splits.nvim",
  event = { "BufReadPre" },
  init = function()
    local wk = require("which-key")
    wk.add({
      -- フォーカス移動系
      { "<Leader>h", require("smart-splits").move_cursor_left, mode = "n", desc = "左バッファにカーソル移動" },
      { "<Leader>j", require("smart-splits").move_cursor_down, mode = "n", desc = "下バッファにカーソル移動" },
      { "<Leader>k", require("smart-splits").move_cursor_up, mode = "n", desc = "上バッファにカーソル移動" },
      { "<Leader>l", require("smart-splits").move_cursor_right, mode = "n", desc = "右バッファにカーソル移動" },
      -- リサイズ系
      { "<M-8>", require("smart-splits").resize_up, mode = "n", desc = "上方向にリサイズ" },
      { "<M-7>", require("smart-splits").resize_down, mode = "n", desc = "下方向にリサイズ" },
      { "<M-6>", require("smart-splits").resize_left, mode = "n", desc = "左方向にリサイズ" },
      { "<M-9>", require("smart-splits").resize_right, mode = "n", desc = "右方向にリサイズ" },
      -- バッファ入替系
      { "<C-S-s>h", require("smart-splits").swap_buf_left, mode = "n", desc = "左バッファと入れ替え" },
      { "<C-S-s>j", require("smart-splits").swap_buf_down, mode = "n", desc = "下バッファを入れ替え" },
      { "<C-S-s>i", require("smart-splits").swap_buf_up, mode = "n", desc = "上バッファと入れ替え" },
      { "<C-S-s>l", require("smart-splits").swap_buf_right, mode = "n", desc = "右バッファと入れ替え" },
    })
  end,
  config = function()
    require("smart-splits").setup({
      ignore_buftypes = {
        "nofile",
        "quickfix",
        "prompt",
      },
      ignore_filetypes = {
        -- "snacks_picker_list",
      },
      default_amount = 3,
      at_edge = "wrap",
      float_win_behavior = "previous",
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = true,
      ignore_events = {
        "BufEnter",
        "WinEnter",
      },
      multiplexer_integration = nil,
      disable_multiplexer_nav_when_zoomed = true,
      kitty_password = nil,
      zellij_move_focus_or_tab = false,
      log_level = "info",
    })
  end,
}
