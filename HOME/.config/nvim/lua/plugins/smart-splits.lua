-- バッファサイズ調整、フォーカス移動、バッファ入替ができる
return {
  "smart-splits-nvim/smart-splits.nvim",
  event = { "BufReadPre" },
  cond = function()
    return not vim.g.vscode
  end,
  init = function()
    local wk = require("which-key")
    wk.add({
      -- フォーカス移動系
      { "<Leader>h", require("smart-splits").move_cursor_left, mode = "n", desc = "SmartSplits - 左バッファにカーソル移動" },
      { "<Leader>j", require("smart-splits").move_cursor_down, mode = "n", desc = "SmartSplits - 下バッファにカーソル移動" },
      { "<Leader>k", require("smart-splits").move_cursor_up, mode = "n", desc = "SmartSplits - 上バッファにカーソル移動" },
      { "<Leader>l", require("smart-splits").move_cursor_right, mode = "n", desc = "SmartSplits - 右バッファにカーソル移動" },
      -- リサイズ系
      { "<M-8>", require("smart-splits").resize_up, mode = "n", desc = "SmartSplits - 上方向にリサイズ" },
      { "<M-7>", require("smart-splits").resize_down, mode = "n", desc = "SmartSplits - 下方向にリサイズ" },
      { "<M-6>", require("smart-splits").resize_left, mode = "n", desc = "SmartSplits - 左方向にリサイズ" },
      { "<M-9>", require("smart-splits").resize_right, mode = "n", desc = "SmartSplits - 右方向にリサイズ" },
      -- バッファ入替系
      { "<C-S-s>h", require("smart-splits").swap_buf_left, mode = "n", icon = "🔁", desc = "SmartSplits - 左バッファと入れ替え" },
      { "<C-S-s>j", require("smart-splits").swap_buf_down, mode = "n", icon = "🔃", desc = "SmartSplits - 下バッファを入れ替え" },
      { "<C-S-s>i", require("smart-splits").swap_buf_up, mode = "n", icon = "🔃", desc = "SmartSplits - 上バッファと入れ替え" },
      { "<C-S-s>l", require("smart-splits").swap_buf_right, mode = "n", icon = "🔁", desc = "SmartSplits - 右バッファと入れ替え" },
    })
  end,
  config = function()
    require("smart-splits").setup({
      ignored_buftypes = {
        "nofile",
        "quickfix",
        "prompt",
      },
      ignored_filetypes = {
        -- "snacks_picker_list",
      },
      resize = {
        -- リサイズ時に変動するサイズ
        amount = 3,
        -- リサイズ中に無視するイベント
        ignored_events = { "BufEnter", "WinEnter" },
      },
      move = {
        -- 移動する方向にウィンドウが存在しない場合の動作 (stop|wrap|split|func(ctx))
        at_edge = "wrap",
        -- 水平方向に移動する際にカーソルを同じ画面行に維持する
        same_row = false,
      },
      swap = {
        -- バッファを新ウィンドウでも追跡する
        move_cursor = false,
      },
      mux = {
        -- バックエンドの優先度順
        backend = nil,
        -- バックエンドを検出できない場合に警告
        warn_if_unusable = true,
      },
      log = {
        level = "info",
        file = false,
      },
    })
  end,
}
