return {
  {
    "yousefhadder/markdown-plus.nvim",
    ft = { "markdown" },
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      local wk = require("which-key")
      -- see `:help markdown-plus-plug-mappings`
      wk.add({
        {
          "<localleader>mtc",
          "<Plug>(MarkdownPlusTableCreate)",
          icon = "📑",
          mode = "n",
          desc = "MD+ - MDテーブルを新規作成",
        },
        {
          "<localleader>mir",
          "<Plug>(MarkdownPlusTableInsertRowBelow)",
          icon = "📑",
          mode = "n",
          desc = "MD+ - MDテーブルに行追加",
        },
        {
          "<localleader>mic",
          "<Plug>(MarkdownPlusTableInsertColumnRight)",
          icon = "📑",
          mode = "n",
          desc = "MD+ - MDテーブルに列追加",
        },
        {
          "<localleader>mlt",
          "<Plug>(MarkdownPlusToggleCheckbox)",
          icon = "📑",
          mode = "n",
          desc = "MD+ - チェックボックスをトグル",
        },
      })
    end,
    config = function()
      require("markdown-plus").setup({
        -- Global enable/disable
        enabled = true, -- default: true

        -- Feature toggles (all default: true)
        features = {
          list_management = true, -- default: true (list auto-continue / indent / renumber / checkboxes)
          text_formatting = true, -- default: true (bold/italic/strike/code + clear)
          headers_toc = true, -- default: true (headers nav + TOC generation & window)
          links = true, -- default: true (insert/edit/convert/reference links)
          images = true, -- default: true (insert/edit image links + toggle link/image)
          quotes = true, -- default: true (blockquote toggle)
          callouts = true, -- default: true (GFM callouts/admonitions)
          code_block = true, -- default: true (visual selection -> fenced block)
          table = true, -- default: true (table creation & editing)
          footnotes = true, -- default: true (footnote insertion/navigation/listing)
        },
        -- Filetypes configuration
        filetypes = { "markdown", "codecompanion" }, -- default: { "markdown" }

        -- Global keymap configuration
        keymaps = {
          enabled = false, -- default: true  set false to disable ALL default maps (use <Plug>)
        },

        -- TOC window configuration
        toc = {
          initial_depth = 2, -- default: 2 (range 1-6) depth shown in :Toc window and generated TOC
        },

        -- Thematic_break configuration
        thematic_break = {
          style = "---",
        },

        -- Callouts configuration
        callouts = {
          default_type = "NOTE", -- default: "NOTE"  default callout type when inserting
          custom_types = { "INFO", "WARNING", "DANGER" }, -- default: {}  add custom types (e.g., { "DANGER", "SUCCESS" })
        },

        -- CodeBlock configuration
        code_block = {
          enabled = true,
          fence_style = "backtick", -- "backtick"|"tilde"
          languages = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "toml", "markdown", "go", "rust" },
        },
        -- Table configuration
        table = {
          auto_format = true, -- default: true  auto format table after operations
          default_alignment = "left", -- default: "left"  alignment used for new columns
          confirm_destructive = true, -- default: true  confirm before transpose/sort operations
          keymaps = { -- Table-specific keymaps (prefix based)
            enabled = true, -- default: true  provide table keymaps
            prefix = "<localleader>t", -- default: "<leader>t"  prefix for table ops
            insert_mode_navigation = true, -- default: true  Alt+hjkl cell navigation
          },
        },
        -- Footnotes configuration
        footnotes = {
          section_header = "Footnotes", -- default: "Footnotes"  header for footnotes section
          confirm_delete = true, -- default: true  confirm before deleting footnotes
        },
        -- Lists configuration
        list = {
          smart_outdent = true,
          checkbox_completion = {
            enabled = true,
            format = "emoji", -- "emoji"|"comment"|"dataview"|"parentheical"
            date_format = "%Y-%m-%d",
            remove_on_uncheck = true,
            update_existing = true,
          },
        },
        -- Link configuration
        links = {
          smart_paste = {
            enabled = true,
            timeout = 5, -- 1..30
          },
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
}
