-- 非同期リンタープラグイン
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local nvim_lint = require("lint")
    local venv_dir = "./.venv/"
    nvim_lint.linters.mypy.cmd = venv_dir .. "/bin/mypy"
    -- nvim_lint.linters.mypy.args = {
    --   mypy_path,
    --   '--show-column-numbers',
    --   '--show-error-end',
    --   '--hide-error-context',
    --   '--install-types',
    --   '--non-interactive',
    --   '--no-color-output',
    --   '--no-error-summary',
    --   '--no-pretty',
    --   '--python-executable',
    --   venv_dir .. "/bin/python",
    -- }
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return string.format('[%s] (%s) %s', diagnostic.source, diagnostic.code, diagnostic.message)
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
