return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local sources = {
      -- python
      null_ls.builtins.formatting.black.with({
        extra_args = { "--line-length=150" }
      }),
      null_ls.builtins.formatting.ruff.with({
        "--line-length=150",
        "--ignore=ANN101",  -- Missing-type-function-argument
        "--ignore=D100",    -- Missing docstring in public module
        "--ignore=D102",    -- Missing docstring in public method
        "--ignore=D104",    -- Missing docstring in public package
        "--ignore=D105",    -- Missing docstring in magic method
        "--ignore=D106",    -- Missing docstring in public nested class
        "--ignore=D107",    -- Missing docstring in __init__
        "--ignore=D205",    -- 1 blank line required between summary line and description
        "--ignore=D212",    -- Multi-line docstring summary should start at the first line
        "--ignore=D400",    -- First line should end with a period
        "--ignore=D415",    -- First line should end with a period, question mark, or exclamation point
        "--ignore=FA",      -- flake8-future-annotations
        "--ignore=TRY",     -- tryceratops
        "--ignore=TD",      -- flake8-todo
        "--ignore=FIX",     -- flake8-fixme
        "--fix",            -- auto fix
      }),
      null_ls.builtins.diagnostics.mypy.with({
        diagnostics_format = '[mypy] #{m}\n(#{c})'
      }),
      null_ls.builtins.diagnostics.ruff.with({
        diagnostics_format = '[ruff] #{m}\n(#{c})',
        extra_args = {
          "--line-length=150",
          "--ignore=ANN101",  -- Missing-type-function-argument
          "--ignore=D100",    -- Missing docstring in public module
          "--ignore=D102",    -- Missing docstring in public method
          "--ignore=D104",    -- Missing docstring in public package
          "--ignore=D105",    -- Missing docstring in magic method
          "--ignore=D106",    -- Missing docstring in public nested class
          "--ignore=D107",    -- Missing docstring in __init__
          "--ignore=D205",    -- 1 blank line required between summary line and description
          "--ignore=D212",    -- Multi-line docstring summary should start at the first line
          "--ignore=D400",    -- First line should end with a period
          "--ignore=D415",    -- First line should end with a period, question mark, or exclamation point
          "--ignore=FA",      -- flake8-future-annotations
          "--ignore=TRY",     -- tryceratops
          "--ignore=TD",      -- flake8-todo
          "--ignore=FIX",     -- flake8-fixme
        },
      }),
      -- Lua
      null_ls.builtins.formatting.stylua,
      -- Golang
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,
      -- JavaScript/TypeSctipt
      null_ls.builtins.formatting.prettier.with({ -- FIXME: 効かない。。。
        filetypes = { "javascript", "typescript", "jsx", "html", "css", "scss", "markdown" },
      }),
      null_ls.builtins.diagnostics.eslint_d.with({
        diagnostics_format = '[eslint] #{m}\n(#{c})'
      }),
      -- Json
      null_ls.builtins.formatting.jq,
    }
    null_ls.setup({ sources = sources })
  end
}
