-- Github Review を行えるプラグイン
if not vim.g.vscode then
  return {
    {
      "pwntester/octo.nvim",
      enabled = false,
      -- dependencies = {
        -- { "nvim-telescope/telescope.nvim" },
        -- { "nvim-tree/nvim-web-devicons" },
      -- },
      config = function()
        require("octo").setup({
          suppress_missing_scope = {
            projects_v2 = true,
          }
        })
      end,
    },
  }
else
  return {}
end
