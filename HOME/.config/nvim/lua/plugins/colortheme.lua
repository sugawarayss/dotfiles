-- カラーテーマ
return {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedarkpro").setup({
      -- Override default colors or create your own
      colors = {},
      -- Override default highlight  groups or create your own
      highlights = {},
      styles = {
        types = "NONE",
        methods = "NONE",
        numbers = "NONE",
        strings = "NONE",
        comments = "NONE",
        keywords = "NONE",
        constants = "NONE",
        functions = "NONE",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "NONE",
        virtual_text = "NONE",
      },
      -- Override which filetype highlight groups are loaded
      filetypes = {
        c = true,
        comment = true,
        go = true,
        html = true,
        java = true,
        javascript = true,
        json = true,
        latex = true,
        lua = true,
        markdown = true,
        php = true,
        python = true,
        ruby = true,
        rust = true,
        scss = true,
        toml = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        xml = true,
        yaml = true,
      },
      -- Override which plugin highlight groups are loaded
      plugins = {
        aerial = true,
        barbar = true,
        blink_cmp = true,
        blink_indent = true,
        blink_pairs = true,
        codecompanion = true,
        copilot = true,
        csvview = true,
        dashboard = true,
        flash_nvim = true,
        gitgraph_nvim = true,
        gitsigns = true,
        hop = true,
        indentline = true,
        leap = true,
        lsp_saga = true,
        lsp_semantic_tokens = true,
        marks = true,
        mason = true,
        mini_diff = true,
        mini_icons = true,
        mini_indentscope = true,
        mini_test = true,
        neotest = true,
        neo_tree = true,
        nvim_cmp = true,
        nvim_bqf = true,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_hlslens = true,
        nvim_lsp = true,
        nvim_navic = true,
        nvim_notify = true,
        nvim_tree = true,
        nvim_ts_rainbow = true,
        nvim_ts_rainbow2 = true,
        op_nvim = true,
        packer = true,
        persisted = true,
        polygot = true,
        rainbow_delimiters = true,
        render_markdown = true,
        snacks = true,
        startify = true,
        telescope = false,
        toggleterm = false,
        treesitter = true,
        trouble = true,
        vim_ultest = true,
        which_key = true,
        vim_dadbod_ui = true,
      },
      options = {
        -- Use cursorline highlighting
        cursorline = false,
        -- Use a trransparent background?
        transparency = true,
        -- Use the  theme's colors for Neovim's :terminal?
        terminal_colors = true,
        -- Center bar transparency?
        lualine_transparency = false,
        -- When the window is out of focus, change the normal background
        highlight_inactive_windows = true,
      },
    })
    vim.cmd("colorscheme onedark_dark")
    -- virtual_text_error       = "#f38495"
    -- red                      = "#ef596f"
    -- git_delete               = "#9a353d"
    -- git_hunk_delete_inline   = "#6f2e2d"
    -- DIFF_DELETE              = "#501B20"
    -- git_hunk_delete          = "#502d30"
    -- virtual_text_warning     = "#edd2a1"
    -- yellow                   = "#e5c07b"
    -- highlight                = "#e2be7d"
    -- orange                   = "#d19a66"
    -- git_change               = "#948B60"
    -- green                    = "#89ca78"
    -- virtual_text_hint        = "#4fcfd8"
    -- cyan                     = "#2bbac5"
    -- git_add                  = "#109868"
    -- diff_text                = "#005869"
    -- diff_add                 = "#003e4a"
    -- diff_change              = "#1f4662"
    -- git_hunk_add_inline      = "#3f534f"
    -- git_hunk_add             = "#43554d"
    -- virtual_text_information = "#90c7f4"
    -- blue                     = "#61afef"
    -- purple                   = "#d55fde"
    -- white                    = "#abb2bf"
    -- fg                       = "#abb2bf"
    -- fg_gutter_inactive       = "#abb2bf"
    -- comment                  = "#7f848e"
    -- line_number              = "#495162"
    -- gray                     = "#434852"
    -- inlay_hint               = "#33373e"
    -- git_hunk_change_inline   = "#41483d"
    -- selection                = "#212121"
    -- fg_gutter                = "#181818"
    -- indentline               = "#1f1f1f"
    -- color_column             = "#161616"
    -- cursorline               = "#171717"
    -- bg_statusline            = "#0e0e0e"
    -- fold                     = "#121212"
    -- bg                       = "#000000"
    -- black                    = "#000000"
    -- float_bg                 = "#000000"
  end,
}
