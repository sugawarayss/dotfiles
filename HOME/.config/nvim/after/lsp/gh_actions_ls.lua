return {
  filetypes = { "yaml_github" },
  cmd = { "gh-actions-language-server", "--stdio" },
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },
}
