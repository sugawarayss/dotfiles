local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		-- 新規ウィンドウを表示
		{ key = "n", mods = "SUPER", action = act.SpawnWindow },
		-- フルスクリーンをトグル
		-- { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
		-- Weztermを終了
		{ key = "q", mods = "SUPER", action = act.QuitApplication },
		-- Weztermの設定をロード
		-- { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
		-- クイックセレクトモード
		-- { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
		-- コマンドパレットを表示
		{ key = "p", mods = "SHIFT|SUPER", action = act.ActivateCommandPalette },
		-- コピーモードを開始
		{ key = "F2", mods = "SHIFT", action = act.ActivateCopyMode },
		-- デバッグ情報を表示
		-- { key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },

		----------------
		-- タブ操作   --
		----------------
		-- タブを複製
		{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
		-- 右のタブをアクティブにする
		{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
		-- 左のタブをアクティブにする
		{ key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },

		----------------
		-- ペイン操作 --
		----------------
		-- 上下に分割
		{ key = "d", mods = "SHIFT|SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- 左右に分割
		{ key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		-- ペインを入れ替える
		{ key = "Tab", mods = "CTRL|ALT", action = act.PaneSelect },
		{ key = "Tab", mods = "CTRL|ALT|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
		-- ペインを閉じる
		{ key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = false }) },
		-- ペインのサイズを調整
		{ key = "RightArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "LeftArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "UpArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Down", 1 }) },

		--------------------
		-- フォントサイズ --
		--------------------
		-- フォントサイズを大きくする
		-- { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
		-- フォントサイズを小さくする
		-- { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
		-- フォントサイズをリセット
		-- { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },

		-- クリップボードにコピー
		{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
		-- クリップボードからペースト
		{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
		-- セレクションの値で検索
		-- { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },

		----------------
		-- スクロール --
		----------------
		{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
		{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
	},

	key_tables = {
		-- コピーモード用のキーバインド
		copy_mode = {
			-- コピーモードを終了
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
			{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
			-- コピーしてコピーモードを終了
			{
				key = "y",
				mods = "NONE",
				action = act.Multiple({
					{ CopyTo = "ClipboardAndPrimarySelection" },
					{ CopyMode = "Close" },
				}),
			},

			-- 選択モードを有効化
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			-- ブロック選択モードを有効化
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			-- 行選択モードを有効化
			{ key = "v", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },

			-- 左に移動
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
			-- 下に移動
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
			-- 上に移動
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
			-- 一番上へ移動
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			-- 一番下へ移動
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
			-- 右に移動
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
			-- 前方の1単語先頭に移動
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			-- 前方の1単語末尾に移動
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			-- 後方の1単語先頭に移動
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			-- 行頭文字に移動
			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			-- 行末文字に移動
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			-- 行の先頭に移動
			{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			-- 行の末尾に移動
			{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },

			-- 前方にジャンプ(対象の1文字前)
			{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
			-- 後方にジャンプ(対象の1文字前)
			{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			-- 前方にジャンプ(対象位置)
			{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
			-- 後方にジャンプ(対象位置)
			{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			-- 逆方向にジャンプ
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
			-- もう一度ジャンプ
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },

			-- 表示領域の先頭に移動
			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
			-- 表示領域の中央に移動
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
			-- 表示領域の末尾に移動
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },

			{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },

			-- 半ページ上に移動
			{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
			-- ページ上に移動
			{ key = "PageUp", mods = "SHIFT", action = act.CopyMode("PageUp") },
			-- 半ページ下に移動
			{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
			-- ページ下に移動
			{ key = "PageDown", mods = "SHIFT", action = act.CopyMode("PageDown") },
		},

		search_mode = {
			{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
			{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
			{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
			{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
		},
	},
}
