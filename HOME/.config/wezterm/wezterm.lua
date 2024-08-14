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
-- 1つのタブしかない場合はタブバーを非表示
config.hide_tab_bar_if_only_one_tab = true
-- タブの最大幅
config.tab_max_width = 16
-- タブバーの表示スタイル
config.use_fancy_tab_bar = false
config.window_decorations = "TITLE|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
-- カラーテーマ
-- NOTE: see all themes https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'PaleNightHC'
-- 背景の透過度
config.window_background_opacity = 0.85
-- フォント
config.font = wezterm.font("Hack Nerd Font")
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

return config
