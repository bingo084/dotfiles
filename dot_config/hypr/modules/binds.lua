local navigation = require("utils.navigation")

hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#binds
	binds = { movefocus_cycles_groupfirst = true, allow_pin_fullscreen = true },
})

local terminal = "kitty"
local fileManager = "dolphin"
local browser = "google-chrome-stable"
local launcher = "rofi -show"
local screenshot = "mark-shot"

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- Applications
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("ALT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy && wtype-paste"))
-- Notifications
hl.bind("SUPER + N", hl.dsp.submap("notify"))
hl.define_submap("notify", "reset", function()
	hl.bind("D", hl.dsp.exec_cmd("dunstctl close-all"))
	hl.bind("T", hl.dsp.exec_cmd("dunstctl set-paused toggle"))
end)
hl.define_submap("notify", function()
	hl.bind("P", hl.dsp.exec_cmd("dunstctl history-pop"), { repeating = true })
	hl.bind("catchall", hl.dsp.submap("reset"))
end)
-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot))
hl.bind("SUPER + P", hl.dsp.exec_cmd(screenshot))
-- Brightness
local brightness = "brightnessctl -c backlight -e4 -n2 set 1%"
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightness .. "+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightness .. "-"), { locked = true, repeating = true })
-- Volume
local volume = "wpctl set-volume @DEFAULT_SINK@ -l 1.0 1%"
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. "+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. "-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- Hyprland
hl.bind("SUPER + CTRL + SHIFT + Q", hl.dsp.exec_cmd("hyprshutdown"))
-- Windows
hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + Q", hl.dsp.window.kill())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + T", hl.dsp.window.float())
hl.bind("SUPER + O", hl.dsp.window.pin())
hl.bind("ALT + mouse:272", hl.dsp.window.close())
-- Resize
hl.bind("SUPER + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("R", hl.dsp.layout("colresize +conf"))
	hl.bind("E", hl.dsp.layout("colresize -conf"))

	hl.bind("H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })

	hl.bind("SHIFT + H", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + L", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + J", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("SHIFT + K", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })

	hl.bind("C", hl.dsp.window.center())
	hl.bind("F", hl.dsp.window.fullscreen({ mode = "maximized" }))
	hl.bind("SHIFT + F", hl.dsp.window.fullscreen())
	hl.bind("O", hl.dsp.window.pin())
	hl.bind("T", hl.dsp.window.float())

	hl.bind("catchall", hl.dsp.submap("reset"))
end)
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- Move focus
hl.bind("SUPER + H", hl.dsp.layout("focus l"), { submap_universal = true })
hl.bind("SUPER + L", hl.dsp.layout("focus r"), { submap_universal = true })
hl.bind("SUPER + J", navigation.focus_window_or_workspace_down, { submap_universal = true })
hl.bind("SUPER + K", navigation.focus_window_or_workspace_up, { submap_universal = true })
-- Cycle focus
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "previous" }))
-- Move window
hl.bind("SUPER + SHIFT + H", hl.dsp.layout("consume_or_expel prev"))
hl.bind("SUPER + SHIFT + L", hl.dsp.layout("consume_or_expel next"))
hl.bind("SUPER + SHIFT + J", navigation.move_window_down_or_to_workspace_down)
hl.bind("SUPER + SHIFT + K", navigation.move_window_up_or_to_workspace_up)
-- Swap window
hl.bind("SUPER + CTRL + H", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + CTRL + L", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + CTRL + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind("SUPER + CTRL + K", hl.dsp.window.swap({ direction = "u" }))
-- Groups
hl.bind("SUPER + G", hl.dsp.submap("group"))
hl.define_submap("group", function()
	hl.bind("G", hl.dsp.group.toggle())
	hl.bind("CTRL + L", hl.dsp.group.lock())
	hl.bind("H", hl.dsp.focus({ direction = "l" }))
	hl.bind("J", hl.dsp.focus({ direction = "d" }))
	hl.bind("K", hl.dsp.focus({ direction = "u" }))
	hl.bind("L", hl.dsp.focus({ direction = "r" }))
	hl.bind("catchall", hl.dsp.submap("reset"))
end)
-- Workspaces
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
-- Move workspace
hl.bind("SUPER + D", hl.dsp.submap("workspace"))
hl.define_submap("workspace", "reset", function()
	hl.bind("H", hl.dsp.workspace.move({ monitor = "l" }))
	hl.bind("L", hl.dsp.workspace.move({ monitor = "r" }))
	hl.bind("K", hl.dsp.workspace.move({ monitor = "u" }))
	hl.bind("J", hl.dsp.workspace.move({ monitor = "d" }))
end)
