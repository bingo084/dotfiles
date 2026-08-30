local navigation = require("utils.navigation")

local function global_bind(keys, dispatcher, options)
	local resolved = {}
	for name, value in pairs(options or {}) do
		resolved[name] = value
	end
	resolved.submap_universal = true
	return hl.bind(keys, dispatcher, resolved)
end

local function global_exec(keys, command, options)
	return global_bind(keys, hl.dsp.exec_cmd(command), options)
end

local locked = { locked = true }
local locked_repeating = { locked = true, repeating = true }

hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#binds
	binds = { movefocus_cycles_groupfirst = true, allow_pin_fullscreen = true },
})

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- Applications
global_exec("SUPER + RETURN", "kitty")
global_exec("SUPER + SPACE", "rofi -show")
global_exec("SUPER + B", "google-chrome-stable")
global_exec("SUPER + E", "nautilus")
global_exec("ALT + V", "cliphist list | rofi -dmenu | cliphist decode | wl-copy && wtype-paste")
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
global_exec("PRINT", "mark-shot")
global_exec("SUPER + P", "mark-shot")
-- Brightness
local brightness = "brightnessctl -c backlight -e4 -n2 set 1%"
global_exec("XF86MonBrightnessUp", brightness .. "+", locked_repeating)
global_exec("XF86MonBrightnessDown", brightness .. "-", locked_repeating)
-- Volume
local volume = "wpctl set-volume @DEFAULT_SINK@ -l 1.0 1%"
global_exec("XF86AudioRaiseVolume", volume .. "+", locked_repeating)
global_exec("XF86AudioLowerVolume", volume .. "-", locked_repeating)
global_exec("XF86AudioMute", "wpctl set-mute @DEFAULT_SINK@ toggle", locked)
global_exec("XF86AudioMicMute", "wpctl set-mute @DEFAULT_SOURCE@ toggle", locked)
-- Media
global_exec("XF86AudioPlay", "playerctl play-pause", locked)
global_exec("XF86AudioPause", "playerctl play-pause", locked)
global_exec("XF86AudioStop", "playerctl stop", locked)
global_exec("XF86AudioPrev", "playerctl previous", locked)
global_exec("XF86AudioNext", "playerctl next", locked)
-- Hyprland
global_exec("SUPER + CTRL + SHIFT + Q", "hyprshutdown")
-- Windows
global_bind("SUPER + W", hl.dsp.window.close())
global_bind("SUPER + Q", hl.dsp.window.kill())
global_bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
global_bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
global_bind("SUPER + T", hl.dsp.window.float())
global_bind("SUPER + O", hl.dsp.window.pin())
global_bind("ALT + mouse:272", hl.dsp.window.close())
-- Resize
hl.bind("SUPER + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	local function repeat_bind(keys, dispatcher)
		return hl.bind(keys, dispatcher, { repeating = true })
	end

	hl.bind("R", hl.dsp.layout("colresize +conf"))
	hl.bind("E", hl.dsp.layout("colresize -conf"))

	repeat_bind("H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
	repeat_bind("L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
	repeat_bind("J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))
	repeat_bind("K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))

	repeat_bind("SHIFT + H", hl.dsp.window.move({ x = -20, y = 0, relative = true }))
	repeat_bind("SHIFT + L", hl.dsp.window.move({ x = 20, y = 0, relative = true }))
	repeat_bind("SHIFT + J", hl.dsp.window.move({ x = 0, y = 20, relative = true }))
	repeat_bind("SHIFT + K", hl.dsp.window.move({ x = 0, y = -20, relative = true }))

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
global_bind("SUPER + H", hl.dsp.layout("focus l"))
global_bind("SUPER + L", hl.dsp.layout("focus r"))
global_bind("SUPER + J", navigation.focus_window_or_workspace_down)
global_bind("SUPER + K", navigation.focus_window_or_workspace_up)
global_bind("SUPER + SHIFT + mouse_up", hl.dsp.layout("move -col"))
global_bind("SUPER + SHIFT + mouse_down", hl.dsp.layout("move +col"))
-- Cycle focus
global_bind("ALT + TAB", hl.dsp.window.cycle_next())
global_bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
global_bind("SUPER + TAB", hl.dsp.focus({ workspace = "previous" }))
-- Move window
global_bind("SUPER + SHIFT + H", hl.dsp.layout("consume_or_expel prev"))
global_bind("SUPER + SHIFT + L", hl.dsp.layout("consume_or_expel next"))
global_bind("SUPER + SHIFT + J", navigation.move_window_down_or_to_workspace_down)
global_bind("SUPER + SHIFT + K", navigation.move_window_up_or_to_workspace_up)
-- Swap window
global_bind("SUPER + CTRL + H", hl.dsp.layout("swapcol l"))
global_bind("SUPER + CTRL + L", hl.dsp.layout("swapcol r"))
global_bind("SUPER + CTRL + J", hl.dsp.window.swap({ direction = "d" }))
global_bind("SUPER + CTRL + K", hl.dsp.window.swap({ direction = "u" }))
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
	global_bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	global_bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + mouse_down", navigation.focus_next_workspace)
hl.bind("SUPER + mouse_up", navigation.focus_previous_workspace)
-- Move workspace
hl.bind("SUPER + D", hl.dsp.submap("workspace"))
hl.define_submap("workspace", "reset", function()
	hl.bind("H", hl.dsp.workspace.move({ monitor = "l" }))
	hl.bind("L", hl.dsp.workspace.move({ monitor = "r" }))
	hl.bind("K", hl.dsp.workspace.move({ monitor = "u" }))
	hl.bind("J", hl.dsp.workspace.move({ monitor = "d" }))
end)
