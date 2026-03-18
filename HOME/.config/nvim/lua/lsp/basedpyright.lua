return {
  filetypes = { "python" },
  settings = {
    basedpyright = {
      diagnosticMode = "openFilesOnly",
      typeCheckingMode = "standard",
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
        functionReturnTypes = true,
        genericTypes = true,
      },
      analysis = {
        autoFormatStrings = true,
        configFilePath = require("utils").find_project_root({ "pyproject.toml", "requirements.txt" }),
      },
      venvPath = require("utils").find_project_root({ "pyproject.toml", "requirements.txt" }) .. "/.venv",
      pythonPath = require("utils").find_python_venv({ "pyproject.toml", "requirements.txt" }) .. ".venv/bin/python",
    },
  },
}
