-- ステータスバーに色付けして表示するプラグイン
if not vim.g.vscode then
  return {
    "nvim-lualine/lualine.nvim",
    version = "*",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "pnx/lualine-lsp-status" },
    },
    event = { "VimEnter" },
    config = function()
      local lint_progress = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "󰦕"
        end
        return "󱉶 " .. table.concat(linters, ", ")
      end
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "ayu_mirage",
          --component_separators = { left = "", right = ""},
          --section_separators = { left = "", right = ""},
          disabled_filetypes = {
            statusline = {},
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
          lualine_b = {
            { "filename", path = 1 },
            "diagnostics",
          },
          lualine_c = { "branch", "diff" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "lsp-status", { lint_progress }, "location", "progress" },
          lualine_z = {
              { "datetime", style = "%Y/%m/%d %H:%M:%S" },
          },
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
        extensions = { "neo-tree", "aerial", "toggleterm", "mason", "lazy" },
        })
      end,
	}
else
	print("LuaLine is disabled in VSCode mode")
	return {}
end
