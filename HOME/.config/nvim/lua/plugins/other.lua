-- コードとテストコードのファイルを行き来できるプラグイン
return {
  {
    "rgroli/other.nvim",
    --  カスタムパターンが上手く動作しないので、一旦無効化
    enabled = false,
    lazy = true,
    cmd = {
      "Other",
      "OtherTabNew",
      "OtherSplit",
      "OtherVSplit",
    },
    config = function()
      require("other-nvim").setup({
        mappings = {
          "livewire",
          "angular",
          "laravel",
          "rails",
          "golang",
          {
            pattern = "(.*).py$",
            target = "tests/test_%1.py",
          },
        },
        style = {
          border = "rounded",
          seperator = "|",
        },
      })
    end,
  },
}
