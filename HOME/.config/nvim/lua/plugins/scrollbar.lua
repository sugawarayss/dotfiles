-- スクロールバー拡張
return {
  "petertriho/nvim-scrollbar",
  lazy = true,
  event = { "BufReadPre" },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    require("scrollbar").setup({
      set_highlights = true,
      exclude = {
        buftypes = { terminal = true },
        filetypes = {
          "snacks_terminal",
          "snacks_picker_input",
          "snacks_picker_list",
          "blink-cmp-menu",
          "noice",
          "prompt",
        },
        unfocusable = true,
        when = false,
      },
      marks = {
        Cursor = { text = { "•" }, priority = 0, highlight = "Normal" },
        Mark = { text = {}, priority = 1, highlight = "Special" },
        Search = { text = { "-", "=" }, priority = 1, highlight = { fg = palette.syn.string } },
        Error = { text = { "-", "=" }, priority = 2, highlight = "DiagnosticVirtualTextError" },
        Warn = { text = { "-", "=" }, priority = 3, highlight = { fg = palette.syn.constant } },
        Info = { text = { "-", "=" }, priority = 4, highlight = { fg = palette.syn.fun } },
        Hint = { text = { "-", "=" }, priority = 5, highlight = { fg = palette.syn.parameter } },
        Misc = { text = { "-", "=" }, priority = 6, highlight = { fg = palette.syn.statement } },
        GitAdd = { text = { "┃" }, priority = 7, highlight = "GitSignsAdd" },
        GitChange = { text = { "┃" }, priority = 7, highlight = "GitSignsChange" },
        GitDelete = { text = { "▁" }, priority = 7, highlight = "GitSignsDelete" },
        MiniDiffAdd = { text = { "▒" }, priority = 7, highlight = "MiniDiffSignAdd" },
        MiniDiffChange = { text = { "▒" }, priority = 7, highlight = "MiniDiffSignChange" },
        MiniDiffDelete = { text = { "▒" }, priority = 7, highlight = "MiniDiffSignDelete" },
        SignifyAdd = { text = { "┃" }, priority = 7, highlight = "SignifySignAdd" },
        SignifyChange = { text = { "┃" }, priority = 7, highlight = "SignifySignChange" },
        SignifyDelete = { text = { "▁" }, priority = 7, highlight = "SignifySignDelete" },
        VGitAdd = { text = { "┃" }, priority = 7, highlight = "GitSignsAdd" },
        VGitChange = { text = { "┃" }, priority = 7, highlight = "GitSignsChange" },
        VGitDelete = { text = { "▁" }, priority = 7, highlight = "GitSignsDelete" },
      },
      -- cursor / diagnostic / search はv2でデフォルト有効
      providers = {
        cursor = true,
        diagnostic = true,
        search = true,
        marks = true,
        gitsigns = true,
        mini_diff = false,
        signify = false,
        vgit = false,
        ale = false,
        coc = false,
        treesitter = true,
        lsp_semantic_tokens = false,
      },
      scrollbar = {
        -- Global options
        enabled = true,
        show = true,
        visibility = "all", -- "all" or "active"
        autohide = false, -- true, or { delay_ms = 1000 }
        max_lines = false,
        floats = false,
        throttle_ms = 100,
        unit = "screenline", -- 閉じた折りたたみを考慮する（v1の folds 相当）
        hide_on_cursor = true, -- true | flase | "row"
        hide_if_all_visible = false,
        mouse = true,
        thumb = {
          text = " ",
          blend = 0,
          highlight = { bg = palette.ui.special }, -- #32526c
          hide_if_all_visible = true,
        },
      },
    })
  end,
}
