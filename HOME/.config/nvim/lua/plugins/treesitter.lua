require("nvim-treesitter.configs").setup {
    ensure_installed = { "bash", "c", "css", "go", "java", "json", "kotlin", "lua", "markdown", "ruby", "php", "python", "rust" },
    auto_install = true,
    highlight = {
        enable = true,
    },
    matchup = {
        enable= true,
    }
}
