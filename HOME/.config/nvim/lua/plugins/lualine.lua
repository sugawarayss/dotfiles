-- ステータスバーに色付けして表示するプラグイン
return {
  {
    "nvim-lualine/lualine.nvim",
    version = "*",
    event = { "BufReadPre" },
    cond = function()
      return not vim.g.vscode
    end,
    config = function()
      local color_palette = require("onedark.colors")
      -- Linter実行の進捗を表示
      local lint_progress = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "󱔢 -"
        end
        return "󰦖 " .. table.concat(linters, ", ")
      end
      -- Snacks Terminal 表示時の設定
      local snacks_terminal = {
        sections = { lualine_a = { "mode" }, lualine_z = { { "datetime", style = "%Y/%m/%d %H:%M:%S" } } },
        filetypes = { "snacks_terminal" },
      }
      -- マクロ記録中の表示内容の定義
      local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
          return "󰑋 MACRO RECORDING TO (" .. reg .. ")"
        end
        return ""
      end
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "onedark",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "sagaoutline", "dbui" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          -- :set laststatus=3 の状態(グローバルステータス)にするか
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "filename", path = 1 }, "diagnostics" },
          lualine_c = { "location" },
          -- CodeCompanion の進捗を lualine で表示する場合
          lualine_x = {
            -- マクロの記録中の表示
            {
              macro_recording,
              color = { fg = color_palette.orange }, -- #c99a6e
            },
            "branch",
          },
          lualine_y = {
            -- Linter実行の進捗を表示
            lint_progress,
            -- Language Server の起動状況
            "lsp-status",
            -- MCPサーバの起動状況
            {
              function()
                if not vim.g.loaded_mcphub then
                  return " (-)"
                end
                local count = vim.g.mcphub_servers_count or 0
                local status = vim.g.mcphub_status or "stopped"
                local executing = vim.g.mcphub_executing
                -- Show "-" when stopped
                if status == "stopped" then
                  return " (-)"
                end
                -- Show spinner when executing, starting, or restarting
                if executing or status == "starting" or status == "restarting" then
                  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                  -- local frames = { "", "", "", "", "", "" }
                  local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                  return " (" .. frames[frame] .. ")"
                end
                return " (" .. count .. ")"
              end,
              color = function()
                if not vim.g.loaded_mcphub then
                  return { fg = color_palette.fg } -- #a7aab0
                end

                local status = vim.g.mcphub_status or "stopped"
                if status == "ready" or status == "restarted" then
                  return { fg = color_palette.green } -- #99bc80
                elseif status == "starting" or status == "restarting" then
                  return { fg = color_palette.yellow } -- #dfbe81
                else
                  return { fg = color_palette.red } -- #e16d77
                end
              end,
            },
          },
          lualine_z = {
            "encoding",
            "fileformat",
            "filetype",
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
        extensions = { "neo-tree", "mason", "lazy", "nvim-dap-ui", "quickfix", snacks_terminal },
      })
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "pnx/lualine-lsp-status",
    lazy = true,
    opts = {
      show_count = true,
      colored = true,
      disabled_filetypes = {},
      icons = {
        active = "",
        inactive = "",
      },
    },
  },
}
