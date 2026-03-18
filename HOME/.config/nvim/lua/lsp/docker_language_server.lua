return {
  filetypes = { "dockerfile", "yaml.docker-compose" },
  root_markers = {
    "Dockerfile",
    "docker-compose.yaml",
    "docker-compose.yml",
    "compose.yaml",
    "compose.yml",
    "docker-bake.json",
    "docker-bake.hcl",
    "docker-bake.override.json",
    "docker-bake.override.hcl",
  },
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
