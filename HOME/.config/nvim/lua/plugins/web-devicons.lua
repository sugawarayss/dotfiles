return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    require("nvim-web-devicons").setup({
      color_icons = true,
      default = true,
      strict = true,
      variant = "dark",
      blend = 0,
      override = {
        zsh = {
          icon = "",
          color = palette.ui.bg_search,
          cterm_color = "65",
          name = "Zsh",
        },
      },
      override_by_filename = {
        [".gitignore"] = {
          icon = "",
          color = palette.diag.warning,
          name = "Gitignore",
        },
      },
      override_by_operating_system = {
        ["apple"] = {
          icon = "",
          color = palette.diag.hint,
          cterm_color = "248",
          name = "Apple",
        },
      },
    })
  end,
}
