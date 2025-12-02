-- カラーテーマ
return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedark").setup({
      -- Default theme style. ["dark", "darker", "cool", "deep", "warm", "warmer", "light"]
      style = "warmer",
      -- black = "#101012",
      -- bg0 = "#232326",
      -- bg1 = "#2c2d31",
      -- bg2 = "#35363b",
      -- bg3 = "#37383d",
      -- bg_d = "#1b1c1e",
      -- bg_blue = "#68aee8",
      -- bg_yellow = "#e2c792",
      -- fg = "#a7aab0",
      -- purple = "#bb70d2",
      -- green = "#8fb573",
      -- orange = "#c49060",
      -- blue = "#57a5e5",
      -- yellow = "#dbb671",
      -- cyan = "#51a8b3",
      -- red = "#de5d68",
      -- grey = "#5a5b5e",
      -- light_grey = "#818387",
      -- dark_cyan = "#2b5d63",
      -- dark_red = "#833b3b",
      -- dark_yellow = "#7c5c20",
      -- dark_purple = "#79428a",
      -- diff_add = "#282b26",
      -- diff_delete = "#2a2626",
      -- diff_change = "#1a2a37",
      -- diff_text = "#2c485f",
      -- Show/hide background
      transparent = true,
      -- Change terminal color as per the selected theme style
      term_colors = true,
      -- Show the end-of-buffer tildes.
      ending_tildes = false,
      -- reverse item kind highlights in cmp menu
      cmp_itemkind_reverse = true,

      -- Toggle theme style --
      -- keybind to toggle theme style, Leave it nil to disable it
      toggle_style_key = nil,
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      -- Change code style --
      -- Options are itaclic, bold, unserline, none
      -- You can configure multiple style with comma separated
      code_style = {
        comments = "none",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Lualine options --
      lualine = {
        -- lualine cneter bar transparency
        transparent = true,
      },

      -- Custom Highlights --
      -- Override default colors
      colors = {},
      -- Override highlight groups
      highlights = {
        -- 対応する括弧のハイライト
        MatchParen = { bg = "#2c2d31" },
        -- Flashによるジャンプや置換対象のハイライト
        Substitute = { fg = "#232326", bg = "#8fb573", fmt = "bold" },
        -- hop.nvimのラベル色
        HopNextKey = { fg = "#de5d68", fmt = "bold" },
        HopNextKey1 = { fg = "#57a5e5", fmt = "bold" },
        HopNextKey2 = { fg = "#51a8b3", fmt = "bold" },
        -- Copilot サジェスト
        CopilotSuggestion = { fg = "#2b5d63" },
        CopilotAnnotation = { fg = "#2b5d63", fmt = "italic" },
      },

      -- Plugins Config --
      diagnostics = {
        -- darker colors for diagnostic
        darker = true,
        -- use undercurl instead of underline for diagnostics
        undercurl = true,
        -- use background color or virtual text
        background = true,
      },
    })
    require("onedark").load()
  end,
}
