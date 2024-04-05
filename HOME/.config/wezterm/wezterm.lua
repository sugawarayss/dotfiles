local wezterm = require 'wezterm'

local config = {}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
wezterm.on(
'format-tab-title',
function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
        background = '#2b2042'
        foreground = '#c0c0c0'
    elseif hover then
        background = '#3b3052'
        foreground = '#909090'
    end

    local edge_foreground = background

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)

if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
-- Color Theme -- NOTE: see all themes https://github.com/mbadolato/iTerm2-Color-Schemes#screenshots
config.color_scheme = 'Wombat'
-- Background Opacity
config.window_background_opacity = 0.93
-- Font
config.font = wezterm.font("Hack Nerd Font")
-- Font Size
config.font_size = 13.0

-- Enable IME
config.use_ime = true

-- Keybindings
config.disable_default_key_bindings = true
-- load keybinds.lua
local keybind = require 'keybinds'
-- keybinds configuration
config.keys = keybind.keys
config.key_tables = keybind.key_tables

-- Set Leader Key

return config
