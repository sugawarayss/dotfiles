-- ファイル・フォーマットを自動実行できるようにするプラグイン
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = function()
    -- 自動でフォーマットと実行する
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
        vim.notify("Conform.nvim run Format!")
      end,
    })
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        javascript = { "biome-check" },
        typescript = { "biome-check", "biome-organize-imports" },
        typescriptreact = { "biome-check", "biome-organize-imports" },
        html = { "biome-check" },
        css = { "biome-check" },
        json = { "jq" },
        markdown = { "markdownlint-cli2" },
        obsidian_markdown = { "markdownlint-cli2" },
        toml = { "tombi" },
        terraform = { "terraform_fmt" },
        yaml = { "yamlfmt" },
        yaml_github = { "yamlfmt" },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        ["markdownlint-cli2"] = {
          append_args = { "--config", "HOME/.config/markdownlint/.markdownlint-cli2.jsonc" },
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      format_after_save = {
        lsp_format = "fallback",
      },
      -- Formatがエラー時に通知する
      notify_on_error = true,
      -- 利用可能なフォーマッターを通知する
      notify_no_formatters = true,
    })
    -- require("conform").formatters.ruff_fix = {
    --   append_args = {
    --     "--config",
    --     "pyproject.toml",
    --   },
    -- }
    -- require("conform").formatters.ruff_format = {
    --   append_args = {
    --     "--config",
    --     "pyproject.toml",
    --   },
    -- }
    -- require("conform").formatters.ruff_organize_imports = {
    --   append_args = {
    --     "--config",
    --     "pyproject.toml",
    --   },
    -- }

    -- require("conform").formatters.stylua = {
    --   prepend_args = {
    --     "--config-path",
    --     vim.fn.expand("~/.config/nvim/lua/plugins/stylua.toml"),
    --   },
    --   stdin = true,
    -- }
  end,
}
