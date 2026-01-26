return {
  "folke/sidekick.nvim",
  enabled = true,
  event = { "BufReadPost" },
  opts = {
    jump = {
      jumplist = true,
    },
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    nes = {
      enabled = false,
      debounce = 100,
      trigger = {
        events = { "ModeChanged i:n", "TextChanged", "User SidekickNesDone" },
      },
      clear = {
        events = { "TextChangedI", "InsertEnter" },
        esc = true,
      },
      diff = {
        inline = "words",
      },
    },
    cli = {
      watch = true,
      win = {
        -- config = function(terminal) end,
        wo = {},
        bo = {},
        layout = "right",
        float = {
          width = 0.9,
          height = 0.9,
        },
        split = {
          width = 80,
          height = 20,
        },
        nav = nil,
      },
    },
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
      desc = "Sidekick - Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick - Sidekick Switch Focus",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Sidekick - Sidekick Toggle CLI",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick - Sidekick Claude Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Sidekick - Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Sidekick - Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Sidekick - Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Sidekick - Send Visual Selection",
    },
    {
      "<leader>ag",
      function()
        require("sidekick.cli").toggle({ name = "gemini", focus = true })
      end,
      desc = "Sidekick - Sidekick Gemini Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").select_prompt()
      end,
      desc = "Sidekick - Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
}
