-- csvを色付け
return {
  "Decodetalkers/csv-tools.lua",
  config = function()
    require("csvtools").setup({
      before = 10,
      after = 10,
      clearafter = true,
      showoverflow = false,
      titleflow = true,
    })
  end
}
