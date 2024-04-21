-- 少ないキー数で様々な場所に遷移できるモーションを提供
return {
  "phaazon/hop.nvim",
  lazy = true,
  enabled = true,
  branch = 'v2',
  event = { "BufReadPre" },
  keys = {
      {"<Leader>/", function() require('hop').hint_patterns() end, desc = "hop to matched 'input pattern'"},
      {"<Leader>j", function() require('hop').hint_lines_skip_whitespace() end, desc = "hop to vertical line column"},
      {"<Leader>w", function() require('hop').hint_words({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = false}) end, desc = "hop to after cursor word"},
      {"<Leader>b", function() require('hop').hint_words({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = false}) end, desc = "hop to before cursor word"},
      {"f", function() require('hop').hint_char2({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = false }) end, desc = "hop to after cursor char in line"},
      {"F", function() require('hop').hint_char2({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = false }) end, desc = "hop to before cursor char in line"},
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
