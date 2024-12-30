-- キー操作を画面に表示するプラグイン
return {
  "nvzone/showkeys",
  cmd = "ShowkeysToggle",
  keys = {
    { "<M-s>k", ":ShowkeysToggle<CR>", mode = "n", desc = "キー押下履歴を右上に表示する"}
  },
  opts = {
    winopts = {
      focusable = false,
      relative  = "editor",
      style     = "minimal",
      border    = "double",
      height    = 1,
      row       = 2,
      col       = 0,
    },
    -- 表示が消えるまでの秒数
    timeout = 3,
    -- 表示するキーの最大数
    maxkeys = 5,
    -- 同じキーを押した時に数字で表現するか
    show_count = false,
    excluded_modes = {},
    -- bottom-left, bottom-center, bottom-right, top-left, top-center, top-right
    position = "top-right",
    keyformat = {
      ["<BS>"]       = "󰁮 ",
      ["<CR>"]       = "󰘌",
      ["<Space>"]    = "󱁐",
      ["<Up>"]       = "󰁝",
      ["<Down>"]     = "󰁅",
      ["<Left>"]     = "󰁍",
      ["<Right>"]    = "󰁔",
      ["<PageUp>"]   = "Page 󰁝",
      ["<PageDown>"] = "Page 󰁅",
      ["<M>"]        = "Alt",
      ["<C>"]        = "Ctrl",
    },
  },
}
