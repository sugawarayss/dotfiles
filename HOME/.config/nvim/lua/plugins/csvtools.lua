local csvtools_ok, csvtools = pcall(require, "csvtools")
if not csvtools_ok then
  return
end

csvtools.setup({
  before = 10,
  after = 10,
  clearafter = true,
  showoverflow = false,
  titleflow = true,
})
