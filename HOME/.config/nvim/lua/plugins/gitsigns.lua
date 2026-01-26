-- inlineにgitblame等を表示するプラグイン
return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "BufReadPre" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "┃" },
        change = { text = "" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged_enable = true,
      signcolumn = true, -- サインを行番号のある列に表示する `:Gitsigns toggle_signs`
      numhl = false, --  行番号をハイライトする         `Gitsigns toggle_numhl`
      linehl = false, --  バッファ本文のハイライトを行単位で変更する `Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- "eol" | "overlay" | "right_align"
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(_)
        local gs = require("gitsigns")
        local wk = require("which-key")
        wk.add({
          {
            "<leader>gj",
            function()
              if vim.wo.diff then
                return ""
              end
              vim.schedule(function()
                gs.next_hunk()
              end)
              return "<Ignore>"
            end,
            mode = "n",
            icon = "",
            desc = "Gitsings - 次のHunkに移動",
          },
          {
            "<leader>gk",
            function()
              if vim.wo.diff then
                return ""
              end
              vim.schedule(function()
                gs.prev_hunk()
              end)
              return "<Ignore>"
            end,
            mode = "n",
            icon = "",
            desc = "Gitsings - 前のHunkに移動",
          },
          {
            "<leader>gl",
            ":Gitsigns setloclist<CR>",
            mode = "n",
            icon = "",
            desc = "Gitsings - 変更箇所をロケーションリストで表示する",
          },
          {
            "<leader>gp",
            "Gitsigns preview_hunk_inline<CR>",
            mode = "n",
            icon = "",
            desc = "Gitsings - カーソル位置の変更内容を(インラインで)プレビューする",
          },
          {
            "<leader>gh",
            ":<C-U>Gitsigns select_hunk<CR>",
            mode = "n",
            icon = "",
            desc = "Gitsings - HEADとのdiff表示をトグル",
          },
        })
      end,
    })
    require("scrollbar.handlers.gitsigns").setup()
  end,
}
