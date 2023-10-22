-- Cmdlineの色設定
local noice_cmd_types = {
  CmdLine = "#94E2F5",
  Input = "#CDD6F4",
  Lua = "#CBA6F7",
  Filter = "#F9E2AF",
  Rename = "#89B4FA",
  Search = "#F9E2AF",
  Substitute = "#FAB387",
  Help = "#A6E3A1",
}

-- CmdLineや通知をpopupで表示
return {
  "folke/noice.nvim",
  lazy = true,
  event = { "VimEnter" },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<leader>nl", function() require("noice").cmd("last") end, mode = "n", desc = "Show Last Notification" },
    { "<leader>nh", "<cmd>Noice telescope<CR>", mode = "n", desc = "Show Notification History by Telescope" },
  },
  config = function()
    local mocha = require("catppuccin.palettes").get_palette "mocha"
    vim.opt.cmdheight = 0
    require("notify").setup({
      background_colour = mocha.crust or "#1E1E2D",
    })

    require("noice").setup({
      cmdline = {
        format = {
          cmdline = { pattern = '^:', icon = ' ', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
        },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = true,
      },
      views = {
        notify = {
          win_options = {
            winblend = 10,
          }
        },
        cmdline = {
          win_options = {
            winblend = 10,
          }
        },
        cmdline_popup = {
          win_options = {
            winblend = 10,
          },
          position = {
            row = "30",
            col = "50%",
          },
          size = {
            width = "100",
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = "33",
            col = "50%",
          },
          size = {
            width = "100", height = "10",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winblend = 0,
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo",
            },
          },
        },
      },
    })


    for type, color in pairs(noice_cmd_types) do
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, {bg="#313244", fg=color})
    end
  end
}
