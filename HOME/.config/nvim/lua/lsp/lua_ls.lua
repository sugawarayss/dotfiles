return {
  filetypes = { "lua" },
  -- LSPの設定
  settings = {
    {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
  },
}
