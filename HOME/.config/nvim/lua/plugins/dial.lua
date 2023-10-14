-- インクリメント(C-A) / デクリメント(C-X) を賢く
return {
  "monaqa/dial.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  lazy = false,
  --keys = {
  --  { "<C-a>",  function() require("dial.map").inc_normal() end, mode = "n" },
  --  { "<C-x>",  function() require("dial.map").dec_normal() end, mode = "n" },
  --},
  config = function()
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
  end
}
