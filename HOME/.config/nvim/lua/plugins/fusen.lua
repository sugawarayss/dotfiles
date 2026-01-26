-- Git Branch ごとにメモを残せる Neovim プラグイン
return {
  "walkersumida/fusen.nvim",
  enabled = false,
  version = "*",
  event = "VimEnter",
  cond = function()
    return not vim.g.vscode
  end,
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        ";sbm",
        function()
          local fusen = require("fusen")
          local has_snacks, _ = pcall(require, "snacks.picker")
          if not has_snacks then
            fusen.list_marks()
            return
          end
          local fusen_marks = require("fusen.marks")
          local all_marks = fusen_marks.get_marks()
          local qf_items = {}
          for _, mark in ipairs(all_marks) do
            local text = ""
            if mark.annotation ~= "" then
              text = mark.annotation
            end

            if text == "" then
              text = "Mark at line " .. mark.line
            end

            table.insert(qf_items, {
              filename = mark.file,
              lnum = mark.line,
              col = 1,
              text = text,
              type = "I",
            })
          end
          table.sort(qf_items, function(a, b)
            if a.filename == b.filename then
              return a.lnum < b.lnum
            end
            return a.filename < b.filename
          end)
          vim.fn.setqflist(qf_items, "r")
          vim.fn.setqflist({}, "a", { title = "Fusen Marks" })
          -- Snacks Pickerで開く
          Snacks.picker.qflist()
        end,
        icon = "🪧",
        mode = "n",
        desc = "Fusen - リストをqflistで表示(Snacks Picker)",
      },
    })
  end,
  opts = {
    -- ~/.local/share/nvim/fusen_marks.json
    save_file = vim.fn.stdpath("data") .. "/fusen_marks.json",
    -- Mark Appearance
    mark = {
      icon = "󰎞",
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
    local color_palette = require("onedarkpro.helpers").get_colors()
    require("fusen").setup(opts)
    vim.api.nvim_set_hl(0, "FusenMarkCustom", {
      fg = color_palette.purple,
      bold = false,
    })
  end,
}
