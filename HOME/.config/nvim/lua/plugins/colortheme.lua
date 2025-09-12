-- カラーテーマ
return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedark").setup({
      -- Default theme style. ["dark", "darker", "cool", "deep", "warm", "warmer", "light"]
      style = "warmer",
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
      toggle_style_key = "<Leader>ts",
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
      highlights = {},

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
