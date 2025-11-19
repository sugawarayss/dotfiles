-- 構文解析プラグイン
local augroup = vim.api.nvim_create_augroup("nvim-treesitter-auto", { clear = true })
-- ~/.local/share/nvim/treesitter
local treesitter_path = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter")
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    branch = "main",
    build = function()
      -- update installed parsers and then install missing ones
      local ok, err = pcall(function()
        local ts = require("nvim-treesitter")
        ts.update():await(function()
          local installed = ts.get_installed()
          local missing = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(installed, lang)
          end, ts.get_available())
          ts.install(missing)
        end)
      end)
      if not ok then
        vim.notify(err or "failed to update parsers", vim.log.levels.ERROR, { title = "nvim-treesitter" })
      end
    end,
    init = function()
      -- 自動ハイライトの有効化
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(ctx)
          local filetype = ctx.match

          -- treesitter tmux highlighting looks ugly...
          -- only install parser
          if filetype == "tmux" then
            if not vim.tbl_contains(require("nvim-treesitter").get_installed(), "tmux") then
              require("nvim-treesitter").install("tmux")
            end
            return
          end

          require("nvim-treesitter")
          local ok = pcall(vim.treesitter.start, ctx.buf)
          if ok then
            return
          end

          -- on fail, retry after installing the parser
          local lang = vim.treesitter.language.get_lang(filetype)
          require("nvim-treesitter").install({ lang }):await(function(err)
            if err then
              vim.notify(err, vim.log.levels.ERROR, { title = "nvim-treesitter" })
            end
            pcall(vim.treesitter.start, ctx.buf)
          end)
        end,
      })
    end,
    config = function()
      require("nvim-treesitter").setup({
        -- install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter"),
        install_dir = treesitter_path,
      })
      -- register parsers to some other languages
      vim.treesitter.language.register("bash", "zsh")
      vim.treesitter.language.register("bash", "sh")
      vim.treesitter.language.register("yaml", "yaml_github")
      -- custom highlights
      -- local function hi()
      --   vim.api.nvim_set_hl(0, "@illuminate", { link = "LspReferenceTarget" })
      -- end

      -- hi()
      -- vim.api.nvim_create_autocmd("ColorScheme", { group = vim.api.nvim_create_augroup("nvim-treesitter-customize", {}), callback = hi })
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
}
