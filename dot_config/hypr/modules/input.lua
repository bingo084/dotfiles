hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
	input = {
		accel_profile = "flat",
		-- Refocus only after crossing a window boundary.
		mouse_refocus = false,
		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.3,
		},
	},
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
	cursor = { no_warps = true },
})
