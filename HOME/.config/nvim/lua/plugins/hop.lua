-- 少ないキー数で様々な場所に遷移できるモーションを提供
return {
  "smoka7/hop.nvim",
  version = "*",
  event = { "BufReadPre" },
  keys = {
      { "<Leader>/", "<cmd>HopPattern<CR>",     desc = "入力したパターンでhop" },
      { "<Leader>k", mode = { "n", "x", "o" }, "<cmd>HopVertical<CR>",    desc = "縦方向にhop" },
      { "<Leader>j", mode = { "n", "x", "o" }, "<cmd>HopLineStartMW<CR>", desc = "すべてのバッファで行単位で行頭にhop" },
      { "<Leader>w", mode = { "n", "x", "o" }, "<cmd>HopWordAC<CR>",      desc = "カーソルより後ろの単語頭にhop" },
      { "<Leader>e", mode = { "n", "x", "o" }, ":lua require('hop').hint_words({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, hint_position = require('hop.hint').HintPosition.END })<CR>", desc = "カーソルより後ろの単語末尾にhop" },
      { "<Leader>ge", mode = { "n", "x", "o" }, ":lua require('hop').hint_words({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, hint_position = require('hop.hint').HintPosition.END })<CR>", desc = "カーソルより前の単語末尾にhop" },
      { "<Leader>b", mode = { "n", "x", "o" }, "<cmd>HopWordBC<CR>",      desc = "カーソルより前の単語頭にhop" },
      { "f",         "<cmd>HopChar2AC<CR>",     desc = "カーソルより後ろの入力文字にhop" },
      { "F",         "<cmd>HopChar2BC<CR>",     desc = "カーソルより前の入力文字にhop" },
      { "t",
        -- function() require("hop").hint_char2({ direction = function() return require("hop.hint").HintDirection.AFTER_CURSOR end, current_line_only = true, hint_offset = -1 }) end,
        ":lua require('hop').hint_char2({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>",
        desc = "カーソル行内で指定文字の直前にhop"},
      {
        "T",
        function() require("hop").hint_char2({ direction = function() return require("hop.hint").HintDirection.BEFORE_CURSOR end, current_line_only = true, hint_offset = 1 }) end,
        desc = "カーソル行内で指定文字の直後にhop",
      },
  },
  config = function()
    require("hop").setup({
      -- 移動先ラベルキー
      keys                    = "asdghklqwertyuiopzxcvbnmfj",
      -- 中止キー
      quite_key               = "<Esc>",
      -- ジャンプ先が1つしかない場合は自動ジャンプする
      jump_on_sole_occurrence = true,
      -- HopChar* や HopPattern で大文字小文字を区別する
      case_insensitive        = true,
      -- 独自のハイライトを行う
      create_hl_autocmd       = true,
      -- ジャンプ位置の指定を開始位置にする
      hint_position           = require("hop.hint").HintPosition.BEGIN,
      -- ジャンプ位置のオフセット
      hint_offset             = 0,
      -- 現在行のみのモード
      current_lint_only       = false,
      -- ラベルを大文字で表示しない
      uppercase_labels        = false,
      -- バッファを超えて動作するか
      multi_windows           = false,
      -- direction               = nil,
      -- term_seq_bias           = 0.5,
      -- revirse_distribution    = false,
      -- teasing                 = true,
      -- char2_fallback_key      = nil,
      -- extensions              = nil,
    })
  end
}
