
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
  -- markdown
  "marksman",
  -- bash(zsh)
  "bashls"
}
-- 自動インストールするformatter
local formatters = {
  -- python
  "ruff",
  -- Go
  "gofumpt",
  "goimports",
  -- lua
  "stylua",
  -- json,
  "jq",
  -- yaml
  "yamlfmt",
  -- shell
  "shfmt",
}
-- 自動インストールするlinter
local diagnostics = {
  -- spell check
  "cspell",
  -- python
  "mypy",
  -- TypeScript
  "biome",
  -- lua
  "luacheck",
  -- dart
  "dcm",
  -- Go
  "staticcheck",
  -- markdown
  "markdownlint",
  -- php
  "phpstan",
  -- yaml
  "yamllint",
  -- shell script
  "shellcheck",
  -- code security
  "semgrep",
  -- code security
  "gitleaks",
  -- dockerfile
  "hadolint",
}
-- dap adapters
local dap_adapters = {
  -- rust
  "codelldb",
  -- python
  "debugpy",
}

local my_on_attach = function(client, bufnr)
  for _, value in pairs(lsp_servers) do
    if client == value then
      -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      -- FIXME: WhichKey が gf を使用しているので使えない。。。
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gf", "<cmd>lua vim.lsp.buf.format {async=true}<CR>", { noremap = true, silent = false, desc = "フォーマットを実行" })
      -- "K" でカーソル下の変数情報を表示
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {  noremap = true, silent = false, desc = "カーソル下の変数情報を表示" })
      -- "gr" でカーソル下の変数を参照している箇所の一覧表示
      --vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      -- 定義へジャンプ
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = false, desc = "定義へジャンプ" })
      -- 宣言へジャンプ
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = false, desc = "宣言へジャンプ" })
      -- 実装へジャンプ
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = false, desc = "実装へジャンプ" })
      -- 型定義へジャンプ
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true, silent = false, desc = "型定義へジャンプ" })
      -- Error/Warning/Hint が出ている箇所で実行可能な修正の候補を表示
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = false, desc = "Error/Warning/Hint が出ている箇所で実行可能な修正の候補を表示" })
      -- 変数名のリネーム
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = false, desc = "変数名のリネーム" })

      vim.api.nvim_buf_set_keymap(bufnr, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = false, desc = "エラーをフロートウィンドウで表示" })
      -- 次のエラーへジャンプ
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = false, desc = "次のエラーへジャンプ" })
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = false, desc = "前のエラーへジャンプ" })
    end
  end
  if client ~= "ruff" then
    -- インラインヒント
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end
-- 各:withLSPサーバの設定
local lsp_server_settings = {
  pyright = {
    --pyright = {
    --  -- ruff
    --},
    python = {
      venvPath = ".",
      pythonPath = "./.venv/bin/python",
      disableOrganizeImports = true,
      analysis = {
        ignore = { "*" },
      },
    },
  },
  ruff = {
    init_options = {
      settings = {
        configuration = "./pyproject.toml",
        configurationPreference = "filesystemFirst",
        lint = {
          enable = true,
          extendSelect = {"I"}
        }
      }
    }
  },
  gopls = {
    analyses = {
      nilness      = true,
      unusedparams = true,
      unusedwrite  = true,
      useany       = true,
    },
    experimentalPostfixCompletions = true,
    staticcheck                    = true,
    usePlaceholders                = true,
  },
  marksman = {
    filetypes = { "markdown" },
  },
  yamlls = {
    filetypes = { "yaml" },
  },
  jsonls = {
    filetypes = { "json" },
  },
  taplo = {
    filetypes = { "toml" },
  },
  bashls = {
    filetypes = { "sh", "zsh" },
  }
}

return {
  {
    -- LSPを管理するプラグイン
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
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    keys = {
      -- カーソル下の情報を表示
      { "K", "<cmd>Lspsaga hover_doc<CR>", mode = "n", desc = "カーソル下の情報を表示" },
      -- 定義へジャンプ
      { "gd", "<cmd>Lspsaga goto_definition<CR>", mode = "n", desc = "定義にジャンプ" },
      -- 呼出階層を表示
      { "gr", "<cmd>Lspsaga finder<CR>", mode = "n", desc = "参照先の表示" },
      -- 型定義へジャンプ
      { "gt", "<cmd>Lspsage goto_type_definition<CR>", mode = "n", desc = "型定義にジャンプ"},
      -- コードアクションを表示
      { "ga", "<cmd>Lspsaga code_action<CR>", mode = "n", desc = "コードアクションを表示" },
      -- 次の診断へジャンプ
      { "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", mode = "n", desc = "次の診断へジャンプ" },
      -- 前の診断へジャンプ
      { "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", mode = "n", desc = "前の診断へジャンプ" },

    },
    config = function()
      require("lspsaga").setup({
        -- パンくずリスト
        symbol_in_winbar = {
          enable       = false,
          sparator     = " › ",
          hide_keyword = false,
          show_file    = true,
          folder_level = 1,
          color_mode   = true,
          delay        = 300,
        },
        -- コードアクション
        code_action = {
          num_shortcut     = true,
          show_server_name = true,
          extend_gitsigns  = false,
          keys = {
            quit = "q",
            exec = "<CR>",
          }
        },
        finder = {
          max_height  = 0.5,
          left_width  = 0.3,
          right_width = 0.3,
          default     = "ref",
          methods     = {}, -- e.g.) {"tyd" = "textDocument/typeDefinition"}
          layout      = "float",
          filter      = {},
          silent      = false,
          keys = {
            shuttle        = "[w", -- Finder ウィンドウ間を移動
            toggle_or_open = "<CR>",
            vsplit         = "sv",
            split          = "ss",
            tabnew         = "r",
            quit           = "q",
            close          = "<ESC>",
          }

        },
        hover = {
          max_width  = 0.9,
          max_height = 0.8,
          open_link  = "gx",
          open_cmd   = "!chrome",
        },
        -- diagnostic
        diagnostics = {
          show_code_action          = true,
          jump_num_shortcut         = true,
          max_width                 = 0.8,
          max_height                = 0.6,
          text_hl_follow            = true,
          border_follow             = true,
          extend_relatedInformation = false,
          show_layout               = "float",
          show_normal_height        = 10,
          max_show_width            = 0.9,
          max_show_height           = 0.6,
          diagnostic_only_current   = false,
          keys = {
            exec_action    = "<CR>",
            quit           = "q",
            toggle_or_jump = "<CR>",
            quit_in_show   = { "q", "<ESC>" },
          }
        },
        -- 定義
        definition = {
          width  = 0.6,
          height = 0.5,
          keys = {
            edit   = "<CR>",
            vsplit = "sv",
            split  = "ss",
            tabe   = "<C-c>t",
            quit   = "q",
            close  = "<ESC>",
          }
        },
        -- 呼出階層表示時のアクションキーマップ
        callhierarchy = {
          keys = {
            -- ファイルを開く
            edit   = "<CR>",
            vsplit = "sv",
            split  = "ss",
          }
        }
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",

    }
  }
}
