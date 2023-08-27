local noice_ok, noice = pcall(require, "noice")
if not noice_ok then
  return
end

vim.opt.cmdheight = 0

require("notify").setup({
  background_colour = "#000000",
})

noice.setup ({
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
    lsp_doc_border = false,
  },
  views = {
    notify = {
      win_options = {
        winblend = 0,
      }
    },
    cmdline = {
      win_options = {
        winblend = 0,
      }
    },
    cmdline_popup = {
      win_options = {
        winblend = 0,
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
        width = "100",
        height = "10",
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

vim.keymap.set("n", "<leader>nl", function() require("noice").cmd("last") end)
vim.keymap.set("n", "<leader>nh", "<cmd>Noice telescope<CR>")
