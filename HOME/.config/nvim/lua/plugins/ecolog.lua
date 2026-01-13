-- .envファイルを自動ロードするプラグイン
return {
  "ph1losof/ecolog.nvim",
  lazy = false,
  init = function()
    local wk = require("which-key")
    wk.add({
      { ";se", "<Cmd>EcologSnacks<CR>", mode = { "n" }, icon = "󰈈", desc = "環境変数を検索(Snacks)" },
      { ";es", "<Cmd>EcologSelect<CR>", mode = { "n" }, icon = "󱥼", desc = ".envファイルを切り替え" },
      { ";et", "<Cmd>EcologShelterToggle<CR>", mode = { "n" }, icon = "󰈉", desc = "環境変数マスクをトグル" },
      { ";el", "<Cmd>EcologShelterLinePeek<CR>", mode = { "n" }, icon = "󰴅", desc = "カーソル行のマスクを解除" },
      { ";eg", "<Cmd>EcologGoto<CR>", mode = { "n" }, icon = "󰷊", desc = "envファイルに移動" },
      { ";eh", "<Cmd>EcologShellTogge<CR>", mode = { "n" }, icon = "󱎴", desc = "シェル環境変数をトグル" },
    })
  end,
  opts = {
    integrations = {
      -- 補完プラグイン設定
      nvim_cmp = false,
      blink_cmp = true,
      snacks = {
        shelter = {
          mask_on_copy = false,
        },
        keys = {
          copy_value = "<C-y>", -- Copy variable value to clipboard
          copy_name = "<C-u>", -- Copy variable name to clipboard
          append_value = "<C-a>", -- Append value at cursor position
          append_name = "<CR>", -- Append name at cursor position
          edit_var = "<C-e>", -- Edit environment variable
        },
        layout = { -- Any Snacks layout configuration
          preset = "dropdown",
          preview = false,
        },
      },
    },
    shelter = {
      configuration = {
        -- 一部マスキング設定
        partial_mode = {
          -- 先頭3文字は表示する
          show_start = 3,
          -- 末尾3文字は表示
          show_end = 3,
          -- マスクする最小文字数
          min_mask = 3,
        },
        -- マスク文字
        mask_char = "*",
        --
        mask_length = nil,
        -- envファイル内のコメント行のマスキングをスキップ
        skip_comments = true,
      },
      modules = {
        -- 補完時に値をマスクする
        cmp = true,
        -- 値のチラ見
        peek = false,
        -- バッファ内で値をマスクする
        files = true,
        -- telescope統合
        telescope = false,
        telescope_previewer = false,
        -- fzf統合
        fzf = false,
        fzf_previewer = false,
        -- Snacks統合
        snacks = false,
        snacks_previewer = false,
      },
    },
    -- 組み込みタイプの有効化
    types = true,
    -- .envファイルの探索パス
    path = vim.fn.getcwd(),
    --
    preferred_environment = "development",
    provider_patterns = true,
  },
}
