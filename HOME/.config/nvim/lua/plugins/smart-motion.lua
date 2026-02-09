return {
  "FluxxField/smart-motion.nvim",
  enabled = true,
  event = { "BufReadPre" },
  opts = {
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
      lines = false, -- j, k
      search = false, -- s, f, F, t, T, ;, ,, gs
      delete = true, -- d, dt, dT, rdw, rdl
      yank = true, -- y, yt, yT, ryw, ryl
      change = false, -- c, ct, cT
      paste = false, -- p, P
      treesitter = true, -- ]], [[, ]c, [c, ]b, [b, daa, caa, yaa, dfn, cfn, yfn, saa
      diagnostics = false, -- ]d, [d, ]e, [e
      git = false, -- ]g, [g
      quickfix = false, -- ]q, [q, ]l, [l
      marks = false, -- g', gm
      misc = false, -- . g. g0 g1-g9 gp gP gA-gZ gmd gmy (repeat, history, pins, global pins)
    },

    -- Flow state timeout in milliseconds
    flow_state_timeout_ms = 300,

    -- Disable dimming of non-target text
    disable_dim_background = false,

    -- Maximum motions stored in repeat history
    history_max_size = 20,

    -- Automatically select when only one target exists
    auto_select_target = false,

    -- Enable label overlay during native / search (toggle with <C-s>)
    native_search = true,

    -- How count prefix interacts with motions (j/k): "target" or "native"
    count_behavior = "target",
  },
}
