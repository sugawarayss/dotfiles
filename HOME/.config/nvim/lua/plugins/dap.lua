-- debugger
return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    { "<F8>", ":DapContinue<CR>", mode = "n" },
    { "<F9>", ":DapStepOver<CR>", mode = "n" },
    { "<F10>", ":DapStepInto<CR>", mode = "n" },
    { "<F7>", ":DapStepOut<CR>", mode = "n" },
    { "<Leader>tm", ":lua require('dap-python').test_method()<CR>", mode = "n" },
    { "<Leader>tc", ":lua require('dap-python').test_class()<CR>", mode = "n" },
    { "<Leader>ts", "<ESC>:lua require('dap-python').debug_selection()<CR>", mode = "v" },
    { "<M-b><M-b>", ":DapToggleBreakpoint<CR>", mode = "n" },
    { "<M-S-b><M-S-b>", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: '))<CR>", mode = "n" },
    { "<leader>lp", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", mode = "n" },
    { "<leader>dr", ":lua require('dap').repl.open()<CR>", mode = "n" },
    { "<leader>dl", ":lua require('dap').run_last()<CR>", mode = "n" },
    { "<leader>d", ":lua require('dapui').toggle()<CR>", mode = "n" },
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
