-- ファイル・フォーマットを自動実行できるようにするプラグイン
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
      javascript = { "biome-check" },
      typescript = { "biome-check", "biome-organize-imports" },
      typescriptreact = { "biome-check", "biome-organize-imports" },
      svelte = { "biome-check", "biome-organize-imports" },
      html = { "biome-check" },
      http = { "kulala-fmt" },
      css = { "biome-check" },
      json = { "jq" },
      markdown = { "markdownlint" },
      obsidian_markdown = { "markdownlint" },
      toml = { "tombi" },
      terraform = { "terraform_fmt" },
      yaml = { "yamlfmt" },
      yaml_github = { "yamlfmt" },
      dart = { "dcm_fix", "dcm_format" },
      go = { "gofumpt", "goimports" },
      -- ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      ["markdownlint"] = {
        append_args = {
          "--config",
          "~/.config/markdownlint/.markdownlint.jsonc",
        },
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    -- Formatがエラー時に通知する
    notify_on_error = true,
    -- 利用可能なフォーマッターを通知する
    notify_no_formatters = true,
  },
}
