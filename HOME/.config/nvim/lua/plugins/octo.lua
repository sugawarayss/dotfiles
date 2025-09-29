-- Github Review を行えるプラグイン
if not vim.g.vscode then
  return {
    {
      "pwntester/octo.nvim",
      enabled = true,
      cmd = { "Octo" },
      init = function()
        local wk = require("which-key")
        wk.add({
          { ";sgi", "<cmd>Octo issue search<CR>", mode = { "n" }, icon = "", desc = "GitHub Issueを探す" },
          { ";sgp", "<cmd>Octo pr search<CR>", mode = { "n" }, icon = "", desc = "GitHub Pull Requestを探す" },
        })
      end,
      config = function()
        local palette = require("onedark.colors")
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
            dark_red = palette.dark_red,
            green = palette.green,
            dark_green = palette.dark_cyan,
            yellow = palette.yellow,
            dark_yellow = palette.dark_yellow,
            blue = palette.blue,
            dark_blue = palette.diff_text,
            purple = palette.purple,
          },
        })
      end,
    },
  }
else
  return {}
end
