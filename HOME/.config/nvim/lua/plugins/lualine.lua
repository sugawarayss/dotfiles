require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = "tokyonight",
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {'filename', path = 4},
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {},
    lualine_z = {'location', 'progress'}
  },
  inactive_sections = {
    lualine_a = {
      {
        'filename',
        path = 4,
      },
    },
    lualine_b = {
    },
    lualine_c = {
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {'buffers',use_mode_colors = true},
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'searchcount'},
    lualine_z = {
      {'datetime', style="%Y/%m/%d %H:%M:%S"},
    }
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {'fern', 'aerial', 'toggleterm'}
}
