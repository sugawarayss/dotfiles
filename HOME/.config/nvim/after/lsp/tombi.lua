local root_markers = { "tombi.toml", "pyproject.toml", ".git" }

return {
  filetypes = { "toml" },
  -- mise 設定ファイルは mise lsp に任せるため、tombi はアタッチしない
  root_dir = function(bufnr, on_dir)
    if require("utils").is_mise_config(vim.api.nvim_buf_get_name(bufnr)) then
      return
    end
    on_dir(vim.fs.root(bufnr, root_markers))
  end,
  settings = {},
}
