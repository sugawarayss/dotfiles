local statuscol_ok, statucsol = pcall(require, "statuscol")
if not statuscol_ok then
  return
end
local builtin = require("statuscol.builtin")
statucsol.setup({
  setopt = true,
  relculright = true,
  segments = {
    {
      text = { builtin.foldfunc, " " },
      click = "v:lua.ScFa",
      hl = "Comment",
    },
    { text = { "%s" }, click = "v:lua.ScSa" },
    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
  },
})
