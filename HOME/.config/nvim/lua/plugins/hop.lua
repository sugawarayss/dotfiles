-- 少ないキー数で様々な場所に遷移できるモーションを提供
return {
  "phaazon/hop.nvim",
  lazy = true,
  enabled = true,
  branch = 'v2',
  event = { "BufReadPre" },
  keys = {
      {"<Leader>/", "<cmd>HopPattern<CR>", desc = "hop to matched 'input pattern'"},
      {"<Leader>k", "<cmd>HopLineMW<CR>", desc = "hop line multi window"},
      {"<Leader>j", "<cmd>HopLineStartMW<CR>", desc = "hop to vertical lines column after cursor"},
      {"<Leader>w", "<cmd>HopWordAC<CR>", desc = "hop to after cursor word"},
      {"<Leader>b", "<cmd>HopWordBC<CR>", desc = "hop to before cursor word"},
      {"f", "<cmd>HopChar2AC<CR>", desc = "hop to after cursor char in line"},
      {"F", "<cmd>HopChar2BC<CR>", desc = "hop to before cursor char in line"},
      {"t", function() require('hop').hint_char2({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = false, hint_offset = -1 }) end, desc = "hop to after cursor char in line"},
      {"T", function() require('hop').hint_char2({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = false, hint_offset = 1 }) end, desc = "hop to before cursor char in line"},
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
