-- keybindのヒントをpopupで表示する
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- false | "classic" | "modern" | "helix"
    preset = "helix",
    win = {
      no_overlap = true,
      border = "double",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
      -- Additional vim.wo and vim.bo options
      bo = {},
      wo = {
        winblend = 0,
      },
    },
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    keys = {
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
    sort = { "local", "order", "group", "alphanum", "mod" },
    expand = function(node)
      return not node.desc
    end,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
      mappings = true,
      colors = true,
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
      },
      show_help = true,
      show_keys = true,
      disable = {
        ft = {},
        bt = {},
      },
      debug = false,
    },
  },
}
