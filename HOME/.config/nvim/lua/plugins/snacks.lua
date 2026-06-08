local tool_logo = require("tool_logo")
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  cond = function()
    return not vim.g.vscode
  end,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- lua デバッグ用にdd関数を定義
        -- dd(something) で通知領域に内容を表示する
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
        -- INFO: 今後使うかもしれないのでコメントアウトして残す
        -- スペルチェックの有効/無効のトグル
        --Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us", { desc = "スペルチェックの有効/無効のトグル" })
        -- 行番号の相対表示の有効/無効のトグル
        --Snacks.toggle
        --      .option("relativenumber", { name = "Relative Number" })
        --      :map("<leader>ul", { desc = "行番号の相対表示の有効/無効のトグル" })
        -- 診断の有効/無効のトグル
        --Snacks.toggle.diagnostics():map("<leader>ud", { desc = "診断の有効/無効のトグル" })
        -- インレイヒントの有効/無効のトグル
        --Snacks.toggle.inlay_hints():map("<leader>uh", { desc = "インレイヒントの有効/無効のトグル" })
        -- 折り返しのトグル
        -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        -- 行番号表示のトグル
        -- Snacks.toggle.line_number():map("<leader>ul")
        -- マークダウン記法を隠す機能のトグル
        -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        -- treesitterのトグル?
        -- Snacks.toggle.treesitter():map("<leader>uT")
        -- 背景色のライトモード/ダークモードをトグル
        -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        -- インデントガイド表示のトグル
        -- Snacks.toggle.indent():map("<leader>ug")
        -- アクティブでない部分を暗く表示する機能のトグル
        -- Snacks.toggle.dim():map("<leader>uD")
      end,
    })
    vim.api.nvim_create_user_command("Highlights", function()
      Snacks.picker.highlights()
    end, { desc = "ハイライトの定義をpickerで表示" })
    vim.api.nvim_create_user_command("Autocommands", function()
      Snacks.picker.autocmds()
    end, { desc = "Autocommandリストをpickerで表示" })
  end,
  opts = {
    -- 指定のサイズより大きいファイルを開いたときにattach されるfiletypeを追加する。
    -- LSP や treesitter がバッファにattachされるのが自動的に防止される。
    bigfile = { enabled = true },
    -- ダッシュボード
    dashboard = {
      -- need install colorscript
      -- https://gitlab.com/dwt1/shell-color-scripts
      width = 130,
      preset = {
        --ランダムなロゴを表示する
        header = tool_logo.random_logo(),
      },
      sections = {
        -- ヘッダ
        { section = "header" },
        -- ファイルアクセス
        { section = "keys", gap = 1, padding = 1 },
        -- GitHubをBrowserで開く
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          -- gh コマンドの存在確認
          local gh_available = vim.fn.executable("gh") == 1
          if not gh_available then
            return {}
          end
          -- ネットワーク接続チェック（オプション）
          -- local is_online = vim.fn.system("ping -c 1 github.com 2>/dev/null"):find("1 received") ~= nil

          local cmds = {
            -- GitHubアカウントの最新5件の通知を表示
            -- {
            --   title = "Notifications",
            --   cmd = "gh notify -s -a -n5",
            --   action = function()
            --     vim.ui.open("https://github.com/notifications")
            --   end,
            --   key = "N",
            --   icon = " ",
            --   height = 5,
            --   enabled = in_git and gh_available,
            -- },
            -- ローカルリポジトリの差分状況を表示
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
              enabled = in_git and gh_available,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = cmd.enabled or false,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        -- { section = "startup" },
      },
    },
    -- ファイルエクスプローラ
    explorer = {
      -- replace netrw with the snacks explorer
      replace_netrw = true,
      -- Use the system trash when deleting files
      trash = true,
    },
    -- gh  (GitHub CLI)
    gh = {
      keys = {
        select = { "<cr>", "gh_actions", desc = "アクションを選択" },
        edit = { "i", "gh_edit", desc = "編集" },
        comment = { "a", "gh_comment", desc = "コメント追加" },
        close = { "c", "gh_close", desc = "閉じる" },
        reopen = { "o", "gh_reopen", desc = "再開" },
      },
    },
    -- 画像ファイルを表示する
    -- NOTE: pngの表示に`ImageMagick`, mermaidの表示に`mmdc`, pdfの操作に`ghostscript`のインストールが必要
    -- `brew install imagemagick ghostscript` と `npm install -g @mermaid-js/mermaid-cli`を実行してください
    image = { enabled = true },
    -- インプットモードの表示
    input = { enabled = true },
    -- 通知
    notifier = {
      timeout = 3000,
      width = { min = 40, max = 0.5 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      gap = 0,
      sort = { "level", "added" },
      level = vim.log.levels.TRACE,
      -- compact | minimal | fancy
      style = "compact",
      top_down = true,
      date_format = "%H:%M:%S",
    },
    -- ファジーファインダー
    picker = {
      -- enabled = true,
      win = {
        input = {
          keys = {
            -- プレビューへフォーカスを移動
            ["<a-;>"] = { "cycle_win", mode = { "i", "n" } },
            ["<a-s>"] = { "flash", mode = { "n", "i" } },
            ["s"] = { "flash" },
          },
        },
      },
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                -- ["<c-t>"] = nil,
              },
            },
          },
        },
        gh_issue = {},
        gh_pr = {},
      },
    },
    -- プラグインをロードする前に内容をレンダリングする
    quickfile = { enabled = true },
    -- トグルキーマップ
    toggle = { enabled = true },
    terminal = { win = { style = "terminal" } },
    styles = {
      input = {
        backdrop = false,
        position = "float",
        border = "rounded",
        title_pos = "center",
        height = 1,
        width = 150,
        relative = "editor", -- "cursor" or "editor"
        row = 0.5,
        bo = {
          filetype = "snacks_input",
          buftype = "prompt",
        },
        b = { completion = true },
      },
      notification = {
        border = true,
        zindex = 100,
        ft = "markdown",
        wo = {
          winblend = 5,
          wrap = true,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "snacks_notif" },
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      "<leader>ff", -- File Find
      function()
        Snacks.picker.smart({
          multi = {
            "buffers",
            "recent",
            "files",
          },
          -- user `file` format for all sources
          format = "file",
          matcher = {
            -- boost cwd matches
            cwd_bounus = true,
            -- use frecency boosting
            frecency = false,
            -- sort even when the filter is empty
            sort_empty = true,
          },
          filter = { cwd = true },
          transform = "unique_file",
        })
      end,
      desc = "Snacks - スマートファイル検索から表示",
    },
    {
      "<leader>fg", -- File Grep
      function()
        Snacks.picker.grep({
          -- NOTE: <M-h> でトグルできる
          -- 隠しファイルも検索対象に含める
          hidden = true,
          -- NOTE: <M-i> でトグルできる
          -- 無視ファイルも検索対象に含める
          ignored = true,
          -- シンボリックリンクをたどる
          follow = false,
        })
      end,
      desc = "Snacks - Grep検索を表示",
    },
    -- {
    --   ";sbuf",
    --   function()
    --     Snacks.picker.buffers()
    --   end,
    --   desc = "Snacks - バッファリストを検索",
    -- },
    {
      ";sch", -- Search Command History
      function()
        Snacks.picker.command_history()
      end,
      desc = "Snacks - コマンド履歴を表示",
    },
    {
      ";nl", -- Notifications List
      function()
        Snacks.picker.notifications()
      end,
      desc = "Snacks - 通知履歴リストを検索",
    },
    {
      ";nh", -- Notifications History
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Snacks - 通知履歴を表示",
    },
    {
      "<leader>fe", -- File Explorer
      function()
        Snacks.picker.explorer()
      end,
      desc = "Snacks - ファイルエクスプローラを表示",
    },
    {
      "<F3>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Snacks - ターミナルを開く",
    },
    {
      "<F3>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Snacks - ターミナルを閉じる",
      mode = { "t" },
    },
    {
      "<F4>",
      function()
        Snacks.terminal.open()
      end,
      desc = "Snacks - 新しいターミナルを開く",
      mode = { "t" },
    },
    -- find
    -- { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim設定ファイルリストを表示" },
    -- git
    {
      ";sgl", -- Search Git Log
      function()
        Snacks.picker.git_log()
      end,
      desc = "Snacks - Git Logを表示",
    },
    {
      ";sgi", -- Search Git Issues
      function()
        Snacks.gh.issue()
      end,
      desc = "Snacks - GitHub Issueを検索",
    },
    {
      ";sgr", -- Search Git pull Request
      function()
        Snacks.gh.pr()
      end,
      desc = "Snacks - GitHub Pull Requestを検索",
    },
    -- Grep
    {
      "<leader>sw", -- Search Word
      function()
        Snacks.picker.grep_word()
      end,
      mode = { "n", "x" },
      desc = "Snacks - Visual Mode で選択した単語でGrep検索",
    },
    -- search
    {
      ";srg", -- Search Register
      function()
        Snacks.picker.registers()
      end,
      desc = "Snacks - レジスタを検索",
    },
    -- {
    --   ";s/",
    --   function()
    --     Snacks.picker.search_history()
    --   end,
    --   desc = "Snacks - 検索履歴を検索",
    -- },
    {
      ";scm", -- Search Command
      function()
        Snacks.picker.commands()
      end,
      mode = { "n" },
      desc = "Snacks - Commandを検索",
    },
    -- {
    --   ";sd",
    --   function()
    --     Snacks.picker.diagnostics()
    --   end,
    --   desc = "Snacks - LSP診断を検索",
    -- },
    -- {
    --   ";sD",
    --   function()
    --     Snacks.picker.diagnostics_buffer()
    --   end,
    --   desc = "Snacks - バッファ内のLSP診断を検索",
    -- },
    {
      ";shelp", -- Search HELP
      function()
        Snacks.picker.help()
      end,
      desc = "Snacks - ヘルプページを検索",
    },
    {
      ";sic", -- Search ICon
      function()
        Snacks.picker.icons()
      end,
      desc = "Snacks - Iconを検索",
    },
    {
      ";sjl", -- Search Jump List
      function()
        Snacks.picker.jumps()
      end,
      desc = "Snacks - ジャンプリストを検索",
    },
    {
      ";skm", -- Search KeyMap
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Snacks - Keymapリストを検索",
    },
    {
      ";sl", -- Search Location List
      function()
        Snacks.picker.loclist()
      end,
      desc = "Snacks - Location リストを検索",
    },
    {
      ";sM",
      function()
        Snacks.picker.man()
      end,
      desc = "Snacks - Man ページを検索",
    },
    {
      ";spl",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Snacks - Neovimプラグイン設定を検索",
    },
    {
      ";sqf",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Snacks - Quickfix リストを検索",
    },
    -- {
    --   ";sud",
    --   function()
    --     Snacks.picker.undo()
    --   end,
    --   desc = "Snacks - Undo 履歴を検索",
    -- },
    -- LSP
    -- {
    --   "<leader>ss",
    --   function()
    --     Snacks.picker.lsp_symbols()
    --   end,
    --   desc = "Snacks - バッファ内の LSP シンボルを検索",
    -- },
    -- {
    --   "<leader>sS",
    --   function()
    --     Snacks.picker.lsp_workspace_symbols()
    --   end,
    --   desc = "Snacks - ワークスペース内の LSP シンボルを検索",
    -- },
    -- Other
    --{
    --  "<leader>z",
    --  function()
    --    Snacks.zen()
    --  end,
    --  desc = "Snacks - Zen モードをトグル",
    --},
    {
      "<leader>dd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Snacks - バッファを閉じる",
    },
    -- {
    --   "<leader>gB",
    --   function()
    --     Snacks.gitbrowse()
    --   end,
    --   desc = "Snacks - リポジトリをGitHubで開く",
    --   mode = { "n", "v" },
    -- },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Snacks - Lazygitを起動",
    },
    {
      "<leader>gq",
      function()
        Snacks.terminal({ "lazysql" })
      end,
      desc = "Snacks - Lazysqlを起動",
    },
    {
      "<leader>gs",
      function()
        Snacks.terminal({ "slumber" })
      end,
      desc = "Snacks - Slumber(HTTPクライアント)を起動",
    },
    --{
    --  "]]",
    --  function()
    --    Snacks.words.jump(vim.v.count1)
    --  end,
    --  desc = "Snacks - Next Reference",
    --  mode = { "n", "t" },
    --},
    --{
    --  "[[",
    --  function()
    --    Snacks.words.jump(-vim.v.count1)
    --  end,
    --  desc = "Snacks - Prev Reference",
    --  mode = { "n", "t" },
    --},
  },
}
