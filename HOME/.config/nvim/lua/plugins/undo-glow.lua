-- ヤンクやUndo箇所をハイライトするプラグイン
local color_palette = require("onedarkpro.helpers").get_colors()
return {
  "y3owk1n/undo-glow.nvim",
  event = { "VeryLazy" },
  opts = {
    animation = {
      enabled = true,
      duration = 500,
      animation_type = "fade",
      window_scoped = true,
    },
    highlights = {
      undo = {
        hl_color = { bg = color_palette.git_hunk_delete },
      },
      redo = {
        hl_color = { bg = color_palette.virtual_text_error },
      },
      yank = {
        hl_color = { bg = color_palette.virtual_text_hint },
      },
      paste = {
        hl_color = { bg = color_palette.cyan },
      },
      search = {
        hl_color = { bg = color_palette.git_change },
      },
      comment = {
        hl_color = { bg = color_palette.cursorline },
      },
      cursor = {
        hl_color = { bg = color_palette.blue },
      },
    },
    priority = 2048 * 3,
  },
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "u",
        function()
          require("undo-glow").undo()
        end,
        mode = "n",
        desc = "UndoGlow - Undo with highlight",
      },
      {
        "U",
        function()
          require("undo-glow").redo()
        end,
        mode = "n",
        desc = "UndoGlow - Redo with highlight",
      },
      {
        "p",
        function()
          require("undo-glow").paste_below()
        end,
        mode = "n",
        desc = "UndoGlow - Paste below with highlight",
      },
      {
        "P",
        function()
          require("undo-glow").paste_above()
        end,
        mode = "n",
        desc = "UndoGlow - Paste above with highlight",
      },
    })
    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight when yanking (copying) text",
      callback = function()
        require("undo-glow").yank()
      end,
    })

    -- This only handles neovim instance and do not highlight when switching panes in tmux
    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "Highlight when cursor moved significantly",
      callback = function()
        require("undo-glow").cursor_moved({
          animation = {
            animation_type = "slide",
          },
        })
      end,
    })

    -- This will handle highlights when focus gained, including switching panes in tmux
    vim.api.nvim_create_autocmd("FocusGained", {
      desc = "Highlight when focus gained",
      callback = function()
        local opts = {
          animation = {
            animation_type = "slide",
          },
        }

        opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
        local pos = require("undo-glow.utils").get_current_cursor_row()

        require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
          s_row = pos.s_row,
          s_col = pos.s_col,
          e_row = pos.e_row,
          e_col = pos.e_col,
          force_edge = opts.force_edge == nil and true or opts.force_edge,
        }))
      end,
    })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      desc = "Highlight when search cmdline leave",
      callback = function()
        require("undo-glow").search_cmd({
          animation = {
            animation_type = "fade",
          },
        })
      end,
    })
  end,
}
