local tool_logo = require("tool_logo")
if not vim.g.vscode then
  return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          -- Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ul")
          Snacks.toggle.diagnostics():map("<leader>ud")
          -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          -- Snacks.toggle.treesitter():map("<leader>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          -- Snacks.toggle.indent():map("<leader>ug")
          -- Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
    opts = {
      -- アニメーションライブラリ
      animate = {
        enabled  = true,
        duration = 20,
        easing   = "linear",
        fps      = 60,
      },
      -- 指定のサイズより大きいファイルを開いたときにattach されるfiletypeを追加する。
      -- LSP や treesitter がバッファにattachされるのが自動的に防止される。
      bigfile = {
        enabled     = true,
        notify      = true,
        size        = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 1000,

      },
      -- debug用の設定
      debug = { enabled = false },
      -- ダッシュボード
      dashboard = {
        enabled = true,
        -- need install colorscript
        -- https://gitlab.com/dwt1/shell-color-scripts
        width = 117,
        preset = {
          --ランダムなロゴを表示する
          header = tool_logo.random_logo(),
        },
        sections = {
          { section = "header" },
          -- TODO: telescopeを使うようにする?
          { section = "keys", gap = 1, padding = 1 },
          {
            pane    = 2,
            icon    = " ",
            desc    = "Browse Repo",
            padding = 1,
            key     = "b",
            action  = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title   = "Notifications",
                cmd     = "gh notify -s -a -n5",
                action  = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                key     = "N",
                icon    = " ",
                height  = 5,
                enabled = true,
              },
              {
                title  = "Open Issues",
                cmd    = "gh issue list -L 3",
                key    = "I",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon   = " ",
                height = 7,
              },
              {
                icon   = " ",
                title  = "Open PRs",
                cmd    = "gh pr list -L 3",
                key    = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
              },
              {
                icon   = " ",
                title  = "Git Status",
                cmd    = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane    = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl     = 5 * 60,
                indent  = 3,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
      -- カーソルのあるスコープ以外を暗く表示する
      dim = { enabled = false },
      -- ファイルエクスプローラ
      explorer = {
        enabled = true,
        actions = {
          safe_delete = function(picker)
            local selected = picker:selected { fallback = true }
            local has_root = vim.iter(selected):any(function(s)
              return not s.parent
            end)
            if has_root then
              vim.print("Cannot delete root directory")
              return
            end
            picker:action "explorer_del"
          end,
        },
        win = {
          list = {
            keys = {
              ["<c-t>"] = nil,
              ["d"] = "safe_delete",
            }
          }
        },
      },
      -- アクティブファイルのリポジトリを開く
      gitbrowse = { enabled = false },
      -- 画像ファイルを表示する
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
      indent = { enabled = false },
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
      layout = { enabled = true },
      -- lazygit の表示
      lazygit = { enabled = false },
      -- 通知
      notifier = { enabled = true },
      -- ファジーファインダー
      picker = {
        enabled = true,
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["<c-t>"] = nil,
                }
              }
            },
          }
        }
      },
      -- Luaプロファイラ
      profiler = { enabled = true },
      -- プラグインをロードする前に内容をレンダリングする
      quickfile = { enabled = true },
      -- スコープ検出
      scope = { enabled = true },
      scratch = { enabled = false },
      -- スムーズなスクロール
      scroll = { enabled = false },
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
        }
      },
      words = {
        enabled = true,
        debounce = 200,
        notify_jump = false,
        notify_end = true,
        foldopen = true,
        jumplist = true,
        modes = { "n", "i", "c" },
        filter = function(buf)
          return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
        end
      },
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><leader>", function() Snacks.picker.smart() end,                 desc = "スマートファイル検索から表示" },
      { "<leader>,",        function() Snacks.picker.buffers() end,               desc = "バッファリストを表示" },
      { "<F4>",             function() Snacks.picker.grep() end,                  desc = "ファイル内容から表示" },
      { "<leader>:",        function() Snacks.picker.command_history() end,       desc = "コマンド履歴を表示" },
      { "<leader>n",        function() Snacks.picker.notifications() end,         desc = "通知履歴を表示" },
      { "<C-t><C-t>",       function() Snacks.picker.explorer() end,              desc = "ファイルエクスプローラを表示" },
      -- find
      { "<leader>fb",       function() Snacks.picker.buffers() end,               desc = "バッファリストを表示" },
      -- { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim設定ファイルリストを表示" },
      { "<leader>ff",       function() Snacks.picker.files() end,                 desc = "ファイル名リストを表示" },
      { "<leader>fr",       function() Snacks.picker.recent() end,                desc = "直近開いたファイルリストを表示" },
      -- git
      { "<leader>gb",       function() Snacks.picker.git_branches() end,          desc = "Gitブランチリストを表示" },
      { "<leader>gl",       function() Snacks.picker.git_log() end,               desc = "Git Logを表示" },
      -- Grep
      { "<leader>sw",       function() Snacks.picker.grep_word() end,             desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"',       function() Snacks.picker.registers() end,             desc = "レジスタを検索" },
      { '<leader>s/',       function() Snacks.picker.search_history() end,        desc = "検索履歴を検索" },
      { "<leader>sa",       function() Snacks.picker.autocmds() end,              desc = "Autocmds" },
      -- { "Q",                function() Snacks.picker.commands() end,              desc = "Commandを検索" },
      { "<leader>sd",       function() Snacks.picker.diagnostics() end,           desc = "LSP診断を検索" },
      { "<leader>sD",       function() Snacks.picker.diagnostics_buffer() end,    desc = "バッファ内のLSP診断を検索" },
      { "<leader>sh",       function() Snacks.picker.help() end,                  desc = "ヘルプページを検索" },
      { "<leader>si",       function() Snacks.picker.icons() end,                 desc = "Iconを検索" },
      { "<leader>sj",       function() Snacks.picker.jumps() end,                 desc = "Jumps" },
      { "<leader>skm",      function() Snacks.picker.keymaps() end,               desc = "Keymapリストを検索" },
      { "<leader>sl",       function() Snacks.picker.loclist() end,               desc = "Location List" },
      { "<leader>sM",       function() Snacks.picker.man() end,                   desc = "Man ページを検索" },
      { "<leader>sp",       function() Snacks.picker.lazy() end,                  desc = "Neovimプラグイン設定を検索" },
      { "<leader>sq",       function() Snacks.picker.qflist() end,                desc = "Quickfix リストを検索" },
      { "<leader>su",       function() Snacks.picker.undo() end,                  desc = "Undo 履歴を検索" },
      -- LSP
      { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols"},
      { "<leader>sS",       function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",        function() Snacks.zen() end,                          desc = "Zen モードをトグル" },
      { "<leader>n",        function() Snacks.notifier.show_history() end,        desc = "通知履歴を表示" },
      { "<leader>bd",       function() Snacks.bufdelete() end,                    desc = "バッファを閉じる" },
      { "<leader>gB",       function() Snacks.gitbrowse() end,                    desc = "リポジトリをGitHubで開く", mode = { "n", "v" } },
      { "<leader>gg",       function() Snacks.lazygit() end,                      desc = "Lazygitを起動" },
      { "<leader>un",       function() Snacks.notifier.hide() end,                desc = "全ての通知を却下する" },
      { "<c-_>",            function() Snacks.terminal() end,                     desc = "which_key_ignore" },
      { "]]",               function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference", mode = { "n", "t" } },
      { "[[",               function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference", mode = { "n", "t" } },
    },
  }
else
  return {}
end
