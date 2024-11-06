-- LSPを管理するプラグイン
local my_on_attach = function(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gf", "<cmd>lua vim.lsp.buf.format {async=true}<CR>", { noremap = true, silent = false, desc = "フォーマットを実行" })
  -- 'K' でカーソル下の変数情報を表示
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {  noremap = true, silent = false, desc = "カーソル下の変数情報を表示" })
  -- 'gr' でカーソル下の変数を参照している箇所の一覧表示
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- 定義へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = false, desc = "定義へジャンプ" })
  -- 宣言へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = false, desc = "宣言へジャンプ" })
  -- 実装へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = false, desc = "実装へジャンプ" })
  -- 型定義へジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true, silent = false, desc = "型定義へジャンプ" })
  -- Error/Warning/Hint が出ている箇所で実行可能な修正の候補を表示
  vim.api.nvim_buf_set_keymap(bufnr, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = false, desc = "Error/Warning/Hint が出ている箇所で実行可能な修正の候補を表示" })
  -- 変数名のリネーム
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = false, desc = "変数名のリネーム" })

  vim.api.nvim_buf_set_keymap(bufnr, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = false, desc = "エラーをフロートウィンドウで表示" })
  -- 次のエラーへジャンプ
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = false, desc = "次のエラーへジャンプ" })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = false, desc = "前のエラーへジャンプ" })

  -- インラインヒント
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

-- エラーアイコンの変更
local signs = { Error = "", Warn = "", Hint = "", Info = "" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


-- 自動インストールするLSPサーバ
local lsp_servers = {
  -- python
  "pyright",
  -- sphinx
  "esbonio",
  -- rust
  "rust_analyzer",
  -- go
  "gopls",
  -- typescript
  "ts_ls",
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
}
-- 自動インストールするformatter
local formatters = {
  -- python
  "black",
  -- "isort",
  "ruff",
  -- Go
  "gofmpt",
  "goimports",
  -- lua
  "stylua",
}
-- 自動インストールするlinter
local diagnostics = {
  -- spell check
  "cspell",
  -- python
  "mypy",
  -- TypeScript
  "biome",
  -- dart
  "dcm",
  -- Go
  "staticcheck",
}
-- dap adapters
local dap_adapters = {
  -- rust
  codelldb,
}

-- 各:withLSPサーバの設定
local lsp_server_settings = {
  pyright = {
    pyright = {
      -- ruff 
      disableOrganizeImports = true,
    },
    python = {
      venvPath = ".",
      pythonPath = "./.venv/bin/python",
      analysis = {
        ignore = { "*" },
      },
    },
  },
  gopls = {
    analyses = {
      nilness = true,
      unusedparams = true,
      unusedwrite = true,
      useany = true,
    },
    experimentalPostfixCompletions = true,
    staticcheck = true,
    usePlaceholders = true,
  },
}

return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = { "LspAttach" },
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "double",
        },
        hover = {
          border = "double",
        },
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    event = { "LspAttach" },
    dependencies = {
      { "jay-babu/mason-null-ls.nvim", dependencies = "jose-elias-alvarez/null-ls.nvim" },
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      -- LSP handlers
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(require("noice.lsp.hover").on_hover, { border = "double" })

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        automatic_installation = true,
        -- LSP install
        ensure_installed = lsp_servers,
      })
      local nvim_lsp = require("lspconfig")
      mason_lspconfig.setup_handlers({
        function(server)
          if server == "rust_analyzer" then
            return true
          end
          local opt = {
            -- Function executed when the LSP server startup
            on_attach = my_on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
            settings = lsp_server_settings[server],
            filetypes = (lsp_server_settings[server] or {}).filetypes,
          }
          -- node.js と deno が競合しないようにする
          local node_root_dir = nvim_lsp.util.root_pattern("package.json")
          local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
          if server == "ts_ls" then
            if not is_node_repo then
              return
            end
            opt.on_attach = function(client, bufnr)
              -- client.resolved_capabilities.document_formatting = false
              my_on_attach(client, bufnr)
            end
            opt.root_dir = node_root_dir
          elseif server == "denols" then
            if is_node_repo then
              return
            end
            opt.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
            opt.init_options = {
              lint = true,
              unstable = true,
              suggest = {
                imports = {
                  hosts = {
                    ["https://deno.land"] = true,
                    ["https://cdn.nest.land"] = true,
                    ["https://crux.land"] = true,
                  },
                },
              },
            }
          end

          nvim_lsp[server].setup(opt)
          require("mason-null-ls").setup({
            automatic_setup = true,
            automatic_installation = true,
            ensure_installed = vim.tbl_flatten({ formatters, diagnostics, dap_adapters }),
          })
        end,
      })
    end
  },
}
