-- 構文解析プラグイン
local parsers = {
  "bash",
  "c",
  "c_sharp",
  "cpp",
  "css",
  "csv",
  "dart",
  "diff",
  "dockerfile",
  "dot",
  "elixir",
  "elm",
  "erlang",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "graphql",
  "haskell",
  "html",
  "htmldjango",
  "http",
  "ini",
  "java",
  "javascript",
  "julia",
  "kdl",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "mermaid",
  "ocaml",
  "perl",
  "php",
  "python",
  "regex",
  "requirements",
  "rst",
  "ruby",
  "rust",
  "scala",
  "scheme",
  "sql",
  "svelte",
  "swift",
  "terraform",
  "tsx",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
  "zig",
}
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      -- 対応するキーワードや記号にジャンプできる
      {
        "andymass/vim-matchup",
        lazy = true,
        init = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
          vim.g.matchup_treesitter_enable_quotes = true
          vim.g.matchup_treesitter_disable_virtual_text = true
          vim.g.matchup_treesitter_include_match_words = true
        end,
      },
    },
    config = function()
      require("nvim-treesitter").setup({
        -- ~/.local/share/nvim/site
        install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter"),
      })
      require("nvim-treesitter").install(parsers, {
        force = false, -- force installation of already installed parsers
        generate = true, -- generate `parser.c` from `grammar.json` or `grammar.js` before compiling.
        max_jobs = 4, -- limit parallel tasks (useful in combination with {generate} on memory-limited systems).
        summary = false, -- print summary of successful and total operations for multiple languages.
      })
      vim.treesitter.language.register("yaml", "yaml_github")
      -- 自動ハイライトの有効化
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
        -- pattern = parsers,
        callback = function(ctx)
          pcall(vim.treesitter.start)
          -- vim.treesitter.start()
          -- インデントの有効化
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  -- 画面に収まりきらない関数名を上部に表示するプラグイン
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
    event = "BufReadPost",
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
        mode = "cursor", -- Line used to calculate context. Choices: "cursor", "topline"
        -- Separator between context and content. Should be a single character string, like "-".
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },
}
