return {
  filetypes = { "python" },
  root_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  -- LSPの設定
  settings = {
    python = {
      venvPath = require("utils").find_project_root({ "pyproject.toml", "requirements.txt" }) .. "/.venv",
      pythonPath = require("utils").find_python_venv({ "pyproject.toml", "requirements.txt" }) .. ".venv/bin/python",
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        ignore = { "*" },
      },
    },
  },
}
