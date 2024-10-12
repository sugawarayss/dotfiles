-- Cmdlineの色設定
local color_palette = require("tokyonight.colors").setup()

local noice_cmd_types = {
  CmdLine = color_palette.blue0,     -- #3d59a1
  Input = color_palette.fg_dark,     -- #a9b1d6
  Lua = color_palette.purple,        -- #9d7cd8
  Filter = color_palette.green2,     -- #41a6b5
  Rename = color_palette.orange,     -- #ff9e64
  Search =  color_palette. yellow,   -- #e0af68
  Substitute = color_palette.teal,   -- #1abc9c
  Help = color_palette.comment,      -- #565f89
}

-- CmdLineや通知をpopupで表示するプラグイン
return {
  "folke/noice.nvim",
  event = { "VeryLazy" },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>nl", function() require("noice").cmd("last") end, mode = "n", desc = "Show Last Notification" },
    { "<leader>nh", "<cmd>Noice telescope<CR>", mode = "n", desc = "Show Notification History by Telescope" },
  },
  config = function()
    vim.opt.cmdheight = 0
    require("notify").setup({
      background_colour = color_palette.bg_dark,
    })

    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {},
        format = {
          cmdline = { pattern = '^:', icon = ' ', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = true,
        backend = "cmp",
        kind_icons = {},
      },
      redirect = {
        view = "popup",
        filter = { event = "msg_show" },
      },
      commands = {
        history = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "" } },
              { event = "lsp", kind = "message" },
            },
          },
        },
        last = {
          view = "popup",
          opts = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "" } },
              { event = "lsp", kind = "message" },
            },
          },
          filter_opts = { count = 1 },
        },
        errors = {
          view = "popup",
          opts = { enter = true, format = "details" },
          filter = { error = true },
          filter_opts = { reverse = true },
        },
        all = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30,
          view = "mini",
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
          ['vim.lsp.util.stylize_markdown'] = false,
          ['cmp.entry.get_documentation'] = true,
        },
        hover = {
          enabled = true,
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
          view = nil,
          opts = {},
        },
        message = {
          enabled = true,
          view = "notify",
          opts = {},
        },
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      markdown = {
        hover = {
          ["|(%S-)|"] = vim.cmd.help, -- vim help links
          ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
        },
        highlights = {
          ["|%S-|"] = "@text.reference",
          ["@%S+"] = "@parameter",
          ["^%s*(Parameters:)"] = "@text.title",
          ["^%s*(Return:)"] = "@text.title",
          ["^%s*(See also:)"] = "@text.title",
          ["{%S-}"] = "@parameter",
        },
      },
      health = {
        checker = true,
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = true,
      },
      throttle = 1000 / 30,
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
            row = "50%",
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
      routes = {},
      status = {},
      format = {},
    })

    vim.api.nvim_set_hl(0, "NoicePopupBorder", {bg=color_palette.bg_dark})
    for type, color in pairs(noice_cmd_types) do
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, {bg=color_palette.bg_dark, fg=color})
    end
  end
}
