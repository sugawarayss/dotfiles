-- テストコードを実行するプラグイン
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  keys = {
    {
      "<M-r><M-t>r",
      ":lua require('neotest').run.run({strategy = 'dap'})<CR>",
      mode = "n",
      desc = "最も近いテストをデバッグする",
    },
    { "<M-r><M-t>s", ":lua require('neotest').run.stop()<CR>", mode = "n", desc = "テストをストップ" },
    {
      "<M-r><M-t>f",
      ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
      mode = "n",
      desc = "現在のファイルのテストを実行する",
    },
    {
      "<M-r><M-t>v",
      ":lua require('neotest').output.open()<CR>",
      mode = "n",
      desc = "テストの結果を表示する(float window)",
    },
    {
      "<M-r><M-t>o",
      ":lua require('neotest').output_panel.open()<CR>",
      mode = "n",
      desc = "テストの結果をパネル表示する",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG", "-v", "-s" },
          runner = "pytest",
        }),
        require("rustaceanvim.neotest"),
      },
    })
  end,
}
