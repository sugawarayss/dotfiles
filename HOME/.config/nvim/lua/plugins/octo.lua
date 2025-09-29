-- Github Review を行えるプラグイン
if not vim.g.vscode then
  return {
    {
      "pwntester/octo.nvim",
      enabled = true,
      event = { "VeryLazy" },
      init = function()
        local wk = require("which-key")
        wk.add({
          { ";sgi", "<cmd>Octo issue search<CR>", mode = { "n" }, icon = "", desc = "GitHub Issueを探す" },
          { ";sgp", "<cmd>Octo pr search<CR>", mode = { "n" }, icon = "", desc = "GitHub Pull Requestを探す" },
        })
      end,
      config = function()
        require("octo").setup({
          picker = "snacks", -- "telescope" or "fzf-lua"
          suppress_missing_scope = {
            projects_v2 = true,
          },
        })
      end,
    },
  }
else
  return {}
end
