my_on_attach = function(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap = true, silent = false }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gf', '<cmd>lua vim.lsp.buf.format {async=true}<CR>', opts)
  -- 'K' でカーソル下の変数情報を表示
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- 'gr' でカーソル下の変数を参照している箇所の一覧表示
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- 定義へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- 宣言へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- 実装へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- 型定義へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- Error/Warning/Hint が出ている箇所で実行可能な修正の候補を表示
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- 変数名のリネーム
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'go', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  -- 次のエラーへジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gj', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

  -- Reference highlight(カーソル下の変数をコード内でハイライトする)
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
      set updatetime=500
      highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
      highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
      highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  else
    print("this language server is not support documentHighlightProvider")
  end
end

require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
  -- LSP install
  ensure_installed = {
    -- python
    "pyright",
    -- rust
    "rust_analyzer",
    -- typescript
    "tsserver",
    -- lua
    "lua_ls",
    -- deno
    "denols",
    -- php
    "intelephense",
    -- kotlin
    "kotlin_language_server",
    -- dockerfile
    "dockerls",
    -- yaml
    "yamlls",
    -- json
    "jsonls",
    -- toml
    "taplo",
  },
})
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- Function executed when the LSP server startup
    on_attach = my_on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
  }
  if server == "pyright" then
    opt.settings = {
      python = {
        venvPath = ".",
        pythonPath = "./.venv/bin/python",
        analysis = {
          extraPaths = { "." }
        },
      },
    }
  end
  require('lspconfig')[server].setup(opt)
  require('mason-null-ls').setup({
    automatic_setup = true,
    automatic_installation = true,
    ensure_installed = {
      "prittierd",
      "stylua",
      "rustfmt",
      "black",
      "isort",
      "mypy",
    },
  })
end })
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)
-- エラーアイコンの変更
local signs = { Error = "", Warn = "", Hint = "", Info = "" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
