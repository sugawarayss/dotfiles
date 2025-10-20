return {
  filetypes = { "dockerfile", "yaml.docker-compose" },
  settings = {
    initializationOptions = {
      dockercomposeExperimental = {
        composeSupport = true,
      },
      dockerfileExperimental = {
        removeOverlappingIssues = true,
      },
      telemetry = "off",
    },
  },
}
