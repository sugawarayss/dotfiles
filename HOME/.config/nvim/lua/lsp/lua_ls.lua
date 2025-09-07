return {
  filetypes = { "lua" },
  -- LSPの設定
  settings = {
    {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
  },
}
