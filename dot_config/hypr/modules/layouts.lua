hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
	general = {
		layout = "scrolling",
		no_focus_fallback = true,
		resize_on_border = true,
		snap = { enabled = true },
	},
	-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/#config
	scrolling = {
		fullscreen_on_one_column = false,
		follow_min_visible = 0.3,
		explicit_column_widths = "0.4, 0.5, 0.6, 1.0",
		wrap_swapcol = false,
	},
})
