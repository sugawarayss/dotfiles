-- ステータスバーに色付けして表示するプラグイン
if not vim.g.vscode then
  return {
    {
      "nvim-lualine/lualine.nvim",
      version = "*",
      event = { "VimEnter" },
      config = function()
        local lint_progress = function()
          local linters = require("lint").get_running()
          if #linters == 0 then
            return "󰦕"
          end
          return "󱉶 " .. table.concat(linters, ", ")
        end
        local snacks_terminal = { sections = { lualine_a = { "mode" }, lualine_z = { { "datetime", style = "%Y/%m/%d %H:%M:%S" }} }, filetypes = { "snacks_terminal" }}
        require("lualine").setup({
          options = {
            icons_enabled = true,
            theme = "OceanicNext",
            component_separators = { left = "", right = ""},
            section_separators = { left = "", right = ""},
            disabled_filetypes = {
              statusline = {"sagaoutline"},
              winbar     = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            -- :set laststatus=3 の状態(グローバルステータス)にするか
            globalstatus = false,
            refresh = {
              statusline = 100,
              tabline    = 1000,
              winbar     = 1000,
            },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { { "filename", path = 1 } },
            lualine_c = { "branch" },
            -- CodeCompanion の進捗を lualine で表示する場合
            lualine_x = { require("plugins.spinners.cc-compontnt"), "lsp-status" },
            lualine_y = { lint_progress },
            lualine_z = { "encoding", "fileformat", "filetype" },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {
                { "filename", path = 1 },
            },
            lualine_c = {
                { "diff", "diagnostics" },
            },
            lualine_x = { "location" },
              lualine_y = {},
              lualine_z = {},
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = { "neo-tree", "mason", "lazy", "nvim-dap-ui", "quickfix", snacks_terminal  },
        })
      end,
	},
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "pnx/lualine-lsp-status", lazy = true },
  }
else
	return {}
end
