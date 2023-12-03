-- バッファ左端のエリアをカスタマイズするプラグイン
return {
  "luukvbaal/statuscol.nvim",
  lazy = false,
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
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
  end
}
