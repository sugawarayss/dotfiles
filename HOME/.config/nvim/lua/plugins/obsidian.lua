vim.opt.conceallevel = 1
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  keys = {
    { "<Leader>os", "<Cmd>ObsidianQuickSwitch<CR>", mode = "n", { noremap = true, silent = true }, desc = "Obsidianノートを検索" },
    { "<Leader>on", "<Cmd>ObsidianNew<CR>", mode = "n", { noremap = true, silent = true }, desc = "Obsidianノートを開く(作成)" },
    { "<Leader>od", "<Cmd>ObsidianToday<CR>", mode = "n", { noremap = true, silent = true }, desc = "デイリーノートを開く(作成)" },
    { "<Leader>oc", "<Cmd>ObsidianTOC<CR>", mode = "n", { noremap = true, silent = true }, desc = "現在のノートの目次を表示" },
    { "<Leader>otc", "<Cmd>ObsidianToggleCheckbox<CR>", mode = "n", {noremap = true, silent = true }, desc = "チェックボックスをトグル" },
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
