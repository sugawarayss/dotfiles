-- vim から Obsidian を操作するプラグイン
vim.opt.conceallevel = 1
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    cmd = { "Obsidian" },
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/PROJECTS/sugawarayss/obsidian_notes/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/PROJECTS/sugawarayss/obsidian_notes/*.md",
    },
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      local wk = require("which-key")
      wk.add({
        {
          ";son",
          "<Cmd>Obsidian quick_switch<CR>",
          mode = "n",
          icon = "💎",
          desc = "Obsidian - ノートを検索",
        },
        {
          "<Leader>nn",
          "<Cmd>Obsidian new_from_template note.md<CR>",
          mode = "n",
          icon = "💎",
          desc = "Obsidian - ノートを開く(作成)",
        },
        {
          "<Leader>dn",
          "<Cmd>Obsidian today<CR>",
          mode = "n",
          icon = "💎",
          desc = "Obsidian - デイリーノートを開く(作成)",
        },
      })
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    config = function()
      require("obsidian").setup({
        legacy_commands = false,
        open_notes_in = "vsplit",
        frontmatter = {
          enabled = true,
          func = function(note)
            local out = { tags = note.tags }
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,
          sort = { "id", "aliases", "tags" },
        },
        callbacks = {
          enter_note = function(_)
            vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
              buffer = true,
              desc = "Obsidian - Toggle checkbox",
            })
          end,
        },
        workspaces = {
          {
            name = "work",
            path = "~/PROJECTS/sugawarayss/obsidian_notes",
          },
        },
        picker = {
          name = "snacks.picker",
        },
        file = {
          ignore_filters = {
            "archive",
            "private/**",
            "*.bak.md",
            "slides/present.md",
          },
        },
        search = {
          sort_by = "modified",
          sort_reversed = true,
          max_lines = 1000,
        },
        checkbox = {
          enabled = true,
          create_new = true,
          order = { " ", "~", "!", ">", "x" },
        },
        link = {
          style = "wiki",
          format = "shortest",
          auto_update = false,
        },
        note = {
          template = "note.md",
        },
        attachments = {
          folder = "Knowledge/AttachedFiles",
          img_text_func = require("obsidian.builtin").img_text_func,
          img_name_func = function()
            return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
          end,
          confirm_img_paste = true,
        },
        daily_notes = {
          folder = "DailyNotes",
          date_format = "YYYY-MM-DD",
          default_tags = { "daily" },
          template = "daily.md",
        },
        completion = {
          -- Trigger completion at 2 characters
          min_chars = 2,
        },
        templates = {
          folder = "Templates",
          date_format = "YYYY-MM-DD",
          time_format = "HH:mm",
        },
      })
    end,
  },
}
