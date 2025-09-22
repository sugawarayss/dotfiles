-- 非同期リンタープラグイン
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local nvim_lint = require("lint")

    local project_root = require("utils").find_project_root({ "pyproject.toml" })
    if project_root then
      -- pyproject.toml が存在する場合のみmypyを設定
      local venv_dir = project_root .. "/.venv"
      local project_mypy = venv_dir .. "/bin/mypy"
      local get_mypy_cmd_path = function()
        local mason_mypy = vim.fn.stdpath("data") .. "/mason/packages/mypy/venv/bin/mypy"
        return require("utils").is_path_exists(project_mypy, "file") and project_mypy or mason_mypy
      end
      nvim_lint.linters.mypy.cmd = get_mypy_cmd_path()
      local pyproject_path = project_root .. "/pyproject.toml"
      if require("utils").is_path_exists(pyproject_path, "file") then
        nvim_lint.linters.mypy.args = {
          "--install-types",
          "--non-interactive",
          "--config-file",
          project_root .. "/pyproject.toml",
          "--python-executable",
          venv_dir .. "/bin/python",
        }
      end
    else
      -- pyproject.tomlが無い(pythonプロジェクトじゃない)場合はデフォルト設定
      nvim_lint.linters.mypy.args = {
        "--install-types",
        "--non-interactive",
      }
    end

    -- github actions の設定
    nvim_lint.linters.ghalint = {
      cmd = "ghalint",
      stdin = true,
      append_fname = true,
      args = { "run" },
      stream = "both",
      ignore_exitcode = true,
      env = nil,
      parser = function(output, _)
        local items = {}
        if output == "" then
          return items
        end
        local decoded = vim.json.decode(output) or {}
        -- local bufpath = vim.fn.expand("%:p")
        for _, _ in ipairs(decoded) do
          table.insert(items, {
            source = "ghalint",
            lnum,
          })
        end
      end,
    }

    -- luacheck の設定ファイルの指定
    nvim_lint.linters.luacheck.args = { "--config", "~/.config/nvim/.luarc.json" }

    nvim_lint.linters_by_ft = {
      python = { "mypy" },
      fish = { "fish" },
      markdown = { "markdownlint" },
      lua = { "luacheck" },
      yaml = { "yamllint" },
      yaml_github = { "actionlint", "zizmor" },
      dockerfile = { "hadolint" },
    }

    -- local function get_linters_for_file()
    --   local result = {}
    --   local buf_name = vim.api.nvim_buf_get_name(0)
    --   local ft = vim.bo.filetype
    --
    --   -- デフォルトのlinter を取得
    --   local linters = nvim_lint.linters_by_ft[ft] or {}
    --   -- テーブルをコピー
    --   for _, linter in ipairs(linters) do
    --     table.insert(result, linter)
    --   end
    --   -- Github Actions Workflow ファイルの場合は `actionlint` `ghalint` `zizmor` でチェック
    --   if ft == "yaml" and buf_name:match("%.github/workflows/.*%.ya?ml$") then
    --     vim.notify("GitHub Actions Workflow File is lint by `acrtionlint` `ghalint` `zizmor`")
    --     -- GitHub Actions用の特別なlinterを追加
    --     table.insert(result, "actionlint")
    --     -- table.insert(result, "ghalint")
    --     table.insert(result, "zizmor")
    --   end
    --   if #result == 0 then
    --     return nil
    --   end
    --   return result
    -- end

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        require("lint").try_lint(
          -- コマンドが見つからない場合はエラーを無視する
          nil,
          { ignore_errors = false }
        )
      end,
    })
  end,
}
