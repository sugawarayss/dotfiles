--
return {
  "gbprod/yanky.nvim",
  keys = {
    {
      ";syh",
      function()
        Snacks.picker.yanky()
      end,
      mode = { "n", "x" },
      desc = "Yanky - ヤンク履歴を表示",
    },
  },
  opts = {
    ring = {
      -- 保存するヤンクアイテム数
      history_length = 100,
      -- 保存モード shada|sqlite
      storage = "shada",
      -- storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db",
      -- 番号付きレジスタと同期
      sync_with_numbered_registers = true,
      -- アクティブをキャンセルするイベント
      cancel_event = "update",
      -- ブラックホールレジスタは無視
      ignore_registers = { "_" },
      -- リングを循環するときに、更新に使用するレジスタを更新する
      update_register_on_cycle = false,
      -- すべてのputアクションで使用するラッパー
      permanent_wrapper = nil,
    },
    picker = {
      -- put action
      select = { action = nil },
      telescope = {},
    },
    system_clipboard = {
      -- Neovim外で発生したヤンクをリング履歴に追加する
      sync_with_ring = true,
      -- リングと同期するレジスタ
      clipboard_register = nil,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 500,
    },
    preserve_cursor_position = { enabled = true },
    textobj = { enabled = false },
  },
}
