local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  return
end

local sources = {
  -- python
  null_ls.builtins.formatting.black.with({
    extra_args = { "--line-length=150" }
  }),
  null_ls.builtins.formatting.isort.with({
    "--multi-line=3",
    "--trailing-cmma",
    "--force-grid-wrap=0",
    "--use-parentheses",
    "--line-width=150",
  }),
  null_ls.builtins.diagnostics.flake8.with({
    diagnostics_format = '[flake8] #{m}\n(#{c})',
    extra_args = { "--max-line-length=150" }
  }),
  null_ls.builtins.diagnostics.mypy.with({
    diagnostics_format = '[mypy] #{m}\n(#{c})'
  }),
  -- Lua
  null_ls.builtins.formatting.stylua,
  -- Rust
  null_ls.builtins.formatting.rustfmt,
  -- Golang
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.goimports,
  -- JavaScript/TypeSctipt
  null_ls.builtins.formatting.prettierd.with({
    filetypes = {"html", "css", "yaml", "markdown"},
    extra_filetypes = {"toml"},
  }),
  null_ls.builtins.diagnostics.eslint_d.with({
    diagnostics_format = '[eslint] #{m}\n(#{c})'
  }),
  -- Json
  null_ls.builtins.formatting.jq,
}

null_ls.setup({ sources = sources })
