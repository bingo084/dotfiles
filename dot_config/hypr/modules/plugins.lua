-- hyprpm add https://github.com/yayuuu/hyprland-scroll-overview.git
-- .config/hypr/hyprland.lua
if hl.plugin.scrolloverview then
	hl.config({
		plugin = {
			scrolloverview = {
				gesture_distance = 300, -- how far is the "max" for the gesture
				scale = 0.5, -- preferred overview scale
				workspace_gap = 100,
				layout = "vertical", -- vertical or horizontal
				wallpaper = 2, -- 0: global only, 1: per-workspace only, 2: both
				blur = true, -- blur only the main overview wallpaper

				shadow = {
					enabled = true,
					range = 50,
				},
			},
		},
	})

	-- Toggle ScrollOverview
	hl.bind("SUPER + Escape", function()
		hl.plugin.scrolloverview.overview("toggle all")
	end)
end
