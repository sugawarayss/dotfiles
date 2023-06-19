local scrollbar_ok, scrollbar = pcall(require, "scrollbar")
if not scrollbar_ok then
  return
end

local colors = require("tokyonight.colors").setup()
scrollbar.setup({
  handle = {
    color = colors.bg_highlight,
  },
  marks = {
    Search = { color = colors.orange },
    Error = { color = colors.error },
    Warn = { color = colors.warning },
    Info = { color = colors.info },
    Hint = { color = colors.hint },
    Misc = { color = colors.purple },
  },
  handlers = {
    search = true
  }
})
