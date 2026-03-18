return {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    analyses = {
      nilness = true,
      unusedparams = true,
      unusedwrite = true,
      useany = true,
    },
    experimentalPostfixCompletions = true,
    staticcheck = true,
    usePlaceholders = true,
  },
}
