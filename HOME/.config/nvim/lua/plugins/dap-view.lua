return {
  "igorlfs/nvim-dap-view",
  cmd = {
    "DapViewOpen",
    "DapViewClose",
    "DapViewToggle",
    "DapViewWatch",
    "DapViewJump",
    "DapViewShow",
    "DapViewNavigate",
  },
  cond = function()
    return not vim.g.vscode
  end,
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<leader>db",
        ":DapViewToggle<CR>",
        mode = "n",
        icon = "🐞",
        desc = "DapView - デバッグコンソールの表示をトグル",
      },
    })
  end,
  config = function()
    require("dap-view").setup({
      winbar = {
        -- 表示するセクションの順番と内容を指定
        sections = { "scopes", "repl", "watches", "console", "exceptions", "breakpoints", "threads" },
        -- デフォルトで表示するセクションを指定
        default_section = "scopes",
        -- デバッガーのコントロールをwinbarに表示するかどうかと、その位置を指定
        controls = {
          enabled = true,
          position = "left",
        },
      },
      -- セッション開始時に自動でterminalを開く
      auto_toggle = "open_term",
      -- 別のタブに切り替えたときにdapviewを再度開く
      follow_tab = true,
    })
  end,
}
