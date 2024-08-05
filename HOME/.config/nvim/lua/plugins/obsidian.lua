vim.opt.conceallevel = 1
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  keys = {
    { "<Leader>os", "<Cmd>ObsidianQuickSwitch<CR>", mode = "n", { noremap = true, silent = true }, desc = "Search Note"},
    { "<Leader>on", "<Cmd>ObsidianNew<CR>", mode = "n", { noremap = true, silent = true }, desc = "Create/Open New Note"},
    { "<Leader>od", "<Cmd>ObsidianToday<CR>", mode = "n", { noremap = true, silent = true }, desc = "Create/Open Today's Note"},
    { "<Leader>oc", "<Cmd>ObsidianTOC<CR>", mode = "n", { noremap = true, silent = true }, desc = "Load Table Of Contents of Current Note" },
    { "<Leader>otc", "<Cmd>ObsidianToggleCheckbox<CR>", mode = "n", {noremap = true, silent = true }, desc = "Cycle Through CheckBox Options" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    open_notes_in = "vsplit",
    workspaces = {
      {
        name = "work",
        path = "~/PROJECTS/sugawarayss/obsidian_notes"
      },
    },
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
    daily_notes = {
      folder = "daily",
      template = "daily.md"
    },
    completion = {
      -- Set to false to disable completion
      nvim_cmp = true,
      -- Trigger completion at 2 characters
      min_chars = 2,
    },
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
  },
}
