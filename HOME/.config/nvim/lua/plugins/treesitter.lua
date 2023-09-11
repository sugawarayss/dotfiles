local treesitter_ok, treesitter = pcall(require, "nvim-treesitter")
if not treesitter_ok then
  return
end

local configs = require("nvim-treesitter.configs")
configs.setup {
  ensure_installed = {"bash", "c", "lua", "vim", "vimdoc", "python", "rust", "go", "ruby", "typescript", "toml", "yaml"},
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = {
    enable = true, --言語に応じた自動インデント
    --disable = { "html" }, --htmlだけ自動インデントしない
  },
  autotag = {
    enable = true,
  },
  matchup = {
    enable = true,
  }
}

local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
ts_update()
