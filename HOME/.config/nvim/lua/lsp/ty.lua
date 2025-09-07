return {
  filetypes = { "python" },
  -- LSPの設定
  settings = {
    -- NOTE: lspconfig でsetupする時はsettingsはいらない
    settings = {
      ty = {
        disableLanguageServices = false,
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
        },
      },
    },
  },
}
