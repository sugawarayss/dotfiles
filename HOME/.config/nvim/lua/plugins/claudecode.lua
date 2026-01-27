-- Neovim から Claude Code を扱えるようにするプラグイン
return {
  "coder/claudecode.nvim",
  cmd = { "ClaudeCode" },
  opts = {
    portt_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = "info",
    terminal_cmd = "/opt/homebrew/bin/claude",
    focus_after_send = false,
    track_selection = true,
    visual_demotion_delay_ms = 50,
    terminal = {
      split_side = "right", -- "left" | "right"
      split_width_percentage = 0.30,
      provider = "snacks", -- "auto" | "snacks" | "native" | "external" | "none"
      auto_close = true,
      snacks_win_opts = {},
      provider_opts = {
        external_terminal_cmd = nil,
      },
    },
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
      keep_terminal_focus = false,
    },
  },
  config = true,
  keys = {},
}
