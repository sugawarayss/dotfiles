-- カラーテーマ
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local kanagawa = require("kanagawa")
    kanagawa.setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = false },
      functionStyle = {},
      keywordStyle = { italic = false },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = true,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      theme = "dragon",
      overrides = function(colors)
        return {
          -- foldopen/foldclose/foldsep
          FoldColumn = { fg = colors.theme.syn.constant },
          -- Cmdline popup border
          NoiceCmdlinePopupBorder = { bg = colors.theme.ui.bg },
          -- Cmdline popup border
          NoiceCmdlinePopupTitle = { bg = colors.theme.ui.bg },
          -- Cmdline popup border for search
          NoiceCmdlinePopupBorderSearch = { bg = colors.theme.ui.bg },
          HopNextKey = { fg = colors.theme.diag.warning, bold = true },
          HopNextKey1 = { fg = colors.theme.diag.ok, bold = true },
          HopNextKey2 = { fg = colors.theme.diag.hint },
          -- Blink 補完メニュー
          BlinkCmpMenu = { bg = colors.theme.ui.float.bg, fg = colors.theme.ui.float.bg_border },
          -- Blink 補完メニュー枠線
          BlinkCmpMenuBorder = { bg = colors.theme.ui.float.bg, fg = colors.theme.ui.float.fg_border },
          -- Blink 補完メニューの選択項目
          BlinkCmpMenuSelection = { bg = colors.theme.ui.pmenu.bg_sel, fg = colors.theme.ui.fg_dim },
          -- Blink 補完メニューのスクロールバー
          BlinkCmpScrollBarThumb = { bg = colors.theme.ui.special },
          -- Blink 補完ソース名表示
          BlinkCmpSource = { bg = colors.theme.ui.bg_p2, fg = colors.theme.syn.comment },
        }
      end,
      background = {
        dark = "dragon",
        light = "lotus",
      },
    })
    -- vim.cmd("colorscheme kanagawa")
    kanagawa.load("dragon") -- wave | dragon | lotus
  end,
}
--------------------
-- kanagawa theme dragon
-- require("kanagawa.colors").setup().theme
--------------------
-- {
--   diag = {
--     error = "#E82424",
--     hint = "#6A9589",
--     info = "#658594",
--     ok = "#98BB6C",
--     warning = "#FF9E3B"
--   },
--   diff = {
--     add = "#2B3328",
--     change = "#252535",
--     delete = "#43242B",
--     text = "#49443C"
--   },
--   syn = {
--     comment = "#737c73",
--     constant = "#b6927b",
--     deprecated = "#717C7C",
--     fun = "#8ba4b0",
--     identifier = "#c4b28a",
--     keyword = "#8992a7",
--     number = "#a292a3",
--     operator = "#c4746e",
--     parameter = "#a6a69c",
--     preproc = "#c4746e",
--     punct = "#9e9b93",
--     regex = "#c4746e",
--     special1 = "#949fb5",
--     special2 = "#c4746e",
--     special3 = "#c4746e",
--     statement = "#8992a7",
--     string = "#8a9a7b",
--     type = "#8ea4a2",
--     variable = "none"
--   },
--   term = { "#0d0c0c", "#c4746e", "#8a9a7b", "#c4b28a", "#8ba4b0", "#a292a3", "#8ea4a2", "#C8C093", "#a6a69c", "#E46876", "#87a987", "#E6C384", "#7FB4CA", "#938AA9", "#7AA89F", "#c5c9c5", "#b6927b", "#b98d7b" },
--   ui = {
--     bg = "#181616",
--     bg_dim = "#12120f",
--     bg_gutter = "#282727",
--     bg_m1 = "#1D1C19",
--     bg_m2 = "#12120f",
--     bg_m3 = "#0d0c0c",
--     bg_p1 = "#282727",
--     bg_p2 = "#393836",
--     bg_search = "#2D4F67",
--     bg_visual = "#223249",
--     fg = "#c5c9c5",
--     fg_dim = "#C8C093",
--     fg_reverse = "#223249",
--     float = {
--       bg = "#0d0c0c",
--       bg_border = "#0d0c0c",
--       fg = "#C8C093",
--       fg_border = "#54546D"
--     },
--     nontext = "#625e5a",
--     pmenu = {
--       bg = "#223249",
--       bg_sbar = "#223249",
--       bg_sel = "#2D4F67",
--       bg_thumb = "#2D4F67",
--       fg = "#DCD7BA",
--       fg_sel = "none"
--     },
--     special = "#7a8382",
--     whitespace = "#625e5a"
--   },
--   vcs = {
--     added = "#76946A",
--     changed = "#DCA561",
--     removed = "#C34043"
--   }
-- }
