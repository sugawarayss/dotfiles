return {
  "FluxxField/smart-motion.nvim",
  enabled = false,
  event = { "BufReadPre" },
  config = function()
    local sm = require("smart-motion")
    sm.setup({
      -- Use background highlighting instead of character replacement
      -- Characters used for hint labels
      keys = "fjdksleirughtynm",
      -- Use background highlighting instead of character replacement
      use_background_highlights = false,
      -- Highlight groups (string = existing group, table = custom definition)
      highlight = {
        hint = "SmartMotionHint", -- { fg = "#FF2FD0" }
        hint_dim = "SmartMotionHintDim",
        two_char_hint = "SmartMotionTwoCharHint", -- { fg = "#2FD0FF" }
        two_char_hint_dim = "SmartMotionTwoCharHintDim",
        dim = "SmartMotionDim", -- "Comment"
        search_prefix = "SmartMotionSearchPrefix",
        search_prefix_dim = "SmartMotionSearchPrefixDim",
      },

      -- Enable/disable preset groups
      presets = {
        words = true, -- w, b, e, ge
        lines = true, -- j, k
        search = true, -- s, f, F, t, T, ;, ,, gs
        delete = false, -- d, dt, dT, rdw, rdl
        yank = false, -- y, yt, yT, ryw, ryl
        change = false, -- c, ct, cT
        paste = false, -- p, P
        treesitter = true, -- ]], [[, ]c, [c, ]b, [b, daa, caa, yaa, dfn, cfn, yfn, saa
        diagnostics = true, -- ]d, [d, ]e, [e
        git = false, -- ]g, [g
        quickfix = false, -- ]q, [q, ]l, [l
        marks = false, -- g', gm
        misc = true, -- . g. g0 g1-g9 gp gP gA-gZ gmd gmy (repeat, history, pins, global pins)
      },

      -- Flow state timeout in milliseconds
      flow_state_timeout_ms = 300,
      -- Disable dimming of non-target text
      disable_dim_background = false,
      -- Automatically select when only one target exists
      auto_select_target = false,
      -- Enable label overlay during native / search (toggle with <C-s>)
      native_search = true,
      -- How count prefix interacts with motions (j/k): "target" or "native"
      count_behavior = "target",
      -- presistent history entries
      history_max_size = 20,
      -- open folds at target position
      open_folds_on_jump = true,
      -- save position to jumplist before jumping (j/k excluded to match native vim)
      save_to_jumplist = true,
      -- maximum pin slots
      max_pins = 9,
      -- auto-proceed after typing in search
      search_timeout_ms = 500,
      -- exit search with no input
      search_idle_timeout_ms = 2000,
      -- yank flash duration (ms)
      yank_highlight_duration = 150,
      -- prune history entries older than this
      history_max_age_days = 30,
    })
    -- WARN: ドキュメントに記載があるのに、register_motion というAPIがない
    -- sm.register_motion("<leader>j", {
    --   collector = "lines",
    --   extractor = "words",
    --   filter = "filter_words_after_cursor",
    --   visualizer = "hint_start",
    --   action = "jump_centered",
    --   map = true,
    --   modes = { "n", "v" },
    -- })
  end,
}
