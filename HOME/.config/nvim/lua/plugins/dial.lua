local dial_ok, _ = pcall(require, "dial")
if not dial_ok then
  return
end

-- more confiture, see this
-- https://github.com/monaqa/dial.nvim
local config = require("dial.config")
local augend = require("dial.augend")

config.augends:register_group {
  default = {
    augend.integer.alias.decimal,     -- 自然数
    augend.integer.alias.decimal_int, -- 負の数も含んだ数値
    augend.integer.alias.hex,         -- 16進数
    augend.integer.alias.octal,       -- 8進数
    augend.integer.alias.binary,      -- 2進数
    augend.constant.alias.bool,       -- true/false
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%H:%M:%S"],
    augend.constant.alias.ja_weekday_full, -- 月曜日, 火曜日, ...
    augend.constant.alias.alpha,           -- 小文字アルファベット
    augend.constant.alias.Alpha,           -- 大文字アルファベット
    augend.semver.alias.semver,            -- セマンティックバージョンナンバー
  },
}
local u = require("utils")
u.keymap("n", "<C-a>", require("dial.map").inc_normal())
u.keymap("n", "<C-x>", require("dial.map").dec_normal())
