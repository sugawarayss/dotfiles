return {
  filetypes = { "yaml_github" },
  settings = {
    cmd = { "gh-actions-language-server", "--stdio" },
    single_file_support = true,
    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    },
  },
}
