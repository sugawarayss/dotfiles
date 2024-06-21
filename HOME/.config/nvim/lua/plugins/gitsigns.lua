-- inlineにgitblame等を表示するプラグイン
return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "BufReadPre" },
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require("gitsigns").setup({
      signs                        = {
        add          = { text = '┃'},
        change       = { text = '┃'},
        delete       = { text = '_'},
        topdelete    = { text = '‾'},
        changedelete = { text = '~'},
        untracked    = { text = '󰇙'},
      },
      signcolumn                   = true, -- サインを行番号のある列に表示する `:Gitsigns toggle_signs`
      numhl                        = false, --  行番号をハイライトする         `Gitsigns toggle_numhl`
      linehl                       = false, --  バッファ本文のハイライトを行単位で変更する `Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        interval = 1000,
        follow_files = true
      },
      auto_attach = true,
      attach_to_untracked          = true,
      current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil, -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'editor',
        row = 0,
        col = 1,
      },
      on_attach                    = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage All Hunks in Current Buffer"})
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo the Last call of stage_hunk" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset the lines of All Hunks in the Buffer"})
        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview the Hunk at the Cursor Position in Float Window"})
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Float Blame Line"})
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle Blame Line"})
        map('n', '<leader>hd', gs.diffthis, { desc = "Toggle Diff" })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Toggle Diff with HEAD"})
        map('n', '<leader>td', gs.toggle_deleted, { desc = "Toggle Show Deleted"})

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    })
  end
}
