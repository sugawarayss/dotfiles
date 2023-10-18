-- 少ないキー数で様々な場所に遷移できるモーションを提供
return {
  "phaazon/hop.nvim",
  lazy = true,
  branch = 'v2',
  event = { "BufReadPre" },
  keys = {
    {"<Leader>/", function() require('hop').hint_patterns() end, desc = "hop to matched 'input pattern'"},
    {"<Leader>v", function() require('hop').hint_vertical() end, desc = "hop to vertical line column"},
    {"<Leader>w", function() require('hop').hint_words({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = true}) end, desc = "hop to after cursor word"},
    {"<Leader>b", function() require('hop').hint_words({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = true}) end, desc = "hop to before cursor word"},
    {"f", function() require('hop').hint_char1({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = true }) end, desc = "hop to after cursor char in line"},
    {"F", function() require('hop').hint_char1({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = true }) end, desc = "hop to before cursor char in line"},
    {"t", function() require('hop').hint_char1({ direction = function() return require('hop.hint').HintDirection.AFTER_CURSOR end, current_line_only = true, hint_offset = -1 }) end, desc = "hop to after cursor char in line"},
    {"T", function() require('hop').hint_char1({ direction = function() return require('hop.hint').HintDirection.BEFORE_CURSOR end, current_line_only = true, hint_offset = 1 }) end, desc = "hop to before cursor char in line"},
  },
  config = function()
    require("hop").setup()
  end
}
