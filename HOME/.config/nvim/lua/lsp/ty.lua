return {
  filetypes = { "python" },
  root_markers = {
    "ty.toml",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
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
        completions = {
          autoImport = true,
        },
      },
    },
  },
}
