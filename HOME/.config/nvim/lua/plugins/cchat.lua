---SEE Article--------------------------------
-- https://qiita.com/lx-sasabo/items/97c49d0f354ea3bdd525
-----------------------------------
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  lazy = false,
  dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim" },
  },
  keys = {
    -- Toggle CopilotChat
    { "<Leader>cco", "<Cmd>CopilotChatToggle<CR>", desc = "CopilotChat - Toggle" },
    -- Quick Chat Key Mapping
    {
      "<Leader>ccq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick Chat"
    },
    -- Show help actions with Telescope
    {
      "<Leader>cch",
      function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.help_actions())
      end,
      desc = "CopilotChat - Help Actions"
    },
    -- Show prompt actions with Telescope
    {
      "<Leader>ccp",
      function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      end,
      desc = "CopilotChat - Prompt Actions"
    },
  },
  opts = {},
  config = function()
    local select = require("CopilotChat.select")
    local prompts = {
      Explain = {
        prompt = '/COPILOT_EXPLAIN カーソル上のコードの説明を段落をつけて書いてください。',
      },
      Tests = {
        prompt = '/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。',
      },
      Fix = {
        prompt = '/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。',
      },
      Optimize = {
        prompt = '/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
      },
      Docs = {
        prompt = '/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）',
      },
      FixDiagnostic = {
        prompt = 'ファイル内の次のような診断上の問題を解決してください：',
        selection = select.diagnostics,
      }
    }
    require("CopilotChat").setup({
      debug = true, -- Enable debug logging
      prompts = prompts,
      question_header = '',
      answer_header = '**Copilot** ',
      error_header = '**Error** ',
      separator = '---',
      show_folds = true,
      show_help = true,
      auto_follow_cursor = true,
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,
      context = nil,
      history_path = vim.fn.stdpath('data') .. '/copilotchat_history',
      callback = nil,
      window = {
        layout = 'float',
        relative = 'cursor',
        border = 'double',
        width = 1,
        height = 0.4,
        title = 'Copilot Chat',
        footer = nil,
        row = 1,
        zindex = 1000,
      },
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert ='<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal ='<C-l>',
          insert = '<C-l>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-m>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        yank_diff = {
          normal = 'gy',
        },
        show_diff = {
          normal = 'gd'
        },
        show_system_prompt = {
          normal = 'gp'
        },
        show_user_selection = {
          normal = 'gs'
        },
      },
    })
  end,
}
