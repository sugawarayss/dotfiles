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
    keys = {
      {
        ";son",
        "<Cmd>Obsidian quick_switch<CR>",
        mode = "n",
        { noremap = true, silent = true },
        desc = "Obsidianノートを検索",
      },
      {
        "<Leader>nn",
        "<Cmd>Obsidian new_from_template<CR>",
        mode = "n",
        { noremap = true, silent = true },
        desc = "Obsidianノートを開く(作成)",
      },
      {
        "<Leader>dn",
        "<Cmd>Obsidian today<CR>",
        mode = "n",
        { noremap = true, silent = true },
        desc = "Obsidianデイリーノートを開く(作成)",
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    opts = {
      legacy_commands = false,
      open_notes_in = "vsplit",
      workspaces = {
        {
          name = "work",
          path = "~/PROJECTS/sugawarayss/obsidian_notes",
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
      picker = {
        name = "snacks.pick",
      },
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = "daily.md",
      },
      completion = {
        -- Set to false to disable completion
        nvim_cmp = false,
        -- Trigger completion at 2 characters
        min_chars = 2,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
    },
  },
  -- Obsidian markdownをレンダリング
  {
    "OXY2DEV/markview.nvim",
    ft = { "obsidian_markdown", "codecompanion" },
    cond = function()
      return not vim.g.vscode
    end,
    opts = {
      preview = {
        filetypes = { "obsidian_markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
}
