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
    { "<F8>",           ":DapContinue<CR>",                                                                         mode = "n", desc = "デバッグ再開" },
    { "<F9>",           ":DapStepOver<CR>",                                                                         mode = "n", desc = "ステップオーバー" },
    { "<F10>",          ":DapStepInto<CR>",                                                                         mode = "n", desc = "ステップイントゥ" },
    { "<F7>",           ":DapStepOut<CR>",                                                                          mode = "n", desc = "ステップアウト" },
    { "<Leader>tm",     ":lua require('dap-python').test_method()<CR>",                                             mode = "n", desc = "テストメソッドにジャンプ" },
    { "<Leader>tc",     ":lua require('dap-python').test_class()<CR>",                                              mode = "n", desc = "テストクラスにジャンプ" },
    { "<Leader>ts",     "<ESC>:lua require('dap-python').debug_selection()<CR>",                                    mode = "v", desc = "選択範囲のpythonコードをデバッグ開始" },
    { "<M-b><M-b>",     ":DapToggleBreakpoint<CR>",                                                                 mode = "n", desc = "ブレークポイントをトグル" },
    { "<M-S-b><M-S-b>", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: '))<CR>", mode = "n", desc = "条件付きブレークポイントをセット" },
    { "<leader>lp",     ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",    mode = "n", desc = "ブレークポイントをセット" },
    { "<leader>dr",     ":lua require('dap').repl.open()<CR>",                                                      mode = "n", desc = "REPL でデバッグを開始" },
    { "<leader>dl",     ":lua require('dap').run_last()<CR>",                                                       mode = "n", desc = "Debug run last" },
    { "<leader>db",     ":lua require('dapui').toggle()<CR>",                                                       mode = "n", desc = "デバッグUIをトグル" },
  },
  config = function()
    require("dapui").setup({
      icons = { expanded = "", collapsed = ""},
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
        }
      }
    })
    local debugpy_path = require("mason-registry").get_package("debugpy"):get_install_path()
    require("dap-python").setup(debugpy_path .. "/venv/bin/python")
    require("dap-python").test_runner = "pytest"

    table.insert(require("dap").configurations.python, {
      type = "python",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      env = "PYTHONPATH=.",
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        return vim.fn.input("Path to python interpreter: ", cwd .. "/.venv/bin/python")
      end,
    })
  end,
}
