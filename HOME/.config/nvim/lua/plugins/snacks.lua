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
    -- アニメーションライブラリ
    animate = {
      enabled = vim.fn.has("nvim-0.10") == 1,
      style = "out",
      easing = "linear",
      duration = {
        step = 20, -- ms per step
        total = 1000, -- maximum duration
      },
    },
    animate_repeat = {
      delay = 100,
      duration = {
        step = 20,
        total = 1000,
        easing = "linear",
      },
    },
    -- 指定のサイズより大きいファイルを開いたときにattach されるfiletypeを追加する。
    -- LSP や treesitter がバッファにattachされるのが自動的に防止される。
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5MB
      line_length = 1000,
    },
    -- debug用の設定
    debug = { enabled = false },
    -- ダッシュボード
    dashboard = {
      enabled = true,
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
            {
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "N",
              icon = " ",
              height = 5,
              enabled = in_git and gh_available,
            },
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
    -- カーソルのあるスコープ以外を暗く表示する
    dim = { enabled = false },
    -- ファイルエクスプローラ
    explorer = {
      enabled = true,
      actions = {
        safe_delete = function(picker)
          local selected = picker:selected({ fallback = true })
          local has_root = vim.iter(selected):any(function(s)
            return not s.parent
          end)
          if has_root then
            vim.print("Cannot delete root directory")
            return
          end
          picker:action("explorer_del")
        end,
      },
      win = {
        list = {
          keys = {
            ["<c-t>"] = nil,
            ["d"] = "safe_delete",
          },
        },
      },
    },
    -- gh  (GitHub CLI)
    gh = { enabled = true },
    -- アクティブファイルのリポジトリを開く
    gitbrowse = { enabled = false },
    -- 画像ファイルを表示する
    -- NOTE: pngの表示に`ImageMagick`, mermaidの表示に`mmdc`, pdfの操作に`ghostscript`のインストールが必要
    -- `brew install imagemagick ghostscript` と `npm install -g @mermaid-js/mermaid-cli`を実行してください
    image = {
      enabled = true,
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
      },
      force = false,
      doc = {
        enabled = true,
        inline = true,
        float = true,
        max_width = 80,
        max_height = 40,
        conceal = false,
      },
      img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
      wo = {
        wrap = false,
        number = false,
        relativenumber = false,
        cursorcolumn = false,
        signcolumn = "no",
        foldcolumn = "0",
        list = false,
        spell = false,
        statuscolumn = "",
      },
      cache = vim.fn.stdpath("cache") .. "/snacks/image",
      debug = {
        request = false,
        convert = false,
        placement = false,
      },
      env = {},
      convert = {
        notify = true, -- show a notification on error
        mermaid = function()
          local theme = vim.o.background == "light" and "neutral" or "dark"
          return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
        end,
        magick = {
          default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
          vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
          math = { "-density", 192, "{src}[0]", "-trim" },
          pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
        },
      },
      math = {
        enabled = true, -- enable math expression rendering
        typst = {
          tpl = [[
              #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
              #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
              #set text(size: 12pt, fill: rgb("${color}"))
              ${header}
              ${content}]],
        },
        latex = {
          font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
          packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
          tpl = [[
              \documentclass[preview,border=2pt,varwidth,12pt]{standalone}
              \usepackage{${packages}}
              \begin{document}
              ${header}
              { \${font_size} \selectfont
                \color[HTML]{${color}}
              ${content}}
              \end{document}]],
        },
      },
    },
    -- インデントガイドの表示
    indent = {
      priority = 1,
      enabled = true,
      char = "│",
      only_scope = false,
      only_current = false,
      hl = "SnacksIndent",
    },
    -- インプットモードの表示
    input = {
      enabled = true,
      icon = " ",
      icon_hl = "SnacksInputIcon",
      icon_pos = "left",
      prompt_pos = "title",
      win = { style = "input" },
      expand = true,
    },
    -- レイアウト
    layout = { enabled = false },
    -- lazygit の表示
    lazygit = { enabled = false },
    -- 通知
    notifier = {
      enabled = true,
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
      enabled = true,
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
      actions = {
        flash = function(picker)
          require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                end,
              },
            },
            action = function(match)
              local idx = picker.list:row2idx(match.pos[1])
              picker.list:_move(idx, true, true)
            end,
          })
        end,
      },
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["<c-t>"] = nil,
              },
            },
          },
        },
      },
    },
    -- Luaプロファイラ
    profiler = { enabled = true },
    -- プラグインをロードする前に内容をレンダリングする
    quickfile = { enabled = true },
    -- スコープ検出
    scope = {
      enabled = true,
      priority = 200,
      char = "│",
      underline = false,
      only_current = false,
      hl = "SnacksIndentScope",
    },
    chunk = {
      -- when enabled, scopes will be rendered as chunks, except for the
      -- top-level scope which will be rendered as a scope.
      enabled = false,
      -- only show chunk scopes in the current window
      only_current = false,
      priority = 200,
      hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
      char = {
        -- corner_top = "┌",
        -- corner_bottom = "└",
        corner_top = "╭",
        corner_bottom = "╰",
        horizontal = "─",
        vertical = "│",
        arrow = ">",
      },
    },
    scratch = { enabled = false },
    -- スムーズなスクロール
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    -- トグルキーマップ
    toggle = {
      enabled = true,
      map = vim.keymap.set,
      which_key = true,
      notify = true,
      icon = {
        enabled = " ",
        disabled = " ",
      },
      -- colors for enabled/disabled states
      color = {
        enabled = "green",
        disabled = "yellow",
      },
      wk_desc = {
        enabled = "Disable ",
        disabled = "Enable ",
      },
    },
    terminal = {
      bo = { filetype = "snacks_terminal" },
      wo = {},
      keys = {
        q = "hide",
        gf = function(self)
          local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
          if f == "" then
            Snacks.notify.warn("No file under cursor")
          else
            self:hide()
            vim.schedule(function()
              vim.cmd("e " .. f)
            end)
          end
        end,
        term_normal = {
          "<esc>",
          function(self)
            self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
            if self.esc_timer:is_active() then
              self.esc_timer:stop()
              vim.cmd("stopinsert")
            else
              self.esc_timer:start(200, 0, function() end)
              return "<esc>"
            end
          end,
          mode = "t",
          expr = true,
          desc = "Double escape to normal mode",
        },
      },
    },
    words = {
      enabled = false,
      debounce = 200,
      notify_jump = false,
      notify_end = true,
      foldopen = true,
      jumplist = true,
      modes = { "n", "i", "c" },
      filter = function(buf)
        return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
      end,
    },
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
      "<leader><leader>",
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
      desc = "スマートファイル検索から表示",
    },
    {
      "<F5>",
      function()
        Snacks.picker.grep({
          -- NOTE: <M-h> でトグルできる
          -- 隠しファイルも検索対象に含める
          hidden = true,
          -- NOTE: <M-i> でトグルできる
          -- 無視ファイルも検索対象に含める
          ignored = false,
          -- シンボリックリンクをたどる
          follow = false,
        })
      end,
      desc = "Grep検索を表示",
    },
    -- {
    --   "<leader>ff",
    --   function()
    --     Snacks.picker.files()
    --   end,
    --   desc = "ファイル名リストを検索",
    -- },
    -- {
    --   "<leader>fr",
    --   function()
    --     Snacks.picker.recent()
    --   end,
    --   desc = "直近開いたファイルリストを表示",
    -- },
    {
      ";sbuf",
      function()
        Snacks.picker.buffers()
      end,
      desc = "バッファリストを検索",
    },
    {
      ";sch",
      function()
        Snacks.picker.command_history()
      end,
      desc = "コマンド履歴を表示",
    },
    {
      ";nl",
      function()
        Snacks.picker.notifications()
      end,
      desc = "通知履歴リストを検索",
    },
    {
      ";nh",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "通知履歴を表示",
    },
    {
      "<leader>fe",
      function()
        Snacks.picker.explorer()
      end,
      desc = "ファイルエクスプローラを表示",
    },
    {
      "<F3>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "ターミナルを開く",
    },
    {
      "<F3>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "ターミナルを閉じる",
      mode = { "t" },
    },
    -- find
    -- { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim設定ファイルリストを表示" },
    -- git
    {
      ";sgl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Logを表示",
    },
    {
      ";sgi",
      function()
        Snacks.gh.issue()
      end,
      desc = "GitHub Issueを検索",
    },
    {
      ";sgr",
      function()
        Snacks.gh.pr()
      end,
      desc = "GitHub Pull Requestを検索",
    },
    -- Grep
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      mode = { "n", "x" },
      desc = "Visual Mode で選択した単語でGrep検索",
    },
    -- search
    {
      ";srg",
      function()
        Snacks.picker.registers()
      end,
      desc = "レジスタを検索",
    },
    {
      ";s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "検索履歴を検索",
    },
    {
      ";scm",
      function()
        Snacks.picker.commands()
      end,
      mode = { "n" },
      desc = "Commandを検索",
    },
    {
      ";sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "LSP診断を検索",
    },
    {
      ";sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "バッファ内のLSP診断を検索",
    },
    {
      ";shelp",
      function()
        Snacks.picker.help()
      end,
      desc = "ヘルプページを検索",
    },
    {
      ";sic",
      function()
        Snacks.picker.icons()
      end,
      desc = "Iconを検索",
    },
    {
      ";sjl",
      function()
        Snacks.picker.jumps()
      end,
      desc = "ジャンプリストを検索",
    },
    {
      ";skm",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymapリストを検索",
    },
    {
      ";sl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location リストを検索",
    },
    {
      ";sM",
      function()
        Snacks.picker.man()
      end,
      desc = "Man ページを検索",
    },
    {
      ";spl",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Neovimプラグイン設定を検索",
    },
    {
      ";sqf",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix リストを検索",
    },
    {
      ";sud",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo 履歴を検索",
    },
    -- LSP
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "バッファ内の LSP シンボルを検索",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "ワークスペース内の LSP シンボルを検索",
    },
    -- Other
    --{
    --  "<leader>z",
    --  function()
    --    Snacks.zen()
    --  end,
    --  desc = "Zen モードをトグル",
    --},
    {
      "<leader>dd",
      function()
        Snacks.bufdelete()
      end,
      desc = "バッファを閉じる",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "リポジトリをGitHubで開く",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit(Gitクライアント)を起動",
    },
    {
      "<leader>gq",
      function()
        Snacks.terminal({ "lazysql" })
      end,
      desc = "Lazysql(SQLクライアント)を起動",
    },
    {
      "<leader>gs",
      function()
        Snacks.terminal({ "slumber" })
      end,
      desc = "Slumber(HTTPクライアント)を起動",
    },
    --{
    --  "]]",
    --  function()
    --    Snacks.words.jump(vim.v.count1)
    --  end,
    --  desc = "Next Reference",
    --  mode = { "n", "t" },
    --},
    --{
    --  "[[",
    --  function()
    --    Snacks.words.jump(-vim.v.count1)
    --  end,
    --  desc = "Prev Reference",
    --  mode = { "n", "t" },
    --},
  },
}
