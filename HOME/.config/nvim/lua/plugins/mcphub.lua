if vim.g.vscode then
  return {}
else
  return {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port = 37373, -- Default port for MCP hub
        -- config = vim.fn.expand("~/.config/mcphub/servers.json"),
        native_servers = {},
        auto_approve = true,
        auto_toggle_mcp_servers = true,
        extentions = {},
        ui = {
          window = {
            width = 0.8,
            height = 0.8,
            relative = "editor",
            zindex = 50,
            border = "rounded",
          },
          wo ={},
        },
        on_ready = function(hub)
          vim.notify("MCPHub has ready")
          -- dd(hub)
        end,
        on_error = function(err)
          vim.notify("MCPHub error occurred")
          vim.print(err)
        end,
        use_bundled_binary = false,
        shutdown_delay = 600000,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        }
      })
    end
  }
end