-- debugger
return {
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "ravsii/nvim-dap-envfile",
    },
    -- pythonファイルを開いた時にloadする
    ft = { "python" },
    init = function()
      local wk = require("which-key")
      wk.add({
        {
          ";bb",
          ":DapToggleBreakpoint<CR>",
          mode = "n",
          icon = "",
          desc = "BreakPointをトグル(dap)",
        },
        {
          ";cbb",
          ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: '))<CR>",
          mode = "n",
          icon = "",
          desc = "条件付きBreakPointをセット(dap)",
        },
        {
          ";ibb",
          ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
          mode = "n",
          icon = "",
          desc = "メッセージ付きBreakPointをセット(dap)",
        },
        {
          "<F8>",
          ":DapContinue<CR>",
          mode = "n",
          icon = "󰐊",
          desc = "デバッグ再開",
        },
        {
          "<F9>",
          ":DapStepOver<CR>",
          mode = "n",
          icon = "󰓛",
          desc = "ステップオーバー",
        },
        {
          "<F10>",
          ":DapStepInto<CR>",
          mode = "n",
          icon = "󰆹",
          desc = "ステップイントゥ",
        },
        {
          "<F7>",
          ":DapStepOut<CR>",
          mode = "n",
          icon = "󰆸",
          desc = "ステップアウト",
        },
        -- {
        --   "<Leader>tm",
        --   ":lua require('dap-python').test_method()<CR>",
        --   mode = "n",
        --   icon = "",
        --   desc = "テストメソッドにジャンプ",
        -- },
        -- {
        --   "<Leader>tc",
        --   ":lua require('dap-python').test_class()<CR>",
        --   mode = "n",
        --   desc = "テストクラスにジャンプ",
        -- },
        {
          "<leader>db",
          ":lua require('dapui').toggle()<CR>",
          mode = "n",
          icon = "󰃤",
          desc = "デバッグUIをトグル(dap)",
        },
      })
    end,
    config = function()
      require("dapui").setup({
        icons = { expanded = "", collapsed = "" },
        layouts = {
          {
            elements = {
              { id = "watches", size = 0.20 },
              { id = "stacks", size = 0.20 },
              { id = "breakpoints", size = 0.20 },
              { id = "scopes", size = 0.40 },
            },
            size = 64,
            position = "right",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.20,
            position = "bottom",
          },
        },
      })
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      require("dap-python").setup("uv")

      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "launch",
        name = "現在開いているファイルを実行",
        program = "${file}",
        cwd = require("utils").find_project_root({ "pyproject.toml" }),
        env = { PYTHONPATH = "." },
        python = require("utils").find_python_venv({ "pyproject.toml" }),
      })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    ft = { "python" },
    opts = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      })
    end,
  },
}
