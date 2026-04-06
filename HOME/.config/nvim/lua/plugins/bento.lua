-- バッファマネージャ
return {
  "serhez/bento.nvim",
  event = { "BufReadPre" },
  cond = function()
    return not vim.g.vscode
  end,
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<Leader>,",
        "<cmd>BentoToggle<CR>",
        mode = "n",
        icon = "🍱",
        desc = " Bento - バッファ管理メニュー表示",
      },
      {
        "<Leader>bl",
        function()
          require("bento").toggle_lock()
        end,
        mode = "n",
        icon = "🍱",
        desc = " Bento - バッファロック/アンロック",
      },
    })
  end,
  config = function()
    require("bento").setup({
      main_keymap = ",", -- メニューのトグル(展開)キー
      lock_char = "🔒", -- ロックされたバッファ名の前に表示される文字
      max_open_buffers = 5, -- 開いたままにしておくバッファの最大数(nilは無制限)
      --   recency_access: 最近アクセス(entered/viewed)されていないバッファを削除
      --   recency_edit: 最近編集されていないバッファを削除する
      --   frecency_access: アクセス頻度が最も低いバッファを削除する
      --   frecency_edit: 編集頻度が最も低いバッファを削除する
      buffer_deletion_metric = "frecency_access", -- 制限に逹したときにどのバッファを削除するか 決定するために使用するメトリック
      buffer_notify_on_delete = true, -- バッファが削除された時に通知するか
      ordering_metric = "access", -- バッファの順序(access: 最終アクセス時刻順, edit: 最終編集時刻順, nil: 任意)
      default_action = "open", -- メニューが展開されたときのデフォルトアクションモード

      -- メニュー表示UI設定
      ui = {
        mode = "floating", -- UIモード("floating"|"tabline")
        -- floatingモード設定
        floating = {
          position = "middle-right", -- メニュー表示位置(top-left|top-right|middle-left|middle-right|bottom-left|bottom-right)
          offset_x = 0, -- 表示位置 横方向オフセット
          offset_y = 0, -- 表示位置 縦方向オフセット
          border = "single",
          dash_char = "─", -- 折り畳み境界を表示する文字
          label_padding = 1, -- ラベルの左右パディング量
          minimal_menu = "full", -- 折畳みメニューのスタイル(nil: 非表示, "dashed": 破線, "filename": 名前のみ, "full": 名前+ラベル)
          max_rendered_buffers = nil, -- ページごとに表示するバッファの最大数(nil: 無制限)
        },
        -- tablineモード設定
        tabline = {
          left_page_symbol = "❮", -- 前のバッファが存在する場合に左端に表示されるシンボル
          right_page_symbol = "❯", -- 次のバッファが存在する場合に右端に表示されるシンボル
          separator_symbol = "│", -- 区切り文字
        },
      },

      -- Highlight groups
      highlights = {
        current = "Bold", -- 現在のバッファファイル名
        active = "Normal", -- アクティブなバッファ
        inactive = "Comment", -- 非アクティブなバッファ
        modified = "DiagnosticWarn", -- 変更された(未保存)バッファ
        inactive_dash = "Comment", -- 非アクティブなバッファ
        previous = "Search", -- 前のバッファのラベル
        label_open = "DiagnosticVirtualTextHint", -- オープンアクションモードのラベル
        -- 削除アクションモードのラベル
        label_delete = "DiagnosticVirtualTextError",
        -- 垂直分割モードのラベル
        label_vsplit = "DiagnosticVirtualTextInfo",
        -- 水平分割モードのラベル
        label_split = "DiagnosticVirtualTextInfo",
        -- ロックアクションモードのラベル
        label_lock = "DiagnosticVirtualTextWarn",
        -- 折り畳まれたフルモードのラベル
        label_minimal = "Visual",
        -- メニューウィンドウの背景
        window_bg = "BentoNormal",
        -- ページインジケータ
        page_indicator = "Comment",
        -- tabline UIのバッファコンポーネントの区切り文字
        separator = "Normal",
      },
      -- カスタムアクション定義
      -- actions = {},
    })
  end,
}
