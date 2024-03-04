-- LinterやFormatterを統合するプラグイン
return {
  "nvimtools/none-ls.nvim",
  lazy = true,
  event = "LspAttach",
  config = function()
    local null_ls = require("null-ls")
    local sources = {
      -- python
      null_ls.builtins.formatting.black.with({
        filetypes = { "python" },
        extra_args = { "--line-length=150" }
      }),
      null_ls.builtins.formatting.isort.with({
        filetypes = { "python" },
        extra_args = { "--settings-path", "./pyproject.toml" }
      }),
      null_ls.builtins.formatting.ruff.with({
        filetypes = { "python" },
        extra_args = { "--config", "./pyproject.toml" }
      }),
      --null_ls.builtins.formatting.ruff.with({
      --  "--line-length=150",
      --  "--ignore=ANN101",  -- Missing-type-function-argument
      --  "--ignore=D",       -- pydocstyle
      --  "--ignore=FA",      -- flake8-future-annotations
      --  "--ignore=TRY",     -- tryceratops
      --  "--ignore=TD",      -- flake8-todo
      --  "--ignore=FIX",     -- flake8-fixme
      --  "--ignore=YTT",     -- flake8-2020
      --  "--igonore=S",      -- flake8-bandit
      --  "--ignore=BLE",     -- flake8-bind-except
      --  "--ignore=FBT",     -- flake8-boolean-trap
      --  "--ignore=B",       -- flake8-bugbear
      --  "--ignore=COM",     -- flake8-cmmas
      --  "--ignore=CPY",     -- flake8-copyright
      --  "--ignore=C4",      -- flake8-comrehensions
      --  "--ignore=DTZ",     -- flake8-datetimez
      --  "--ignore=T10",     -- flake8-debugger
      --  "--ignore=EM",      -- flake8-errmsg
      --  "--ignore=EXE",     -- flake8-executable
      --  "--ignore=ISC",     -- fkale8-implict-str-concat
      --  "--ignore=G",       -- flake8-logging-format
      --  "--ignore=T20",     -- flake8-print
      --  "--ignore=TID",     -- flake8-tidy-imports
      --  "--ignore=ARG",     -- flake8-unused-arguments
      --  "--ignore=PTH",     -- flake8-use-pathlib
      --  "--ignore=ERA",     -- eradicate
      --  "--ignore=FLY",     -- flynt
      --  "--ignore=E501",    -- pydocstyle (line-too-log)
      --  "--fix",            -- auto fix
      --}),
      --null_ls.builtins.diagnostics.mypy.with({
      --  diagnostics_format = '[mypy] #{m}\n(#{c})'
      --}),
      null_ls.builtins.diagnostics.ruff.with({
        filetypes = { "python" },
        diagnostics_format = '[ruff] #{m}\n(#{c})',
        extra_args = { "--config", "./pyproject.toml" }
      }),
      --null_ls.builtins.diagnostics.ruff.with({
      --  diagnostics_format = '[ruff] #{m}\n(#{c})',
      --  extra_args = {
      --    "--line-length=150",
      --    "--ignore=ANN101",  -- Missing-type-function-argument
      --    "--ignore=D",       -- pydocstyle
      --    "--ignore=FA",      -- flake8-future-annotations
      --    "--ignore=TRY",     -- tryceratops
      --    "--ignore=TD",      -- flake8-todo
      --    "--ignore=FIX",     -- flake8-fixme
      --    "--ignore=YTT",     -- flake8-2020
      --    "--igonore=S",      -- flake8-bandit
      --    "--ignore=BLE",     -- flake8-bind-except
      --    "--ignore=FBT",     -- flake8-boolean-trap
      --    "--ignore=B",       -- flake8-bugbear
      --    "--ignore=COM",     -- flake8-cmmas
      --    "--ignore=CPY",     -- flake8-copyright
      --    "--ignore=C4",      -- flake8-comrehensions
      --    "--ignore=DTZ",     -- flake8-datetimez
      --    "--ignore=T10",     -- flake8-debugger
      --    "--ignore=EM",      -- flake8-errmsg
      --    "--ignore=EXE",     -- flake8-executable
      --    "--ignore=ISC",     -- fkale8-implict-str-concat
      --    "--ignore=G",       -- flake8-logging-format
      --    "--ignore=T20",     -- flake8-print
      --    "--ignore=TID",     -- flake8-tidy-imports
      --    "--ignore=ARG",     -- flake8-unused-arguments
      --    "--ignore=PTH",     -- flake8-use-pathlib
      --    "--ignore=ERA",     -- eradicate
      --    "--ignore=FLY",     -- flynt
      --    "--ignore=E501",    -- pydocstyle (line-too-log)
      --  },
      --}),
      -- Lua
      null_ls.builtins.formatting.stylua,
      -- Golang
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,
      -- JavaScript/TypeScript
      null_ls.builtins.formatting.prettier.with({ -- FIXME: 効かない。。。
        filetypes = { "javascript", "typescript", "jsx", "html", "css", "scss", "markdown" },
      }),
      null_ls.builtins.diagnostics.eslint_d.with({
        filetypes = { "javascript", "typescript", "jsx", "html", "css", "scss", "markdown" },
        diagnostics_format = '[eslint] #{m}\n(#{c})'
      }),
      -- Json
      -- null_ls.builtins.formatting.jq,
    }
    null_ls.setup({ sources = sources })
  end
}
