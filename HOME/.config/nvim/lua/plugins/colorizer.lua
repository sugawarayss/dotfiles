local colorizer_ok, colorizer = pcall(require, "colorizer")
if not colorizer_ok then
  return
end

require("colorizer").setup({
  "*", -- Highligt all files
})
