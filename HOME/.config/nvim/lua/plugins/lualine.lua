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
      local palette = require("kanagawa.colors").setup().theme
      -- Linter実行の進捗を表示
      local lint_progress = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "󰫹󰫶󰫻󰬁 -"
        end
        return "󰫹󰫶󰫻󰬁 " .. table.concat(linters, ", ")
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
          theme = "kanagawa",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "sagaoutline", "dbui" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          -- :set laststatus=3 の状態(グローバルステータス)にするか
          globalstatus = true,
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
              color = { fg = palette.diag.error },
            },
            "branch",
          },
          lualine_y = {
            -- Language Server の起動状況
            { "lsp-status", icons = { active = "󰫹󰬀󰫽", inactive = "󰫹󰬀󰫽" } },
            -- MCPサーバの起動状況
            {
              function()
                local prefix = "📚"
                if not vim.g.loaded_mcphub then
                  return prefix .. "(-)"
                end
                local count = vim.g.mcphub_servers_count or 0
                local status = vim.g.mcphub_status or "stopped"
                local executing = vim.g.mcphub_executing
                -- Show "-" when stopped
                if status == "stopped" then
                  return prefix .. "(-)"
                end
                -- Show spinner when executing, starting, or restarting
                if executing or status == "starting" or status == "restarting" then
                  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                  -- local frames = { "", "", "", "", "", "" }
                  local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                  return prefix .. "(" .. frames[frame] .. ")"
                end
                return prefix .. "(" .. count .. ")"
              end,
              color = function()
                if not vim.g.loaded_mcphub then
                  return { fg = palette.fg } -- #abb2bf
                end

                local status = vim.g.mcphub_status or "stopped"
                if status == "ready" or status == "restarted" then
                  return { fg = palette.syn.string } -- #89ca78
                elseif status == "starting" or status == "restarting" then
                  return { fg = palette.syn.identifier } -- #e5c07b
                else
                  return { fg = palette.syn.special3 } -- #ef596f
                end
              end,
            },
            -- Linter実行の進捗を表示
            lint_progress,
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
  { "pnx/lualine-lsp-status", lazy = true },
}
