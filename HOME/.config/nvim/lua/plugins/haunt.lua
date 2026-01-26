-- 注釈付きのbookmarkを作成できる
return {
  "TheNoeTrevino/haunt.nvim",
  enabled = true,
  event = { "BufReadPre" },
  opts = {
    sign = "󱙝",
    sign_hl = "DiagnosticInfo",
    virt_text_hl = "HauntAnnotation",
    annotation_prefix = " 󰆉 ",
    line_hl = nil,
    virt_text_pos = "eol",
    data_dir = nil,
    picker_keys = {
      delete = { key = "d", mode = { "n" } },
      edit_annotation = { key = "a", mode = { "n" } },
    },
  },
  init = function()
    local haunt = require("haunt.api")
    local haunt_picker = require("haunt.picker")
    -- local map = vim.keymap.set
    local prefix = "<leader>m"
    local wk = require("which-key")
    wk.add({
      {
        prefix .. "a",
        function()
          haunt.annotate()
        end,
        mode = "n",
        icon = "👻",
        desc = "Haunt - Bookmarkを追加",
      },
      {
        prefix .. "t",
        function()
          haunt.toggle_annotation()
        end,
        mode = "n",
        desc = "Haunt - Bookmarkの注釈をGhostText表示をトグル",
      },
      -- {
      --   prefix .. "T",
      --   function()
      --     haunt.toggle_all_lines()
      --   end,
      --   mode = "n",
      --   icon = "👻",
      --   desc = "Haunt - Toggle all annotations",
      -- },
      {
        prefix .. "d",
        function()
          haunt.delete()
        end,
        mode = "n",
        icon = "👻",
        desc = "Haunt - Bookmarkを削除",
      },
      -- {
      --   prefix .. "C",
      --   function()
      --     haunt.clear_all()
      --   end,
      --   mode = "n",
      --   icon = "👻",
      --   desc = "Haunt - Delete all Bookmarks",
      -- },
      {
        prefix .. "p",
        function()
          haunt.prev()
        end,
        mode = "n",
        icon = "👻",
        desc = "Haunt - 前のBookmarkに移動",
      },
      {
        prefix .. "n",
        function()
          haunt.next()
        end,
        mode = "n",
        icon = "👻",
        desc = "Haunt - 次のBookmarkに移動",
      },
      {
        prefix .. "l",
        function()
          haunt_picker.show()
        end,
        mode = "n",
        icon = "👻",
        desc = "Haunt - Bookmarkリストを表示(Snacks)",
      },
      -- {
      --   prefix .. "q",
      --   function()
      --     haunt.to_quickfix()
      --   end,
      --   mode = "n",
      --   icon = "👻",
      --   desc = "Haunt - Bookmarkをquickfixで表示",
      -- },
      -- {
      --   prefix .. "Q",
      --   function()
      --     haunt.to_quickfix({ current_buffer = true })
      --   end,
      --   mode = "n",
      --   icon = "👻",
      --   desc = "Haunt - 現在のバッファのBookmarkをquickfixで表示",
      -- },
      -- {
      --   prefix .. "y",
      --   function()
      --     haunt.yank_locations({ current_buffer = true })
      --   end,
      --   mode = "n",
      --   icon = "👻",
      --   desc = "Haunt - Show Picker",
      -- },
      -- {
      --   prefix .. "Y",
      --   function()
      --     haunt.yank_locations()
      --   end,
      --   mode = "n",
      --   icon = "👻",
      --   desc = "Haunt - Show Picker",
      -- },
    })
  end,
}
