return {
  filetypes = { "lua" },
  root_markers = {
    { ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
    { ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
    { ".git" },
  },
  -- LSPの設定
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
        disable = { "inject-field", "undefined-field", "missing-fields" },
      },
      runtime = { version = "LuaJIT" },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      codeLens = {
        enable = true,
      },
      hint = {
        enable = true,
        semicolon = "Disable",
      },
      telemetry = { enable = false },
    },
  },
}
