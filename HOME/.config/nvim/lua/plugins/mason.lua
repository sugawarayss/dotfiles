
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
  "ruff",
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
  "bashls",
  -- terraform
  "terraformls",
  -- github actions
  "gh_actions_ls"
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
  -- go
  "delve",
}

local my_on_attach = function(client, bufnr)
  local is_node_dir = function()
    -- 親ディレクトリに package.json が存在する場合はtrue
    local in_parents_dirs = require("lspconfig").util.root_pattern('package.json')(vim.fn.getcwd())
    -- 配下に package.jsonが存在する場合はtrue
    local in_child_dirs = vim.fn.findfile("package.json", vim.fn.getcwd() .. "/**") ~= ""
    return in_parents_dirs or in_child_dirs
  end
  for _, value in pairs(lsp_servers) do
    if client == value then
      -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      -- WhichKey が gf を使用しているので使えない。。。
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gf", "<cmd>lua vim.lsp.buf.format {async=true}<CR>", { noremap = true, silent = false, desc = "フォーマットを実行" })
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
      -- 変数名のリネーム
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = false, desc = "変数名のリネーム" })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = false, desc = "エラーをフロートウィンドウで表示" })
    end
  end
  if client ~= "ruff" then
    -- インラインヒント
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
  if is_node_dir() then
    if client.name == "denols" then
      vim.notify("[LSP] ts_ls: ACTIVE")
      client.stop(true)
    end
  else
    if client.name == "ts_ls" then
      vim.notify("[LSP] denols: ACTIVE")
      client.stop(true)
    end
  end
end
-- 各:withLSPサーバの設定
local lsp_server_settings = {
  pyright = {
    python = {
      venvPath = ".",
      pythonPath = "./.venv/bin/python",
      -- import 文の sort は ruffに任せる 
      disableOrganizeImports = true,
      -- チェック周りも ruff に任せる
      analysis = { ignore = { "*" } },
    },
  },
  ruff = {
    filetypes = { "python" },
    init_options = {
      settings = {
        configuration = "./pyproject.toml",
        -- ワークスペース内に存在する設定ファイル(ruff.toml/pyproject.toml)を以下の設定より優先する
        configurationPreference = "filesystemFirst",
        -- リンティングとフォーマットから除外するファイルパターンリスト
        exclude = {"**/tests/**"},
        -- lint/format 時の1行の長さ
        lineLength = 150,
        -- import 文のソートをコードアクションに追加
        organizeImports = true,
        -- 構文エラー診断を表示する
        showSyntaxErrors = true,
        codeAction = {
          -- `noqa` でルールを無視するクイックフィックスアクションを表示する
          disableRuleComment = { enable = true },
          -- 違反を自動修正するためのクイック修正アクションを表示する
          fixViolation = { enable = true },
        },
        -- リンティング設定
        lint = {
          enable = true,
          -- 不安定なルールは適用しない
          preview = false,
          -- 有効にするルール
          select = {},
          -- 追加で有効にするルール
          extendSelect = {"I"},
          -- 無効にするルール
          ignore = {},
        },
        format = {
          -- 不安定なルールは適用しない
          preview = false,
        },
      }
    }
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        }
      }
    }
  },
  gopls = {
    filetypes = { "go" },
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
  terraformls = {
    filetypes = { "tf", "tfstate" },
  },
  dockerls = {
    filetypes = { "dockerfile" },
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
  },
  gh_actions_ls = {
    cmd = { "gh-actions-language-server", "--stdio" },
    filetypes = { "yaml.github" },
    -- root_dir = require("lspconfig").util.root_pattern(".github"),
    single_file_support = true,
    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    }
  }
}

