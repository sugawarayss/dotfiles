-- コードとテストコードのファイルを行き来できるプラグイン
return {
  {
    "rgroli/other.nvim",
    enabled = true,
    cmd = {
      "Other",
      "OtherTabNew",
      "OtherSplit",
      "OtherVSplit",
    },
    config = function()
      require("other-nvim").setup({
        mappings = {
          "laravel",
          "golang",
          "react",
          "rust",
          "python",
          -- {
          --   pattern = "(.*)/.*.py$",
          --   target = "tests/**/test_%1.py",
          -- },
        },
        style = {
          border = "rounded",
          seperator = "|",
        },
      })
    end,
  },
}
