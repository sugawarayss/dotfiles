-- Rust 用の機能を提供するプラグイン
return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false,
  opts = {
    tools = {
      executor = "toggleterm",
      test_executor = "neotest",
      enable_clippy = true,
      hover_actions = {
        replace_builtin_hover = true,
      },
      float_win_config = {
        auto_focus = true,
        open_split = "horizontal",
      }
    },
    server = {
      on_attach = function()
        vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
        -- set keybindings
        -- vim.keymap.set(
        --   "n",
        --   "<Leader>ac",
        --   function() vim.cmd.RustLsp("codeAction") end,
        --   { silent = true, buffer = vim.api.nvim_get_current_buf() }
        -- )
      end,
      cmd = function()
        local mason_registry = require("mason-registry")
        if mason_registry.is_installed("rust-analyzer") then
          -- This may need to be tweaked depending on the operating system
          local ra = mason_registry.get_package("rust-analyzer")
          local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
          return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
        else
          -- global installation
          return { "rust-analyzer" }
        end
      end,
      default_settings = {
        imports = {
          check = { command = "clippy" },
          granularity = { group = "module" },
          prefix = "self",
        },
        cargo = {
          buildScripts = { enable = true },
        },
        procMacro = { enable = true },
        rustfmt = {
          overrideCommand = { "rustfmt", "--edition", "2021" },
        }
      },
    },
    dap = {
      -- 
    },
  },
  config = function()
    print("hoge")
  end
}
