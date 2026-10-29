-- Rust 用の機能を提供するプラグイン
-- rustaceanvim は lazy.nvim の opts/config を読まず vim.g.rustaceanvim だけを見るため、init で設定する。
-- rust-analyzer は rustaceanvim が起動するので、mason-lspconfig 側では有効化しない (mason.lua 参照)。
return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      tools = {
        executor = "snacks_terminal",
        test_executor = "neotest",
        enable_clippy = true,
        hover_actions = {
          -- Lspsaga と内容が重複して表示されてしまうので、こっちでは無効にする
          replace_builtin_hover = false,
        },
        float_win_config = {
          auto_focus = true,
          open_split = "horizontal",
        },
      },
      server = {
        on_attach = function()
          vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            imports = {
              granularity = { group = "module" },
              prefix = "self",
            },
            cargo = {
              buildScripts = { enable = true },
            },
            procMacro = { enable = true },
            rustfmt = {
              overrideCommand = { "rustfmt", "--edition", "2021" },
            },
            lens = {
              debug = { enable = true },
              enable = true,
              implementations = { enable = true },
              references = {
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
              },
              run = { enable = true },
              updateTest = { enable = true },
            },
          },
        },
      },
    }
  end,
}
