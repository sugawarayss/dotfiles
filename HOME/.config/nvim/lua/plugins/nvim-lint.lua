-- 非同期リンタープラグイン
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local nvim_lint = require("lint")
    local venv_dir = "./.venv/"
    nvim_lint.linters.mypy.cmd = venv_dir .. "/bin/mypy"
    nvim_lint.linters.mypy.args = {
      "--install-types",
      "--non-interactive",
      "--config-file",
      "./pyproject.toml",
      "--python-executable",
      venv_dir .. "/bin/python",
    }
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
    }
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
