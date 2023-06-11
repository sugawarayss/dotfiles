local nightfox_ok, nightfox = pcall(require, "nightfox")
if not nightfox_ok then
  return
end

if nightfox then
  nightfox.setup({
    options = {
      transparent = false,
    }
  })
  vim.cmd("colorscheme carbonfox")
end
