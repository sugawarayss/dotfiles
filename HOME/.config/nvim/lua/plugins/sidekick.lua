return {
  "folke/sidekick.nvim",
  enabled = false,
  event = { "BufReadPost" },
  opts = {
    mux = {
      backend = "zellij",
      enabled = true,
    },
    prompts = {
      explain = "コードの解説",
      diagnostics = {
        msg = "このファイルの診断はどう対処すべき?",
        diagnostics = true,
      },
      diagnostics_all = {
        msg = "これらの診断結果の対応を補助してください",
        diagnostics = { all = true },
      },
      fix = {
        msg = "このコードの問題を修正してください",
        diagnostics = true,
      },
      review = {
        msg = "このコードをよくレビューして、問題点や改善点を挙げてください",
        diagnostics = true,
      },
      optimize = "このコードをoptimizeしてください",
      tests = "このコードのテストを実装してください",
      file = { location = { row = false, col = false } },
      position = {},
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Sidekick Toggle CLI",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Claude Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ag",
      function()
        require("sidekick.cli").toggle({ name = "grok", focus = true })
      end,
      desc = "Sidekick Grok Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").select_prompt()
      end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
}
