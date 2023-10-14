-- 少ないキー数で様々な場所に遷移できるモーションを提供
return {
  "phaazon/hop.nvim",
  branch = 'v2',
  keys = {
    {"<Leader>/", function() require('hop').hint_patterns() end},
    {"<Leader>v", function() require('hop').hint_vertical() end},
    {"<Leader>w", function() require('hop').hint_words({ direction = directions.AFTER_CURSOR, current_line_only = true}) end},
    {"<Leader>b", function() require('hop').hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = true}) end},
    {"f", function() require('hop').hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end},
    {"F", function() require('hop').hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end},
    {"t", function() require('hop').hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end},
    {"T", function() require('hop').hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end},
  },
  config = function()
    require("hop").setup()
  end
}
