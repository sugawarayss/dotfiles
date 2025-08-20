-- debugger
return {
  "rcarriga/nvim-dap-ui",
  lazy = true,
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
  },
  -- pythonファイルを開いた時にloadする
  ft = { "python" },
  keys = {
    {
      "<Leader>tm",
      ":lua require('dap-python').test_method()<CR>",
      mode = "n",
      desc = "テストメソッドにジャンプ",
    },
    {
      "<Leader>tc",
      ":lua require('dap-python').test_class()<CR>",
      mode = "n",
      desc = "テストクラスにジャンプ",
    },
    {
      "<Leader>ts",
      "<ESC>:lua require('dap-python').debug_selection()<CR>",
      mode = "v",
      desc = "選択範囲のpythonコードをデバッグ開始",
    },
    {
      "<C-b><C-b>",
      ":DapToggleBreakpoint<CR>",
      mode = "n",
      desc = "ブレークポイントをトグル",
    },
    {
      "<C-S-b><C-S-b>",
      ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: '))<CR>",
      mode = "n",
      desc = "条件付きブレークポイントをセット",
    },
    {
      "<leader>lp",
      ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      mode = "n",
      desc = "メッセージ付きブレークポイントをセット",
    },
    {
      "<leader>dr",
      ":lua require('dap').repl.open()<CR>",
      mode = "n",
      desc = "REPL でデバッグを開始",
    },
    {
      "<leader>dl",
      ":lua require('dap').run_last()<CR>",
      mode = "n",
      desc = "Debug run last",
    },
    {
      "<leader>db",
      ":lua require('dapui').toggle()<CR>",
      mode = "n",
      desc = "デバッグUIをトグル",
    },
  },
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
    local wk = require("which-key")
    wk.add({
      {
        "<F8>",
        ":DapContinue<CR>",
        mode = "n",
        desc = "デバッグ再開",
      },
      {
        "<F9>",
        ":DapStepOver<CR>",
        mode = "n",
        desc = "ステップオーバー",
      },
      {
        "<F10>",
        ":DapStepInto<CR>",
        mode = "n",
        desc = "ステップイントゥ",
      },
      {
        "<F7>",
        ":DapStepOut<CR>",
        mode = "n",
        desc = "ステップアウト",
      },
    })
  end,
}
