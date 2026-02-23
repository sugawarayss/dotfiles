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
  opts = {
    winbar = {
      sections = { "scopes", "watches", "exceptions", "breakpoints", "threads", "repl" },
      default_section = "scopes",
      controls = {
        enabled = true,
        position = "right",
      },
    },
    windows = {
      size = 0.25,
      position = "below",
      terminal = {
        size = 0.5,
        position = "left",
        hide = {},
      },
    },
    -- Auto open when a session is started and auto close when all sessions finish
    -- Alternatively, can be a string:
    -- - "keep_terminal": as above, but keeps the terminal when the session finishes
    -- - "open_term": open the terminal when starting a new session, nothing else
    auto_toggle = "open_term",
    -- Reopen dapview when switching to a different tab
    -- Can also be a function to dynamically choose when to follow, by returning a boolean
    -- If a function, receives the name of the adapter for the current session as an argument
    follow_tab = true,
  },
}
