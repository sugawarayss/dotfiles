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
local file_patterns = {
  "*.sh", -- bash
  "*.c", -- c
  "*.cs", -- c_sharp
  "*.cpp", -- cpp
  "*.cc",
  "*.cxx",
  "*.css", -- css
  "*.csv", -- csv
  "*.dart", -- dart
  "*.diff", -- diff
  "*.patch",
  "Dockerfile", -- dockerfile
  "*.dockerfile",
  "*.dot", -- dot
  "*.ex", -- elixir
  "*.exs",
  "*.elm", -- elm
  "*.erl", -- erlang
  "*.hrl",
  ".gitconfig", -- git_config
  "git-rebase-todo", -- git_rebase
  "COMMIT_EDITMSG", -- gitcommit
  ".gitignore", -- gitignore
  "*.go", -- go
  "go.mod", -- gomod
  "go.sum", -- gosum
  "*.graphql", -- graphql
  "*.gql",
  "*.hs", -- haskell
  "*.html", -- html
  "*.htm",
  "*.django", -- htmldjango
  "*.http", -- http
  "*.ini", -- ini
  "*.java", -- java
  "*.js", -- javascript
  "*.mjs",
  "*.jl", -- julia
  "*.kdl", -- kdl
  "*.kt", -- kotlin
  "*.kts",
  "*.lua", -- lua
  "*.md", -- markdown
  "*.markdown",
  "*.mermaid", -- mermaid
  "*.ml", -- ocaml
  "*.mli",
  "*.pl", -- perl
  "*.pm",
  "*.php", -- php
  "*.py", -- python
  "*.pyi",
  "*.pyw",
  "requirements.txt", -- requirements
  "*.rst", -- rst
  "*.rb", -- ruby
  "*.rs", -- rust
  "*.scala", -- scala
  "*.sc",
  "*.scm", -- scheme
  "*.ss",
  "*.sql", -- sql
  "*.svelte", -- svelte
  "*.swift", -- swift
  "*.tf", -- terraform
  "*.tfvars",
  "*.tsx", -- tsx
  "*.toml", -- toml
  "*.ts", -- typescript
  "*.vim", -- vim
  "*.txt", -- vimdoc (help files)
  "*.vue", -- vue
  "*.xml", -- xml
  "*.yml", -- yaml
  "*.yaml",
  "*.zig", -- zig
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
        -- ~/.local/share/nvim/treesitter
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
      vim.api.nvim_create_autocmd("FileType", {
        -- pattern = parsers,
        pattern = file_patterns, -- FileType用
        callback = function(ctx)
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      -- HACK: copilotの提案する方法
      -- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      --   pattern = "*",
      --   callback = function(ctx)
      --     -- パーサーが存在する場合のみ実行
      --     local ft = vim.bo.filetype
      --     if vim.tbl_contains(parsers, ft) then
      --       pcall(vim.treesitter.start)
      --       vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      --     end
      --   end,
      -- })
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
