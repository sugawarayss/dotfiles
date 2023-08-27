local scrollbar_ok, scrollbar = pcall(require, "scrollbar")
if not scrollbar_ok then
  return
end
local mocha = require("catppuccin.palettes").get_palette "mocha"
scrollbar.setup({
  handle = {
    color = mocha.surface2,
  },
  marks = {
    Search = { color = mocha.rosewater},
    Error = { color = mocha.red },
    Warn = { color = mocha.yellow },
    Info = { color = mocha.green },
    Hint = { color = mocha.sapphire },
    Misc = { color = mocha.lavender},
  },
  handlers = {
    search = true
  }
})
