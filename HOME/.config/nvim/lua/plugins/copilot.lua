-- Github copilot
return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- "bottom" | "top" | "left" | "right"
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          -- 提案を全て受け入れる
          accept = "<Tab>",
          -- 提案を単語単位で受け入れる
          accept_word = "<M-Tab>",
          -- 提案を行単位で受け入れる
          accept_line = "<S-Tab>",
          next = "<M-]>",
          prev = "<M-[>",
          -- 提案を拒否する
          dismiss = "<C-Tab>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      auth_provider_url = nil,
      logger = {
        file = vim.fn.stdpath("log") .. "/copilot-lua.log",
        file_log_level = vim.log.levels.OFF,
        print_log_level = vim.log.levels.WARN,
        trace_lsp = "off",
        trace_lsp_progress = false,
        log_lsp_messages = false,
      },
      -- NOTE: NEED node.js version must be > 20
      copilot_node_command = "node",
      workspace_folders = {},
      copilot_model = "claude-sonnet-4",
      server_opts_overrides = {},
    })
  end,
}
