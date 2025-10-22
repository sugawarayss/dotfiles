return {
  "nekowasabi/hellshake-yano.vim",
  enabled = false,
  dependencies = { "vim-denops/denops.vim" },
  event = { "VimEnter" },
  config = function()
    local color_palette = require("onedark.colors")
    vim.g.hellshake_yano = {
      -- ヒントマーカーとして使用される文字
      -- markers = {},
      -- ヒントが表示されるまでの動作回数
      motionCount = 3,
      -- 指定されていないキーのデフォルトのモーションカウント
      defaultMotionCount = 1,
      -- キーごとのモーションカウント設定
      -- perKeyMotionCount = {},
      -- モーションカウントタイムアウト
      motionTimeout = 2000,
      -- ヒントを表示する位置
      hintPosition = "both",
      -- hjkl の動きでトリガーを有効にする
      triggerOnHjkl = true,
      -- 追跡するカスタムモーションキー
      -- countedMotions = {},
      -- プラグインを有効
      enabled = true,
      -- 1文字のヒントに使用するキー
      singleCharKeys = "ASDFGHJKLNM0-9",
      -- 複数文字のヒントに使用するキー
      multiCharKeys = "BCEIOPQRTUVWXYZ",
      -- ヒントグループ機能を有効にする
      useHintGroups = true,
      -- 日本語の単語検出を有効にする
      useJapanese = true,
      useNumbers = true,
      -- 日本語の単語の最小文字数
      japaneseMinWordLength = 3,
      -- ハイライトを有効にする
      enableHighlight = true,
      -- 現在のヒントマーカーのハイライト
      highlightHintMarker = {
        bg = color_palette.red,
        fg = color_palette.black,
      },
      highlightHintMarkerCurrent = {
        bg = color_palette.dark_red,
        fg = color_palette.diff_text,
      },
      -- 高速キーリピート中のヒントを非表示にする
      suppressOnKeyRepeat = true,
      -- キーリピート検出閾値(ミリ秒)
      keyRepeatThreshold = 50,
      -- キーリピート後のリセット遅延
      keyRepeatResetDelay = 300,
      -- ヒントモードを起動するモーションコマンド回数
      perKeyMotionCount = {
        w = 5,
        b = 5,
        e = 5,
        h = 3,
        j = 3,
        k = 3,
        l = 3,
      },
      -- キーごとの最小単語長を設定する
      perKeyMinLength = {
        w = 1,
        b = 1,
        e = 1,
        h = 2,
        j = 2,
        k = 2,
        l = 2,
      },
      -- ヒントのデフォルトの最小単語長
      defaultMinWordLength = 2,
      -- 'both'でのヒントの最小単語長
      bothMinWordLength = 5,
      -- TinySegmenterを使用するための最小文字数(camelCase)
      segmenterThreshold = 4,
      -- パーティクルマージの最大文字数(camelCase)
      japaneseMergeThreshold = 4,
      -- デバッグモードを有効にする
      debugMode = false,
      -- パフォーマンスログを有効にする
      performanceLog = false,
      -- 各ヒントジャンプ後にもヒントを表示する
      continuousHintMode = false,
      -- 連続モード中にカーソルを中央に戻すために使用されるコマンド
      recenterCommand = "normal! zz",
      -- ループを停止するジャンプ回数
      maxContinuousJumps = 50,
      -- 日本語の形態素解析を使う
      useTinySegmenter = true,
    }
  end,
}
