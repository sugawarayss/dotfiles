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
    extra_args = { "--max-line-length=150" }
  }),
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.rustfmt,
  -- JavaScript/TypeSctipt
  null_ls.builtins.formatting.prettierd,
  null_ls.builtins.diagnostics.eslint_d.with({
    diagnostics_format = '[eslint] #{m}\n(#{c})'
  }),
}

null_ls.setup({ sources = sources })
