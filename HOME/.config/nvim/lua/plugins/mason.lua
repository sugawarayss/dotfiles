-- エラーアイコンの変更
local signs = { Error = "☠️", Warn = "🦈", Hint = "🐥", Info = "🕊️" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- 自動インストールするLSPサーバ
local lsp_servers = {
  "copilot",
  -- python
  "pyright",
  "ruff",
  -- fish
  "fish_lsp",
  -- sphinx
  -- "esbonio",
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
  -- "dockerls",
  -- docker-compose
  "docker_language_server",
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
  "gh_actions_ls",
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
  "ty",
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

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ---@since 1.0.0
      -- The directory in which to install packages.
      -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },

      ---@since 1.0.0
      -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
      -- debugging issues with package installations.
      log_level = vim.log.levels.INFO,
      ui = {
        ---@since 1.0.0
        -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        ---@since 1.0.0
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        -- Defaults to `:h 'winborder'` if nil.
        border = "double",

        ---@since 1.11.0
        -- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
        backdrop = 60,

        ---@since 1.0.0
        -- Width of the window. Accepts:
        -- - Integer greater than 1 for fixed width.
        -- - Float in the range of 0-1 for a percentage of screen width.
        width = 0.8,

        ---@since 1.0.0
        -- Height of the window. Accepts:
        -- - Integer greater than 1 for fixed height.
        -- - Float in the range of 0-1 for a percentage of screen height.
        height = 0.9,
        icons = {
          ---@since 1.0.0
          -- The list icon to use for installed packages.
          package_installed = "◍",
          ---@since 1.0.0
          -- The list icon to use for packages that are installing, or queued for installation.
          package_pending = "◍",
          ---@since 1.0.0
          -- The list icon to use for packages that are not installed.
          package_uninstalled = "◍",
        },
        keymaps = {
          ---@since 1.0.0
          -- Keymap to expand a package
          toggle_package_expand = "<CR>",
          ---@since 1.0.0
          -- Keymap to install the package under the current cursor position
          install_package = "i",
          ---@since 1.0.0
          -- Keymap to reinstall/update the package under the current cursor position
          update_package = "u",
          ---@since 1.0.0
          -- Keymap to check for new version for the package under the current cursor position
          check_package_version = "c",
          ---@since 1.0.0
          -- Keymap to update all installed packages
          update_all_packages = "U",
          ---@since 1.0.0
          -- Keymap to check which installed packages are outdated
          check_outdated_packages = "C",
          ---@since 1.0.0
          -- Keymap to uninstall a package
          uninstall_package = "X",
          ---@since 1.0.0
          -- Keymap to cancel a package installation
          cancel_installation = "<C-c>",
          ---@since 1.0.0
          -- Keymap to apply language filter
          apply_language_filter = "<C-f>",
          ---@since 1.1.0
          -- Keymap to toggle viewing package installation log
          toggle_package_install_log = "<CR>",
          ---@since 1.8.0
          -- Keymap to toggle the help view
          toggle_help = "g?",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      { "neovim/nvim-lspconfig" },
    },
    opts = {
      ensure_installed = vim.tbl_flatten({ lsp_servers, formatters, diagnostics, dap_adapters }),
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_enable = true,
      })
      -- 診断の表示設定
      vim.diagnostic.config({
        float = {
          scope = "line",
          border = "double",
          format = function(diagnostic)
            return string.format("%s", diagnostic.message)
          end,
        },
      })
      -- カーソル位置の診断を自動で表示
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "double",
            source = "always",
            scope = "cursor",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })
      -- LSPサーバ別に settings を lsp_server_settingsから設定する
      for _, server in pairs(require("mason-lspconfig").get_installed_servers()) do
        if server == "ty" then
          vim.lsp.config(server, {
            settings = {
              ty = {
                disableLanguageServices = false,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  variableTypes = true,
                  callArgumentNames = true,
                },
              },
            },
          })
        elseif server == "copilot" then
          vim.lsp.enable(server)
        else
          local target_config = require("lsp." .. server)
          vim.lsp.config(server, target_config)
        end
        if server ~= "ts_ls" and server ~= "denols" then
          vim.lsp.enable(server)
        end
      end
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    init = function()
      local wk = require("which-key")
      wk.add({
        -- カーソル下の情報を表示
        { "K", "<cmd>Lspsaga hover_doc<CR>", mode = { "n" }, icon = "", desc = "カーソル下の情報を表示" },
        -- 呼び出し階層を表示
        { "go", "<cmd>Lspsaga outgoing_calls<CR>", mode = { "n" }, desc = "呼び出し階層を表示" },
        -- 定義へジャンプ
        { "gd", "<cmd>Lspsaga goto_definition<CR>", mode = { "n" }, desc = "定義にジャンプ" },
        { "gD", "<cmd>Lspsaga peek_definition<CR>", mode = { "n" }, desc = "定義にジャンプ" },
        -- 呼出階層を表示
        { "gr", "<cmd>Lspsaga finder<CR>", mode = { "n" }, desc = "参照先の表示" },
        -- 型定義へジャンプ
        { "gt", "<cmd>Lspsaga goto_type_definition<CR>", mode = { "n" }, desc = "型定義にジャンプ" },
        -- カーソル位置の対象をリネーム
        { "gn", "<cmd>Lspsaga rename<CR>", mode = { "n" }, desc = "カーソル位置の対象をリネーム" },
        -- プロジェクト全体でシンボルを置換
        -- NOTE: `Lspsaga project_replace <old_name> <new_name>`
        -- コードアクションを表示
        { "ga", "<cmd>Lspsaga code_action<CR>", mode = { "n" }, desc = "コードアクションを表示" },
        -- 次の診断へジャンプ
        { "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", mode = { "n" }, desc = "次の診断へジャンプ" },
        -- 前の診断へジャンプ
        { "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", mode = { "n" }, desc = "前の診断へジャンプ" },
        -- アウトライン表示
        { "<Leader>ol", "<cmd>Lspsaga outline<CR>", mode = { "n" }, icon = "󰭸", desc = "アウトライン表示(Lspsaga)" },
      })
    end,
    config = function()
      require("lspsaga").setup({
        border = "double",
        devicon = true,
        title = true,
        -- パンくずリスト
        symbol_in_winbar = {
          enable = true,
          sparator = " › ",
          hide_keyword = false,
          show_file = true,
          folder_level = 1,
          color_mode = true,
          delay = 300,
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
          code_action = "",
        },
        -- コードアクション
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        finder = {
          max_height = 0.5,
          left_width = 0.3,
          right_width = 0.3,
          default = "ref+imp",
          methods = {}, -- { 'tyd' = 'textDocument/typeDefinition' },
          layout = "float",
          filter = {},
          silent = false,
          keys = {
            shuttle = "[w", -- Finder ウィンドウ間を移動
            -- 展開または開く
            toggle_or_open = "<CR>",
            -- 垂直分割
            vsplit = "<C-s><C-v>",
            -- 水平分割
            split = "<C-s><C-s>",
            -- 新しいタブで開く
            tabnew = "r",
            -- 終了
            quit = "q",
            -- 閉じる
            close = "<ESC>",
          },
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
            jump = "e", -- jump to pos even on a expand/collapse node
          },
        },
        hover = {
          max_width = 0.9,
          max_height = 0.8,
          open_link = "gx",
          open_cmd = "!arc",
        },
        -- diagnostic
        diagnostics = {
          show_code_action = true,
          jump_num_shortcut = true,
          max_width = 0.8,
          max_height = 0.6,
          text_hl_follow = true,
          border_follow = true,
          extend_relatedInformation = false,
          show_layout = "float",
          show_normal_height = 10,
          max_show_width = 0.9,
          max_show_height = 0.6,
          diagnostic_only_current = false,
          keys = {
            -- アクションを実行
            exec_action = "<CR>",
            -- ジャンプウィンドウを閉じる
            quit = "q",
            -- ウィンドウで選択箇所に ジャンプ
            toggle_or_jump = "<CR>",
            -- ウィンドウを閉じる
            quit_in_show = { "q", "<ESC>" },
          },
        },
        -- 定義
        definition = {
          width = 0.6,
          height = 0.5,
          keys = {
            -- ファイルを開く
            edit = "<CR>",
            -- 垂直分割
            vsplit = "<C-s><C-v>",
            -- 水平分割
            split = "<C-s><C-s>",
            -- 新しいタブで開く
            tabe = "<C-c>t",
            -- 終了
            quit = "q",
            -- 閉じる
            close = "<ESC>",
          },
        },
        -- 呼出階層表示時のアクションキーマップ
        callhierarchy = {
          keys = {
            -- ファイルを開く
            edit = "<CR>",
            -- 垂直分割
            vsplit = "<C-s><C-v>",
            -- 水平分割
            split = "<C-s><C-s>",
            -- 新しいタブで開く
            tabe = "t",
            -- 終了
            quit = "q",
            -- レイアウトを左右に移動する
            shuttle = "[w",
            -- トグルまたはリクエストを実行する
            toggle_or_req = "u",
            -- 閉じる
            close = "<ESC>",
          },
        },
        -- シンボルリネームの設定
        rename = {
          -- 元の名前が選択状態にしない
          in_select = false,
          -- リネーム後に自動保存
          auto_save = false,
          -- project_replaceモードのfloat windowのサイズ
          project_max_width = 0.5,
          project_max_height = 0.5,
          keys = {
            quite = "q",
            exec = "<CR>",
            -- project_replaceモードで置換対象の選択状態をトグルする
            select = "x",
          },
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
