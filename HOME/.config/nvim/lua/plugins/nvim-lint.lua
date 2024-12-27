-- 非同期リンタープラグイン
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local nvim_lint = require("lint")
    -- local venv_dir = "./.venv/"
    -- nvim_lint.linters.mypy.cmd = venv_dir .. "/bin/mypy"
    -- nvim_lint.linters.mypy.args = {
    -- 	-- mypy_path,
    -- 	"--install-types",
    -- 	"--non-interactive",
    -- 	"--config-file pyproject.toml",
    -- 	-- venv_dir .. "/bin/python",
    -- }
    nvim_lint.linters_by_ft = {
      python = { "mypy" },
    }
    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
