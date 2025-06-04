return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = function()
    -- 自動でフォーマットと実行する
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
        javascript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "jq" },
        markdown = { "markdownlint" },
        toml = { "taplo" },
        terraform = { "terraform_fmt" },
        typescript = { "biome" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
    -- require("conform").formatters.stylua = {
    --   prepend_args = {
    --     "--config-path",
    --     vim.fn.expand("~/.config/nvim/lua/plugins/stylua.toml"),
    --   },
    --   stdin = true,
    -- }
  end,
}
