--
return {
  "folke/flash.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
      mode = "exact",
      incremental = false,
      exclude = {
        "notify",
        "cmp_menu",
        "noice",
        "flash_prompt",
        function(win)
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
      trigger = "",
      max_length = false, ---@type number|false
    },
    jump = {
      jumplist = true,
      pos = "start", ---@type "start" | "end" | "range"
      history = false,
      register = false,
      nohlsearch = false,
      autojump = false,
      inclusive = nil, ---@type boolean?
      offset = nil, ---@type number
    },
    label = {
      uppercase = true,
      exclude = "",
      current = true,
      after = true, ---@type boolean|number[]
      before = false, ---@type boolean|number[]
      style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
      reuse = "all", ---@type "lowercase" | "all" | "none"
      distance = true,
      min_pattern_length = 0,
      rainbow = {
        enabled = true,
        shade = 9, ---@type number 1-9
      },
      -- With `format`, you can change how the label is rendered.
      -- Should return a list of `[text, highlight]` tuples.
      ---@class Flash.Format
      ---@field state Flash.State
      ---@field match Flash.Match
      ---@field hl_group string
      ---@field after boolean
      ---@type fun(opts:Flash.Format): string[][]
      format = function(opts)
        return { { opts.match.label, opts.hl_group } }
      end,
    },
    highlight = {
      backdrop = true,
      matches = true,
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    action = nil,
    pattern = "",
    continue = true,
    config = nil, ---@type fun(opts:Flash.Config)|nil
    ---@type table<string, Flash.Config>
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      search = {
        enabled = false,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          -- `forward` will be automatically set to the search direction
          -- `mode` is always set to `search`
          -- `incremental` is set to `true` when `incsearch` is enabled
        },
      },
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
    char = {
      enabled = true,
      config = function(opts)
        opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

        opts.jump_labels = opts.jump_labels
          and vim.v.count == 0
          and vim.fn.reg_executing() == ""
          and vim.fn.reg_recording() == ""

      end,
      -- hide after jump when not using jump labels
      autohide = false,
      -- show jump labels
      jump_labels = true,
      -- set to `false` to use the current line only
      multi_line = true,
      label = { exclude = "hjkliardc" },
      keys = { "f", "F", "t", "T", ";", "," },
      char_actions = function(motion)
        return {
          [";"] = "next", -- set to `right` to always go right
          [","] = "prev", -- set to `left` to always go left
          -- clever-f style
          [motion:lower()] = "next",
          [motion:upper()] = "prev",
          -- jump2d style: same case goes next, opposite case goes prev
          -- [motion] = "next",
          -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
        }
      end,
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range" },
      search = { incremental = false },
      label = { before = true, after = true, style = "inline" },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    treesitter_search = {
      jump = { pos = "range" },
      search = { multi_window = true, wrap = true, incremental = false },
      remote_op = { restore = true },
      label = { before = true, after = true, style = "inline" },
    },
    -- options used for remote flash
    remote = {
      remote_op = { restore = true, motion = true },
    },
  },
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        border = "single",
        width = 1, -- when <=1 it's a percentage of the editor width
        height = 1,
        row = -1, -- when negative it's an offset from the bottom
        col = 1, -- when negative it's an offset from the right
        zindex = 1000,
      },
    },
    remote_op = {
      restore = false,
      motion = false,
    },
  },
  keys = {
    { "<Leader>j", mode = { "n" },
      function() require("flash").jump({
        search = { mode = "search", max_length = 0 },
        label = { after = { 0, 0 } },
        pattern = "^"
      }) end, desc = "Jump Lines by Flash" },
    { "<Leader>w", mode = { "n" },
      function() require("flash").jump({
        pattern = ".",
        search = {
          mode = function(pattern)
            if pattern:sub(1, 1) == "." then
              pattern = pattern:sub(2)
            end
            return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
          end,
        },
        jump = { pos = "range" },
      }) end, desc = "Jump Words by Flash"
    },
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
