-- Git Branch ごとにメモを残せる Neovim プラグイン
return {
  "walkersumida/fusen.nvim",
  version = "*",
  event = "VimEnter",
  init = function()
    local wk = require("which-key")
    -- local has_snacks, snacks_picker = pcall(require, "snacks.picker")
    wk.add({
      { ";sbm", ":FusenList<CR>", mode = "n", desc = "Fusenのリストをqflistで表示" },
    })
  end,
  opts = {
    -- ~/.local/share/nvim/fusen_marks.json
    save_file = vim.fn.stdpath("data") .. "/fusen_marks.json",
    -- Mark Appearance
    mark = {
      icon = "📝",
      hl_group = "FusenMarkCustom",
    },
    -- Key mappings
    keymaps = {
      add_mark = "me", -- Add/edit sticky note
      clear_mark = "mc", -- Clear mark at current line
      clear_buffer = "mC", -- Clear all marks in buffer
      clear_all = "mD", -- Clear ALL marks (deletes entire JSON content)
      next_mark = "mn", -- Jump to next mark
      prev_mark = "mp", -- Jump to previous mark
      list_marks = "ml", -- Show marks in quickfix
    },
    -- Sign Column Priority
    sign_priority = 10,

    -- Annotation Display Settings
    annotation_display = {
      -- "eol" | "float" | "both" | "none"
      mode = "float",
      -- Number of Spaces Before Annotation in eol mode
      spacing = 2,
      -- Float Window Settings
      float = {
        delay = 100,
        border = "rounded",
        max_width = 50,
        max_height = 10,
      },
    },
    exclude_filetypes = {
      "snacks_picker_list",
    },
    -- Plugin Enabled State
    enabled = true,
  },
  config = function(_, opts)
    local color_palette = require("onedark.colors")
    require("fusen").setup(opts)
    vim.api.nvim_set_hl(0, "FusenMarkCustom", {
      fg = color_palette.bg_yellow,
      bold = false,
    })
  end,
}
