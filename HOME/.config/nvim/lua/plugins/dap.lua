local venv_python = ".venv/bin/python"
require("dap-python").setup(venv_python)

vim.api.nvim_set_keymap('n', '<F8>', ':DapContinue<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<F9>', ':DapStepOver<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ':DapStepInto<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<F7>', ':DapStepOut<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', ':DapToggleBreakpoint<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>B', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>lp', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require("dap").repl.open()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require("dap").run_last()<CR>', { silent = true })

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
vim.api.nvim_set_keymap('n', '<leader>d', ':lua require("dapui").toggle()<CR>', {})
