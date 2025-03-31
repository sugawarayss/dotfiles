local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end
-- 更新を確認
config.check_for_updates = true
-- 更新確認の間隔
config.check_for_updates_interval_seconds = 86400
-- 更新確認時にウィンドウを表示
config.show_update_window = true
-- 設定ファイルを監視して変更があれば自動でリロード
config.automatically_reload_config = true
-- カーソルのスタイルは明滅するブロック
config.default_cursor_style = "BlinkingBlock"
-- スクロールバーを表示
config.enable_scroll_bar = true
-- Leaderキーを設定
config.leader = { key = ",", mods = "SUPER", timeout_milliseconds = 2000 }

-- 1つのタブしかない場合はタブバーを非表示
config.hide_tab_bar_if_only_one_tab = false
-- タブの最大幅
config.tab_max_width = 16
-- タブバーの表示スタイル
config.use_fancy_tab_bar = true
-- config.window_decorations = "TITLE|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
-- config.window_decorations = "RESIZE"

-- カラーテーマ
-- NOTE: see all themes https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'Ef-Duo-Dark'
-- 背景の透過度
config.window_background_opacity = 0.95
-- 背景のぼかし
config.macos_window_background_blur = 9
-- フォント
config.font = wezterm.font_with_fallback {
  {family="Hack Nerd Font", weight="Regular"},
  {family="HackGen Console NF", weight="Regular"},
}
-- フォントサイズ
config.font_size = 14.0
-- フォントサイズ変更時にウィンドウサイズを調整
config.adjust_window_size_when_changing_font_size = true
-- IME を有効にする
config.use_ime = true
-- デフォルトのキーバインディングを無効化
config.disable_default_key_bindings = true
-- キーバインディングを外部ファイルから読み込む
local keybind = require 'keybinds'
config.keys = keybind.keys
config.key_tables = keybind.key_tables


-- wezterm.erm にステータスバーを表示するプラグイン
-- local tabline = wezterm.erm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
--
-- tabline.setup({
--   options = {
--     icons_enabled = true,
--     -- theme = 'MaterialOcean',
--     theme = "Nep (Gogh)",
--     tabs_enabled = true,
--     theme_overrides = {},
--     section_separators = {
--       left = wezterm.erm.nerdfonts.ple_ice_waveform,
--       right = wezterm.erm.nerdfonts.ple_ice_waveform_mirrored,
--     },
--     component_separators = {
--       left = wezterm.erm.nerdfonts.ple_backslash_separator,
--       right = wezterm.erm.nerdfonts.ple_forwardslash_separator,
--     },
--     tab_separators = {
--       left = wezterm.erm.nerdfonts.ple_lower_left_triangle,
--       right = wezterm.erm.nerdfonts.ple_lower_right_triangle,
--     },
--   },
--   sections = {
--     tabline_a = { "domain", "hostname" },
--     tabline_b = {
--       {
--         "datetime",
--         style = "%Y-%m-%d",
--       },
--     },
--     tabline_c = {
--       {
--         "datetime",
--         style = "%H:%M:%S",
--       },
--     },
--     tab_active = {
--       "index",
--       { "parent", padding = 0 },
--       "/",
--       { "cwd", padding = { left = 0, right = 1 } },
--       { "zoomed", padding = 0 },
--     },
--     tab_inactive = { "index", { "cwd", padding = { left = 0, right = 1 } } },
--     tabline_x = {},
--     tabline_y = {
--       "ram",
--       "cpu",
--       "battery"
--     },
--     tabline_z = {
--       "mode"
--     },
--   },
--   extensions = {},
-- })
--
-- tabline.apply_to_config(config)
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(
  config,
  {
    position = "bottom",
    separator = {
      space = 1,
      left_icon = wezterm.nerdfonts.md_menu_right,
      right_icon = wezterm.nerdfonts.md_menu_left,
      field_icon = wezterm.nerdfonts.indent_line,
    },
    modules = {
      tabs = {
        active_tab_fg = 5,
        inactive_tab_fg = 2,
      },
      workspace = {
        enabled = false,
        icon = wezterm.nerdfonts.cod_window,
        color = 8,
      },
      leader = {
        enabled = true,
        icon = wezterm.nerdfonts.oct_rocket,
        color = 2,
      },
      pane = {
        enabled = true,
        icon = wezterm.nerdfonts.cod_multiple_windows,
        color = 7,
      },
      username = {
        enabled = true,
        icon = wezterm.nerdfonts.fa_user,
        color = 6,
      },
      hostname = {
        enabled = true,
        icon = wezterm.nerdfonts.md_monitor,
        color = 8,
      },
      clock = {
        enabled = true,
        icon = wezterm.nerdfonts.fa_clock_o,
        color = 5,
      },
      cwd = {
        enabled = true,
        icon = wezterm.nerdfonts.oct_file_directory,
        color = 7,
      },
      spotify = {
        enabled = false,
        icon = wezterm.nerdfonts.fa_spotify,
        color = 3,
        max_width = 64,
        throttle = 15,
      },
    },
  }
)

return config
