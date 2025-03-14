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
-- -- タブバーを透明にする
-- config.window_frame = {
--   inactive_titlebar_bg = "none",
--   active_titlebar_bg = "none"
-- }
-- -- タブバーの背景色をtokyonight-moonと合わせる
-- config.window_background_gradient = {
--   colors = { "#222436" },
-- }
-- -- タブバーのタブ追加ボタンを非表示
-- config.show_new_tab_button_in_tab_bar = false
-- -- タブの閉じるボタンを非表示(nightlyでのみ)
-- -- config.show_close_tab_button_in_tabs = false
-- -- アクティブタブに色をつける
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
--   -- tokyonight-moon.bg_dark
--   local background = "#1e2030"
--   -- tokyonight-moon.fg_dark
--   local foreground = "#828bb8"
--
--   if tab.is_active then
--     -- tokyonight-moon.blue7
--     background = "#394b70"
--     -- tokyonight-moon.fg
--     foreground = "#c8d3f5"
--   end
--   local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
--   return {
--     { Background = { Color = background } },
--     { Foreground = { Color = foreground } },
--     { Text = title },
--   }
-- end)

-- カラーテーマ
-- NOTE: see all themes https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'tokyonight_night'
-- 背景の透過度
config.window_background_opacity = 0.9
-- 背景のぼかし
config.macos_window_background_blur = 9
-- フォント
config.font = wezterm.font_with_fallback {
  {family="Hack Nerd Font", weight="Regular"},
  {family="HackGen Console NF", weight="Regular"},
}
-- フォントサイズ
config.font_size = 13.0
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


-- wezterm にステータスバーを表示するプラグイン
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  options = {
    icons_enabled = true,
    -- theme = 'MaterialOcean',
    theme = "Nep (Gogh)",
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.ple_ice_waveform,
      right = wezterm.nerdfonts.ple_ice_waveform_mirrored,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.ple_lego_block_sideways,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { '' },
    tabline_c = { '' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'cwd', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'domain' },
  },
  extensions = {},
})

tabline.apply_to_config(config)

return config
