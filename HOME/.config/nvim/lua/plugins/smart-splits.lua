-- バッファサイズ調整、フォーカス移動、バッファ入替ができる
return {
  "mrjones2014/smart-splits.nvim",
  event = { "BufReadPre" },
  config = function()
    local wk = require("which-key")
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
    wk.add({
      -- フォーカス移動系
      { "<M-h>", require("smart-splits").move_cursor_left, mode = "n", desc = "左バッファにカーソル移動" },
      { "<M-j>", require("smart-splits").move_cursor_down, mode = "n", desc = "下バッファにカーソル移動" },
      { "<M-k>", require("smart-splits").move_cursor_up, mode = "n", desc = "上バッファにカーソル移動" },
      { "<M-l>", require("smart-splits").move_cursor_right, mode = "n", desc = "右バッファにカーソル移動" },
      -- リサイズ系
      { "<C-M-h>", require("smart-splits").resize_left, mode = "n", desc = "左方向にリサイズ" },
      { "<C-M-j>", require("smart-splits").resize_down, mode = "n", desc = "下方向にリサイズ" },
      { "<C-M-k>", require("smart-splits").resize_up, mode = "n", desc = "上方向にリサイズ" },
      { "<C-M-l>", require("smart-splits").resize_right, mode = "n", desc = "右方向にリサイズ" },
      -- バッファ入替系
      { "<C-S-s>h", require("smart-splits").swap_buf_left, mode = "n", desc = "左バッファと入れ替え" },
      { "<C-S-s>j", require("smart-splits").swap_buf_down, mode = "n", desc = "下バッファを入れ替え" },
      { "<C-S-s>i", require("smart-splits").swap_buf_up, mode = "n", desc = "上バッファと入れ替え" },
      { "<C-S-s>l", require("smart-splits").swap_buf_right, mode = "n", desc = "右バッファと入れ替え" },
    })
  end,
}
