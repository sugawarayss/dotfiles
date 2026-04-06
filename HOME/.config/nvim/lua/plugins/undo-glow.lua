-- ヤンクやUndo箇所をハイライトするプラグイン
return {
  "y3owk1n/undo-glow.nvim",
  event = { "VeryLazy" },
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "u",
        function()
          require("undo-glow").undo({
            animation = {
              animation_type = "fade",
            },
          })
        end,
        mode = "n",
        desc = "UndoGlow - Undo with highlight",
      },
      {
        "U",
        function()
          require("undo-glow").redo({
            animation = {
              animation_type = "fade_reverse",
            },
          })
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
        require("undo-glow").yank({
          animation = {
            animation_type = "spring",
          },
        })
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
  config = function()
    local palette = require("kanagawa.colors").setup().theme
    require("undo-glow").setup({
      animation = {
        enabled = true,
        duration = 500,
        animation_type = "fade",
        window_scoped = true,
      },
      highlights = {
        undo = {
          hl_color = { bg = palette.ui.fg_dim },
        },
        redo = {
          hl_color = { bg = palette.ui.fg_reverse },
        },
        yank = {
          hl_color = { bg = palette.ui.special },
        },
        paste = {
          hl_color = { bg = palette.syn.type },
        },
        search = {
          hl_color = { bg = palette.syn.identifier },
        },
        comment = {
          hl_color = { bg = palette.syn.parameter },
        },
        cursor = {
          hl_color = { bg = palette.syn.fun },
        },
      },
      priority = 2048 * 3,
    })
  end,
}
