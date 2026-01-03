-- Github Review を行えるプラグイン
return {
  {
    "pwntester/octo.nvim",
    enabled = true,
    cmd = { "Octo" },
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      local wk = require("which-key")
      wk.add({
        { ";sgi", "<cmd>Octo issue search<CR>", mode = { "n" }, icon = "", desc = "GitHub Issueを探す" },
        { ";sgp", "<cmd>Octo pr search<CR>", mode = { "n" }, icon = "", desc = "GitHub Pull Requestを探す" },
      })
    end,
    config = function()
      local palette = require("onedarkpro.helpers").get_colors()
      require("octo").setup({
        picker = "snacks", -- "telescope" or "fzf-lua"
        suppress_missing_scope = {
          projects_v2 = true,
        },
        colors = {
          white = palette.fg,
          grey = palette.grey,
          black = palette.black,
          red = palette.red,
          dark_red = palette.git_hunk_delete_inline,
          green = palette.green,
          dark_green = palette.diff_add,
          yellow = palette.yellow,
          dark_yellow = palette.git_change,
          blue = palette.blue,
          dark_blue = palette.diff_text,
          purple = palette.purple,
        },
      })
    end,
  },
}