return {
  {
    -- LSPを管理するプラグイン
    "williamboman/mason.nvim",
    lazy = true,
    cmd = "Mason",
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "jay-babu/mason-null-ls.nvim" },
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      -- LSP handlers
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(require("noice.lsp.hover").on_hover, { border = "double" })

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        automatic_enable = false,
        automatic_installation = true,
        -- LSP install
        ensure_installed = lsp_servers,
      })
      require("mason-null-ls").setup({
        automatic_setup = true,
        automatic_installation = true,
        ensure_installed = vim.tbl_flatten({ formatters, diagnostics, dap_adapters }),
      })

      -- NOTE: LSP共通設定
      vim.lsp.config("*", {
        -- 共通設定
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      })
      -- LSPサーバ別に settings を lsp_server_settingsから設定する
      for _, server in pairs(require("mason-lspconfig").get_installed_servers()) do
        if "gh_actions_ls" == server then
          vim.filetype.add({
            pattern = {
              ['.*/%.github[%w/]+workflows[%w/]+.*%.ya?ml'] = 'yaml.github',
            },
          })
        end
        require("lspconfig")[server].setup({
          on_attach = my_on_attach,
          settings = lsp_server_settings[server],
          filetypes = (lsp_server_settings[server] or {}).filetypes,
        })
      end
      vim.lsp.enable(require("mason-lspconfig").get_installed_servers())
    end
  },
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    keys = {
      -- カーソル下の情報を表示
      { "K", "<cmd>Lspsaga hover_doc<CR>", mode = "n", desc = "カーソル下の情報を表示" },
      -- 呼び出し階層を表示
      { "go", "<cmd>Lspsaga outgoing_calls<CR>", mode = "n", desc = "呼び出し階層を表示" },
      -- 定義へジャンプ
      { "gd", "<cmd>Lspsaga goto_definition<CR>", mode = "n", desc = "定義にジャンプ" },
      { "gD", "<cmd>Lspsaga peek_definition<CR>", mode = "n", desc = "定義にジャンプ" },
      -- 呼出階層を表示
      { "gr", "<cmd>Lspsaga finder<CR>", mode = "n", desc = "参照先の表示" },
      -- 型定義へジャンプ
      { "gt", "<cmd>Lspsaga goto_type_definition<CR>", mode = "n", desc = "型定義にジャンプ"},
      -- コードアクションを表示
      { "ga", "<cmd>Lspsaga code_action<CR>", mode = "n", desc = "コードアクションを表示" },
      -- 次の診断へジャンプ
      { "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", mode = "n", desc = "次の診断へジャンプ" },
      -- 前の診断へジャンプ
      { "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", mode = "n", desc = "前の診断へジャンプ" },
      -- アウトライン表示
      { "<Leader>ol", "<cmd>Lspsaga outline<CR>", mode = "n", desc = "アウトライン表示(Lspsaga)" },

    },
    config = function()
      require("lspsaga").setup({
        border = "double",
        devicon = true,
        title = true,
        -- パンくずリスト
        symbol_in_winbar = {
          enable       = true,
          sparator     = " › ",
          hide_keyword = false,
          show_file    = true,
          folder_level = 1,
          color_mode   = true,
          delay        = 300,
        },
        lightbulb = {
          enable = false,
          -- sign = true,
          -- debounce = 10,
          -- sign_priority = 40,
          -- virtual_text = true,
          -- enable_in_insert = true,
          -- ignore = {
          --   clients = {},
          --   ft = {},
          -- },
        },
        ui = {
          code_action = ""
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
          default     = "ref+imp",
          methods     = {}, -- { 'tyd' = 'textDocument/typeDefinition' },
          layout      = "float",
          filter      = {},
          silent      = false,
          keys = {
            shuttle        = "[w", -- Finder ウィンドウ間を移動
            -- 展開または開く
            toggle_or_open = "<CR>",
            -- 垂直分割
            vsplit         = "<C-s><C-v>",
            -- 水平分割
            split          = "<C-s><C-s>",
            -- 新しいタブで開く
            tabnew         = "r",
            -- 終了
            quit           = "q",
            -- 閉じる
            close          = "<ESC>",
          }
        },
        -- アウトライン表示
        outline = {
          win_position = "right",
          win_width = 30,
          auto_preview = true,
          detail = true,
          auto_close = true,
          close_after_jump = false,
          layout = "normal", -- "float" or "normal"
          max_height = 0.5, -- float layout height
          left_width = 0.3, -- float layout left pane width
          keys = {
            -- ジャンプ
            toggle_or_jump = "<CR>",
            -- アウトラインウィンドウを閉じる
            quit = "q",
            -- 選択箇所にジャンプ
            jump = "e" -- jump to pos even on a expand/collapse node
          }
        },
        hover = {
          max_width  = 0.9,
          max_height = 0.8,
          open_link  = "gx",
          open_cmd   = "!arc",
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
            -- アクションを実行
            exec_action    = "<CR>",
            -- ジャンプウィンドウを閉じる
            quit           = "q",
            -- ウィンドウで選択箇所に ジャンプ
            toggle_or_jump = "<CR>",
            -- ウィンドウを閉じる
            quit_in_show   = { "q", "<ESC>" },
          }
        },
        -- 定義
        definition = {
          width  = 0.6,
          height = 0.5,
          keys = {
            -- ファイルを開く
            edit   = "<CR>",
            -- 垂直分割
            vsplit = "<C-s><C-v>",
            -- 水平分割
            split  = "<C-s><C-s>",
            -- 新しいタブで開く
            tabe   = "<C-c>t",
            -- 終了
            quit   = "q",
            -- 閉じる
            close  = "<ESC>",
          }
        },
        -- 呼出階層表示時のアクションキーマップ
        callhierarchy = {
          keys = {
            -- ファイルを開く
            edit   = "<CR>",
            -- 垂直分割
            vsplit = "<C-s><C-v>",
            -- 水平分割
            split  = "<C-s><C-s>",
            -- 新しいタブで開く
            tabe = "t",
            -- 終了
            quit = "q",
            -- レイアウトを左右に移動する
            shuttle = "[w",
            -- トグルまたはリクエストを実行する
            toggle_or_req = "u",
            -- 閉じる
            close = "<ESC>"
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
