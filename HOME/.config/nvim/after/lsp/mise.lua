-- mise 設定ファイルだけに mise lsp をアタッチする（それ以外の toml は tombi が担当）
return {
  cmd = { "mise", "lsp" },
  filetypes = { "toml" },
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if require("utils").is_mise_config(path) then
      on_dir(vim.fs.dirname(path))
    end
  end,
}
