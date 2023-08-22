local surround_ok, surround = pcall(require, "nvim-surround")
if not surround_ok then
  return
end

surround.setup({
  -- keymaps      =  --Defines plugin keymaps
  keymaps = {
    insert = "<C-g>s",
    insert_line = "<C-g>S",
    normal = "ys",  -- yank surround
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",  -- delete surround
    change = "cs",  -- change surround
  },
  -- surrounds    =  --Defines surround keys and behavior
  -- aliases      =  --Defines aliases
  aliases = {
    -- same as Default
    ["x"] = ">",
    ["b"] = ")",
    ["c"] = "}",
    ["v"] = "]",
    ["q"] = {'"', "'", "`"},
    ["s"] = {"}", "]", ")", ">", '"', "'", "`"},
  },
  -- highlight    =  --Defines highlight behavior
  -- move_cursor  =  --Defines cursor behavior
  -- indent_lines =  --Defines line indentation behavior
})
