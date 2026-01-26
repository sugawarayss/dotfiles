-- エラーや警告を表示するプラグイン
return {
  {
    "folke/trouble.nvim",
    lazy = true,
    cmd = "Trouble",
    init = function()
      local wk = require("which-key")
      wk.add({
        {
          ";std",
          "<cmd>Trouble todo win = {size = {height=0.4}} filter = {tag = {TODO,FIX,FIXME,BUG,WARN}}<CR>",
          mode = "n",
          icon = "",
          desc = "Trouble - TODO コメント一覧を検索",
        },
        {
          ";xx",
          "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
          mode = "n",
          desc = "Trouble - バッファ内の診断結果を表示",
        },
        {
          ";xa",
          "<cmd>Trouble diagnostics toggle<CR>",
          mode = "n",
          desc = "Trouble - 全ての診断結果を表示",
        },
      })
    end,
    opts = {
      auto_close = false, -- auto close when there are no items
      auto_open = false, -- auto open when there are items
      auto_preview = true, -- automatically open preview when on an item
      auto_refresh = true, -- auto refresh when open
      auto_jump = false, -- auto jump to the item when there's only one
      focus = true, -- Focus the window when opened
      restore = true, -- restores the last location in the list when opening
      follow = true, -- Follow the current item
      indent_guides = true, -- show indent guides
      max_items = 200, -- limit number of items that can be displayed per section
      multiline = true, -- render multi-line messages
      pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
      warn_no_results = true, -- show a warning when there are no results
      open_no_results = false, -- open the trouble window when there are no results
      -- window options for the results window. Can be a split or a floating window.
      win = {},
      -- Window options for the preview window. Can be a split, floating window,
      -- or `main` to show the preview in the main editor window.
      preview = {
        type = "float",
        title = "Trouble Preview",
        title_pos = "center",
        relative = "cursor",
        border = "single",
        position = { 1, 1 },
        size = { width = 0.4, height = 0.3 },
        -- when a buffer is not yet loaded, the preview window will be created
        -- in a scratch buffer with only syntax highlighting enabled.
        -- Set to false, if you want the preview to always be a real loaded buffer.
        scratch = true,
      },
      throttle = {
        refresh = 20, -- fetches new data when needed
        update = 10, -- updates the window
        render = 10, -- renders the window
        follow = 100, -- follows the current item
        preview = { ms = 100, debounce = true }, -- shows the preview for the current item
      },
      modes = {
        -- sources define their own modes, which you can use directly,
        -- or override like in the example below
        lsp_references = {
          -- some modes are configurable, see the source code for more details
          params = {
            include_declaration = true,
          },
        },
        -- The LSP base mode for:
        -- * lsp_definitions, lsp_references, lsp_implementations
        -- * lsp_type_definitions, lsp_declarations, lsp_command
        lsp_base = {
          params = {
            -- don't include the current location in the results
            include_current = false,
          },
        },
        -- more advanced example that extends the lsp_document_symbols
        symbols = {
          desc = "document symbols",
          mode = "lsp_document_symbols",
          focus = false,
          win = { position = "right" },
          filter = {
            -- remove Package since luals uses it for control flow structures
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { "help", "markdown" },
              -- default set of symbol kinds
              kind = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
              },
            },
          },
        },
      },
    },
  },
}
