-- カラーコードを色付けするプラグイン
return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre" },
  config = function()
    local colorizer = require("colorizer")
    colorizer.setup({
      "*", -- highlight all files
      css = { rgb_fn = true },
      html = { names = false },
    }, {
      -- RGB hex codes
      RGB = true,
      -- RRGGBB hex codes
      RRGGBB = true,
      -- Name codes (like "Blue")
      names = true,
      -- RRGGBBAA hex codes
      RRGGBBAA = false,
      -- css rgb() and rgba() functions
      rgb_fn = false,
      -- css hsl() and hsla() functions
      hsl_fn = false,
      -- enable all css features
      css = false,
      -- enable all css functions
      css_fn = false,
      -- display mode (foreground | background)
      mose = "background",
    })
  end,
}
