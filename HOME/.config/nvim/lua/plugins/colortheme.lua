local tokyonight_ok, tokyonight = pcall(require, "tokyonight")
if not tokyonight_ok then
  return
end
tokyonight.setup({
    style = "night",
  },
  vim.cmd [[colorscheme tokyonight]]
)
