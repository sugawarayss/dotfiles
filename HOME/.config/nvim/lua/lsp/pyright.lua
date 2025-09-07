return {
  filetypes = { "python" },
  -- LSPの設定
  settings = {
    python = {
      venvPath = require("utils").find_project_root({ "pyproject.toml", "requirements.txt" }) .. "/.venv",
      pythonPath = require("utils").find_python_venv({ "pyproject.toml", "requirements.txt" }) .. ".venv/bin/python",
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      analysis = { ignore = { "*" } },
    },
  },
}
