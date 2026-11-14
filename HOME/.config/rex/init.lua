-- Rex config migrated from zellij, Herdr, Ghostty and iTerm2.

------------------------------------------------------------------------
-- Herdr (~/.config/herdr/config.toml), prefix ctrl+b
------------------------------------------------------------------------
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+b>shift+s", "client.settings")
rex.bind("ctrl+b>shift+n", "session.new")
rex.bind("ctrl+b>shift+w", "session.rename")
rex.bind("ctrl+b>shift+d", "session.close")
rex.bind("ctrl+b>w", "session.switch")
rex.bind("ctrl+b>g", "session.switch")
rex.bind("ctrl+b>shift+r", "client.config.reload")
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>shift+t", "client.tab.rename")
rex.bind("ctrl+b>p", "client.tab.previous")
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+b>2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+b>3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+b>4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+b>5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+b>6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+b>7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+b>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+b>9", "client.tab.goto", { index = 9 })
rex.bind("ctrl+b>shift+x", "client.tab.close")
rex.bind("ctrl+b>shift+p", "pane.rename")
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>shift+h", "pane.move", { direction = "left" })
rex.bind("ctrl+b>shift+j", "pane.move", { direction = "down" })
rex.bind("ctrl+b>shift+k", "pane.move", { direction = "up" })
rex.bind("ctrl+b>shift+l", "pane.move", { direction = "right" })
rex.bind("ctrl+b>tab", "pane.focus_next")
rex.bind("ctrl+b>shift+tab", "pane.focus_previous")
rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>s", "pane.split", { direction = "down" })
rex.bind("ctrl+b>x", "pane.close")
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>b", "client.sidebar.toggle")
rex.bind("alt+left", "pane.resize", { direction = "left" })
rex.bind("alt+down", "pane.resize", { direction = "down" })
rex.bind("alt+up", "pane.resize", { direction = "up" })
rex.bind("alt+right", "pane.resize", { direction = "right" })

rex.mode("resize", { exclusive = true })
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/escape", "client.mode.exit")
rex.bind("ctrl+b>r", "client.mode.enter", { name = "resize" })
rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/down", "pane.resize", { direction = "down" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/right", "pane.resize", { direction = "right" })

------------------------------------------------------------------------
-- Ghostty (~/.config/ghostty/config)
------------------------------------------------------------------------
rex.bind("cmd+l", "pane.split", { direction = "right" })
rex.bind("cmd+j", "pane.split", { direction = "down" })
rex.bind("cmd+;", "client.config.reload")
rex.bind("ctrl+alt+shift+l", "pane.focus", { direction = "right" })
rex.bind("ctrl+alt+shift+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+alt+shift+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+alt+shift+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+alt+shift+tab", "pane.focus_next")
rex.bind("cmd+c", "pane.copy")
rex.bind("cmd+v", "pane.paste")

------------------------------------------------------------------------
-- zellij (~/.config/zellij/config.kdl, clear-defaults=true)
------------------------------------------------------------------------
rex.action{
  name  = "then_normal",
  title = "Run an action and return to normal mode",
  args  = { action = "string", args = "object?" },
  run   = function(ctx, args)
    rex.client.queue(args.action, args.args or {})
    rex.client.queue("client.mode.exit_all")
  end,
}

local zellij_modes = { "pane", "tab", "resize", "move" }
for _, mode in ipairs({ "pane", "tab", "move" }) do
  rex.mode(mode, { exclusive = true })
  rex.bind(mode .. "/enter", "client.mode.exit")
  rex.bind(mode .. "/esc", "client.mode.exit")
end

-- shared_except "locked": no mode and every zellij mode
local function bind_shared(key, action, args, except_mode)
  rex.bind(key, action, args)
  for _, mode in ipairs(zellij_modes) do
    if mode ~= except_mode then rex.bind(mode .. "/" .. key, action, args) end
  end
end
-- alt+h/j/k/l/i はnvim（edgemotion・snacks）と衝突するため外した。ペイン移動は ctrl+b>h/j/k/l を使う
bind_shared("alt+o", "client.tab.move", { direction = "forward" })
bind_shared("alt+n", "pane.split", { direction = "auto" })
bind_shared("ctrl+p", "client.mode.enter", { name = "pane" }, "pane")
bind_shared("ctrl+t", "client.mode.enter", { name = "tab" }, "tab")
bind_shared("ctrl+n", "client.mode.enter", { name = "resize" }, "resize")
bind_shared("ctrl+h", "client.mode.enter", { name = "move" }, "move")

-- pane
for key, dir in pairs({ left = "left", down = "down", up = "up", right = "right", h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("pane/" .. key, "pane.focus", { direction = dir })
end
rex.bind("pane/c", "then_normal", { action = "pane.rename" })
rex.bind("pane/d", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("pane/f", "then_normal", { action = "pane.zoom" })
rex.bind("pane/n", "then_normal", { action = "pane.split", args = { direction = "auto" } })
rex.bind("pane/p", "pane.focus_next")
rex.bind("pane/ctrl+p", "client.mode.exit")
rex.bind("pane/r", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("pane/x", "then_normal", { action = "pane.close" })

-- tab
for _, key in ipairs({ "left", "up", "h", "k" }) do rex.bind("tab/" .. key, "client.tab.previous") end
for _, key in ipairs({ "down", "right", "j", "l" }) do rex.bind("tab/" .. key, "client.tab.next") end
for index = 1, 9 do
  rex.bind("tab/" .. index, "then_normal", { action = "client.tab.goto", args = { index = index } })
end
rex.bind("tab/b", "then_normal", { action = "pane.move_to_new_tab" })
rex.bind("tab/n", "then_normal", { action = "client.tab.new" })
rex.bind("tab/r", "then_normal", { action = "client.tab.rename" })
rex.bind("tab/ctrl+t", "client.mode.exit")
rex.bind("tab/x", "then_normal", { action = "client.tab.close" })

-- resize (arrows, enter and escape come from Herdr's resize mode above)
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = dir })
end
rex.bind("resize/ctrl+n", "client.mode.exit")

-- move
for key, dir in pairs({ left = "left", down = "down", up = "up", right = "right", h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("move/" .. key, "pane.move", { direction = dir })
end
rex.bind("move/ctrl+h", "client.mode.exit")
