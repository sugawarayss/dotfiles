-- ステータスバーに色付けして表示するプラグイン
return {
  "nvim-lualine/lualine.nvim",
  version = "*",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  event = { "VimEnter" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        --component_separators = { left = '', right = ''},
        --section_separators = { left = '', right = ''},
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
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          { 'filename', path = 4 },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'location', 'progress' },
        lualine_z = {
          { 'datetime', style = "%Y/%m/%d %H:%M:%S" }
        }
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
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'fern', 'aerial', 'toggleterm' }
    })
  end
}
