---SEE Article--------------------------------
-- https://qiita.com/lx-sasabo/items/97c49d0f354ea3bdd525
-----------------------------------
-- FIXME: Review で表示する virtual text を無効化したいが効かない
-- _G.disable_review_on_current_line = function()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local namespace = vim.api.nvim_create_namespace("copilot_review")
--   local diagnostics = vim.diagnostic.get(bufnr, { namespace = namespace })
--   local cursor_pos = vim.api.nvim_win_get_cursor(0)
--   local cursor_line = cursor_pos[1]
--   for i, diagnostic in ipairs(diagnostics) do
--     if diagnostic.lnum == cursor_line then
--       table.remove(diagnostics, i)
--       break
--     end
--   end
--   vim.diagnostic.set(namespace, bufnr, diagnostics)
-- end

-- CopilotChat.nvim
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  lazy = false,
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken",
  keys = {
    -- Toggle CopilotChat
    {
      "<Leader>cco",
      function()
        local chat = require("CopilotChat")
        chat.toggle({
          window = {
            layout   = "float",
            relative = "cursor",
            border   = "double",
            width    = 1,
            height   = 0.4,
            title    = "Copilot Chat",
            footer   = nil,
            row      = 1,
            zindex   = 1000,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "CopilotChat を フロートウィンドウで表示"
    },
    {
      "<Leader>ccb",
      function()
        local chat = require("CopilotChat")
        chat.toggle({
          window = {
            layout = "horizontal",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "CopilotChat - 水平分割表示をトグル"
    },
    {
      "<Leader>ccn",
      function()
        local chat = require("CopilotChat")
        chat.toggle({
          window = {
            layout   = "horizontal",
            relative = "win",
            border   = "double",
            width    = 1,
            height   = 0.4,
            title    = "Copilot Chat",
            footer   = nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "CopilotChat - Open New Prompt"
    },
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
    -- Quick Explain
    { "<Leader>cce", "<Cmd>CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "CopilotChat - クイック解説" },
    -- Quick Review
    { "<Leader>ccr", "<Cmd>CopilotChatReview<CR>", mode = { "n", "v" }, desc = "CopilotChat - クイックバッファレビュー" },
    -- Quick Generate Test Code
    { "<Leader>cct", "<Cmd>CopilotChatTests<CR>", mode = { "n", "v" }, desc = "CopilotChat - クイックテストコード生成" },
    -- Show prompt actions with Telescope
    {
      "<Leader>ccp",
      function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      end,
      mode = {"n", "v"},
      desc = "CopilotChat - プロンプトアクション"
    },
    { "<Leader>ccs", "<Cmd>CopilotChatStop<CR>", mode = { "n", "v" }, desc = "CopilotChat - 回答中止" }
  },
  config = function()
    -- vim.api.nvim_set_keymap("n", "<Leader>ccc", ":lua disable_review_on_current_line()<CR>", { noremap = true, silent = true })
    local select = require("CopilotChat.select")
    local prompts = {
      Explain = {
        prompt = "/COPILOT_EXPLAIN カーソル上のコードの説明を段落をつけて書いてください。",
      },
      Tests = {
        prompt = "/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。",
      },
      Fix = {
        prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。",
      },
      Optimize = {
        prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。",
      },
      Review = {
        prompt = "/COPILOT_REVIEW コードをレビューしてください。日本語で回答してください。",
        callback = function(response, source)
          local namespace = vim.api.nvim_create_namespace("copilot_review")
          local diagnostics = {}
          for line in response:gmatch("[^\r\n]+") do
            if line:find("^line=") then
              local start_line = nil
              local end_line = nil
              local message = nil
              local single_match, message_match = line:match("^line=(%d+): (.*)$")
              if not single_match then
                local start_match, end_match, m_message_match = line:match("^line=(%d+)-(%d+): (.*)$")
                if start_match and end_match then
                  start_line = tonumber(start_match)
                  end_line = tonumber(end_match)
                  message = m_message_match
                end
              else
                start_line = tonumber(single_match)
                end_line = start_line
                message = message_match
              end

              if start_line and end_line then
                table.insert(diagnostics, {
                  lnum = start_line - 1,
                  end_lnum = end_line - 1,
                  col = 0,
                  message = "[Review] " .. message,
                  severity = vim.diagnostic.severity.WARN,
                  source = "Copilot Review",
                })
              end
            end
          end
          -- vim.diagnostic.set(namespace, source.bufnr, diagnostics)
        end,
      },
      Docs = {
        prompt = "/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）",
      },
      FixDiagnostic = {
        prompt = "ファイル内の次のような診断上の問題を解決してください：",
        selection = select.diagnostics,
      }
    }
    require("CopilotChat").setup({
      debug = false, -- Enable debug logging
      selection = function(source)
        return select.visual(source) or select.line(source)
      end,

      prompts                  = prompts,
      question_header          = "#### User ===> ",
      answer_header            = "#### Copilot ===> ",
      error_header             = "#### Error ===> ",
      separator                = "---",
      show_folds               = true,
      show_help                = true,
      auto_follow_cursor       = true,
      auto_insert_mode         = true,
      clear_chat_on_new_prompt = false,
      hightlight_selection     = true,
      context                  = "buffers",
      history_path             = vim.fn.stdpath("data") .. "/copilotchat_history",
      callback                 = nil,

      window = {
        layout   = "horizontal",
        relative = "win",
        border   = "double",
        width    = 1,
        height   = 0.4,
        title    = "Copilot Chat",
        footer   = nil,
        row      = 1,
        zindex   = 1000,
      },
      mappings = {
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert ="<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>"
        },
        reset = {
          normal ="<C-l>",
          insert = "<C-l>"
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-m>"
        },
        toggle_sticky = {
          detail = "Makes line under cursor sticky or deletes sticky line.",
          normal = "gr",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>"
        },
        jump_to_diff = { normal = "gj" },
        quickfix_answers = { normal = "gqa" },
        quickfix_diffs = { normal = "gqd" },
        yank_diff = { normal = "gy" },
        show_diff = { normal = "gd" },
        show_info = { normal = "gi" },
        show_context = { normal = "gc" },
        show_help = { normal = "gh" },
      },
    })
  end,
}
