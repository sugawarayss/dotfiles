require("nvim-treesitter.configs").setup {
    ensure_installed = { "bash", "c", "css", "dockerfile", "go", "java", "json", "kotlin", "lua", "markdown", "ruby", "php", "python", "rust" },
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
      enable = true, --言語に応じた自動インデント
      disable = { "html" }, --htmlだけ自動インデントしない
    },
    matchup = {
        enable= true,
    }
}
