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
    -- windows = {
    --   size = 0.25,
    --   position = "below",
    --   terminal = {
    --     size = 0.5,
    --     position = "left",
    --     hide = {},
    --   },
    -- },
    windows = {
      anchor = function()
        -- Anchor to the first terminal window found in the current tab
        -- Tweak according to your needs
        local windows = vim.api.nvim_tabpage_list_wins(0)

        for _, win in ipairs(windows) do
          local bufnr = vim.api.nvim_win_get_buf(win)
          if vim.bo[bufnr].buftype == "snacks_terminal" then
            return win
          end
        end
      end,
      position = function(prev)
        local wins = vim.api.nvim_tabpage_list_wins(0)
        if vim.iter(wins):find(function(win)
          return vim.w[win].dapview_win_term
        end) then
          return prev
        end

        return vim.tbl_count(vim
          .iter(wins)
          :filter(function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            local valid_buftype = vim.tbl_contains({ "", "help", "prompt", "quickfix", "terminal" }, vim.bo[buf].buftype)
            local dapview_win = vim.w[win].dapview_win or vim.w[win].dapview_win_term
            return valid_buftype and not dapview_win
          end)
          :totable()) > 1 and "below" or "right"
      end,
      size = function(pos)
        return pos == "below" and 0.25 or 0.5
      end,
      terminal = {
        position = function(pos)
          return pos == "below" and "right" or "below"
        end,
        size = 0.5,
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
