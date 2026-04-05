-- 非同期リンタープラグイン
return {
  "mfussenegger/nvim-lint",
  ft = {
    "bash",
    "python",
    "json",
    "fish",
    "markdown",
    "lua",
    "yaml",
    "yaml_github",
    "dockerfile",
    "php",
    "perl",
    "ruby",
    "toml",
    "zsh",
  },
  config = function()
    local nvim_lint = require("lint")
    -- github actions の設定
    nvim_lint.linters.ghalint = {
      cmd = "ghalint",
      stdin = true,
      append_fname = true,
      args = { "run" },
      stream = "both",
      ignore_exitcode = true,
      env = nil,
      parser = function(output, _)
        local items = {}
        if output == "" then
          return items
        end
        local decoded = vim.json.decode(output) or {}
        -- local bufpath = vim.fn.expand("%:p")
        for _, _ in ipairs(decoded) do
          table.insert(items, {
            source = "ghalint",
            lnum,
          })
        end
      end,
    }

    -- luacheck の設定ファイルの指定
    nvim_lint.linters.luacheck.args = { "--config", "~/.config/nvim/.luarc.json" }
    -- markdownlint の設定ファイルの指
    nvim_lint.linters.markdownlint.args = {
      "--config",
      "~/.config/markdownlint/.markdownlint.jsonc",
    }
    -- markdownlint-cli2 の設定ファイルの指定
    -- nvim_lint.linters["markdownlint-cli2"].args = {
    --   "--config",
    --   "~/.config/markdownlint/.markdownlint-cli2.jsonc",
    -- }

    nvim_lint.linters_by_ft = {
      bash = { "bash" },
      -- python = { "mypy" },
      fish = { "fish" },
      markdown = { "markdownlint" },
      lua = { "luacheck" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      yaml_github = { "actionlint", "zizmor" }, --, "ghalint" },
      dockerfile = { "hadolint" },
      perl = { "perlcritic", "perlinports" },
      php = { "php", "phpstan" },
      ruby = { "ruby", "rubocop" },
      toml = { "tombi" },
      ["sh.env"] = { "dotenv_linter" },
      zsh = { "zsh" },
    }

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        require("lint").try_lint(
          -- コマンドが見つからない場合はエラーを無視する
          nil,
          { ignore_errors = false }
        )
      end,
    })
  end,
}
