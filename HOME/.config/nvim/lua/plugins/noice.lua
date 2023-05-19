vim.opt.cmdheight = 0

require('noice').setup {
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
      inc_rename = false,
      lsp_doc_border = false,
    },
    views = {
      cmdline_popup = {
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
}

vim.keymap.set("n", "<leader>nl", function() require("noice").cmd("last")  end)
vim.keymap.set("n", "<leader>nh", "<cmd>Noice telescope<CR>")
