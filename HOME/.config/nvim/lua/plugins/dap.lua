-- debugger
return {
  "rcarriga/nvim-dap-ui",
  lazy = true,
  dependencies = {
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    { "<F8>", ":DapContinue<CR>", mode = "n", desc = "Continue" },
    { "<F9>", ":DapStepOver<CR>", mode = "n", desc = "StepOver" },
    { "<F10>", ":DapStepInto<CR>", mode = "n", desc = "StepInto" },
    { "<F7>", ":DapStepOut<CR>", mode = "n", desc = "StepOut" },
    { "<Leader>tm", ":lua require('dap-python').test_method()<CR>", mode = "n", desc = "Jump Test Method" },
    { "<Leader>tc", ":lua require('dap-python').test_class()<CR>", mode = "n", desc = "Jump Test Class" },
    { "<Leader>ts", "<ESC>:lua require('dap-python').debug_selection()<CR>", mode = "v", desc = "" },
    { "<M-b><M-b>", ":DapToggleBreakpoint<CR>", mode = "n", desc = "Toggle BreakPoint" },
    { "<M-S-b><M-S-b>", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: '))<CR>", mode = "n", desc = "Set BreakePoint With Condition" },
    { "<leader>lp", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", mode = "n", desc = "Set BreakePoint" },
    { "<leader>dr", ":lua require('dap').repl.open()<CR>", mode = "n", desc = "Debug open REPL" },
    { "<leader>dl", ":lua require('dap').run_last()<CR>", mode = "n", desc = "Debug run last" },
    { "<leader>d", ":lua require('dapui').toggle()<CR>", mode = "n", desc = "Toggle Debug" },
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
  end,
}
