-- 非同期リンタープラグイン
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local nvim_lint = require("lint")

    -- mypy の設定
    local venv_dir = "./.venv/"
    nvim_lint.linters.mypy.cmd = venv_dir .. "bin/mypy"
    nvim_lint.linters.mypy.args = {
      "--install-types",
      "--non-interactive",
      "--config-file",
      "./pyproject.toml",
      "--python-executable",
      venv_dir .. "bin/python",
    }
    -- github actions の設定
    -- nvim_lint.linters.ghalint = {
    --   cmd = "ghalint",
    --   stdin = true,
    --   append_fname = true,
    --   args = { "run" },
    --   stream = "both",
    --   ignore_exitcode = true,
    --   env = nil,
    --   parser = function(output, _)
    --     local items = {}
    --     if output == "" then
    --       return items
    --     end
    --     local decoded = vim.json.decode(output) or {}
    --     local bufpath = vim.fn.expand("%:p")
    --     for _, diag in ipairs(decoded) do
    --       table.insert(items, {
    --         source = "ghalint",
    --         lnum
    --       })
    --     end
    --   end,
    -- }

    -- luacheck の設定ファイルの指定
    nvim_lint.linters.luacheck.args = { "--config", "~/.config/nvim/.luarc.json"}

    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          -- diagnostic.source と diagnositc.code が nil でない場合のみカスタマイズする
          if diagnostic.source ~= nil then
            if diagnostic.code ~= nil then
              return string.format('[%s] (%s) %s', diagnostic.source, diagnostic.code, diagnostic.message)
            end
            return string.format('[%s] %s', diagnostic.source, diagnostic.message)
          end
          return string.format(base_format, diagnostic.source, diagnostic.code, diagnostic.message)
        end
      }
    })
    nvim_lint.linters_by_ft = {
      python = { "mypy" },
      fish = { "fish" },
      markdown = { "markdownlint" },
      lua = { "luacheck" },
      yaml = { "yamllint" },
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
          { ignore_errors = true }
        )
      end,
    })
  end,
}
