-- hyprpm add https://github.com/yayuuu/hyprland-scroll-overview.git
-- .config/hypr/hyprland.lua
if hl.plugin.scrolloverview then
	hl.config({
		plugin = {
			scrolloverview = {
				gesture_distance = 350,
				wallpaper = 2,
				blur = true,
				input = {
					touchpad_scroll_factor = 3.3,
				},
				shadow = {
					enabled = true,
				},
			},
		},
	})

	-- Toggle ScrollOverview
	hl.bind("SUPER + ESCAPE", function()
		hl.plugin.scrolloverview.overview("toggle all")
	end)
	hl.plugin.scrolloverview.gesture({ fingers = 4, direction = "vertical" })
	hl.define_submap("scrolloverview", function()
		hl.bind("H", hl.plugin.scrolloverview.navigate("left"))
		hl.bind("L", hl.plugin.scrolloverview.navigate("right"))
		hl.bind("J", hl.plugin.scrolloverview.navigate("down"))
		hl.bind("K", hl.plugin.scrolloverview.navigate("up"))
		hl.bind("RETURN", hl.plugin.scrolloverview.overview("off"))
		hl.bind("ESCAPE", hl.plugin.scrolloverview.overview("off"))
		hl.bind("mouse:272", function()
			hl.plugin.scrolloverview.overview("select")
			hl.plugin.scrolloverview.window("select")
			hl.plugin.scrolloverview.overview("off")
		end)
		hl.bind("mouse:274", hl.plugin.scrolloverview.window("close"))
		hl.bind("SHIFT + mouse_up", hl.plugin.scrolloverview.navigate("left"))
		hl.bind("SHIFT + mouse_down", hl.plugin.scrolloverview.navigate("right"))
	end)
end
