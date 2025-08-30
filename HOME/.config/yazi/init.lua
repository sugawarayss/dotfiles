-- ラインモードのカスタム表示
function Linemode:mtime()
  -- 更新日時
  local time math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    time = os.date("%Y/%m/%d %H:%M", time)
  else
    time = os.date("%Y/%m/%d", time)
  end
  return string.format("%s", time)
end

function Linemode:btime()
  -- 作成日時
  local time math.floor(self._file.cha.btime or 0)
  if time == 0 then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    time = os.date("%Y/%m/%d %H:%M", time)
  else
    time = os.date("%Y/%m/%d", time)
  end
  return string.format("%s", time)
end

function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%Y-%m-%d %H:%M", time)
	else
		time = os.date("%Y-%m-%d %H:%M", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- full-border plugin configuration
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	-- type = ui.Border.ROUNDED,
}

-- starship plugin configuration
-- INFO: full-border プラグインを互換なし
-- require("starship"):setup({
--     -- Hide flags (such as filter, find and search). This is recommended for starship themes which
--     -- are intended to go across the entire width of the terminal.
--     hide_flags = false, -- Default: false
--     -- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
--     flags_after_prompt = true, -- Default: true
--     -- Custom starship configuration file to use
--     config_file = "~/.config/starship_full.toml", -- Default: nil
-- })

-- yazi bookmark plugin configuration
local bookmarks = {}

local path_sep = package.config:sub(1, 1)
local home_path = ya.target_family() == "windows" and os.getenv("USERPROFILE") or os.getenv("HOME")
if ya.target_family() == "windows" then
  table.insert(bookmarks, {
    tag = "Scoop Local",

    path = (os.getenv("SCOOP") or home_path .. "\\scoop") .. "\\",
    key = "p"
  })
  table.insert(bookmarks, {
    tag = "Scoop Global",
    path = (os.getenv("SCOOP_GLOBAL") or "C:\\ProgramData\\scoop") .. "\\",
    key = "P"
  })
end
table.insert(bookmarks, {
  tag = "Desktop",
  path = home_path .. path_sep .. "Desktop" .. path_sep,
  key = "d"
})

require("yamb"):setup {
  -- Optional, the path ending with path seperator represents folder.
  bookmarks = bookmarks,
  -- Optional, recieve notification everytime you jump.
  jump_notify = true,
  -- Optional, the cli of fzf.
  cli = "fzf",
  -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  -- Optional, the path of bookmarks
  path = (ya.target_family() == "windows" and os.getenv("APPDATA") .. "\\yazi\\config\\bookmark") or
        (os.getenv("HOME") .. "/.config/yazi/bookmark"),
}
