-- 少ないキー数で様々な場所に遷移できるモーションを提供
return {
  "phaazon/hop.nvim",
  lazy = true,
  enabled = true,
  branch = 'v2',
  event = { "BufReadPre" },
  keys = {
      {"<Leader>/", "<cmd>HopPattern<CR>", desc = "入力したパターンでhop"},
      {"<Leader>k", "<cmd>HopLineMW<CR>", desc = "すべてのバッファで行単位でhop"},
      {"<Leader>j", "<cmd>HopLineStartMW<CR>", desc = "すべてのバッファで行単位で行頭にhop"},
      {"<Leader>w", "<cmd>HopWordAC<CR>", desc = "カーソルより後ろの単語頭にhop"},
      {"<Leader>b", "<cmd>HopWordBC<CR>", desc = "カーソルより前の単語頭にhop"},
      {"f", "<cmd>HopChar2AC<CR>", desc = "カーソルより後ろの入力文字にhop"},
      {"F", "<cmd>HopChar2BC<CR>", desc = "カーソルより前の入力文字にhop"},
      {"t", function()
        require('hop').hint_char2({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = true, hint_offset = -1 })
       end, desc = "カーソル行内で指定文字の直前にhop"},
      {
        "T",
        function() require('hop').hint_char2({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = true, hint_offset = 1 }) end,
        desc = "カーソル行内で指定文字の直後にhop",
      },
  },
  config = function()
    require("hop").setup({
      keys = "asdghklqwertyuiopzxcvbnmfj",
      quite_key = "<Esc>",
      term_seq_bias = 0.5,
      revirse_distribution = false,
      teasing = true,
      jump_on_sole_occurrence = true,
      case_insensitive = true,
      create_hl_autocmd = true,
      direction = nil,
      hint_position = require("hop.hint").HintPosition.BEGIN,
      current_lint_only = false,
      upperCase_labels = false,
      char2_fallback_key = nil,
      extensions = nil,
      multi_windows = false,
    })
  end
}
