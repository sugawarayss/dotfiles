-- SQL Client
if not vim.g.vscode then
  return {
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "pgsql" } },
      },
      cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
      init = function()
        -- TODO: プロジェクトごとにconnectionファイルを分ける
        vim.g.db_ui_use_nerd_fonts = 1
      end
    },
  }
else
  return {}
end
