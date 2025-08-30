-- LinterやFormatterを統合するプラグイン
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  lazy = true,
  event = "LspAttach",
  config = function()
    local null_ls = require("null-ls")
    local sources = {
      -- markdown は nvim-lint
      null_ls.builtins.formatting.stylua.with({
        filetypes = { "lua" },
        extra_args = { "--config-path", "~/.config/nvim/stylua.toml" },
      }),
      -- Golang
      null_ls.builtins.formatting.gofumpt.with({
        filetypes = { "go" },
      }),
      null_ls.builtins.formatting.goimports.with({
        filetypes = { "go" },
      }),
      -- js/ts
      null_ls.builtins.formatting.biome.with({
        filetypes = { "javascript", "typescript", "jsx", "html", "css", "scss", "markdown" },
        extra_args = { "--config", "./biome.config.js" },
      }),
      -- json
      require("none-ls.formatting.jq"),
      null_ls.builtins.formatting.yamlfmt.with({
        filetypes = { "yaml" },
        extra_args = {
          -- see: https://github.com/google/yamlfmt/blob/main/docs/config-file.md#command
          -- indent
          indent = 2,
          -- 多数の空行は1行に整形する
          retain_line_breaks_single = true,
          -- 最大行長は150文字
          max_line_length = 150,
          -- 行末の空白を削除
          trim_trailing_whitespace = true,
        },
      }),
      -- shellscript
      null_ls.builtins.formatting.shfmt.with({
        filetypes = { "sh", "bash", "zsh" },
      }),
      -- fish
      null_ls.builtins.diagnostics.fish.with({ filetypes = { "fish" } }),
      -- dart
      -- null_ls.builtins.diagnostics.dcm.with({ filetypes = { "dart" } }),
      -- php
      null_ls.builtins.diagnostics.phpstan.with({ filetypes = { "php" } }),
      -- dockerfile
      -- null_ls.builtins.diagnostics.dockerls.with({ filetypes = { "dockerfile" } }),
      -- code security
      -- null_ls.builtins.diagnostics.gitleaks,
      -- null_ls.builtins.diagnostics.semgrep.with({
      --   args = { "--config", "auto", "-q", "--json", "--timeout", "0" },
      --   timeout = 15000,
      -- }),
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      debug = true,
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(client)
                  return client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
