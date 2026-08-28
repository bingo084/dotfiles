hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
	general = {
		border_size = 2,
		gaps_in = 2,
		gaps_out = 4,
		col = { inactive_border = "rgba(adc6ff19)", active_border = "rgba(adc6ff33)" },
	},
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
	decoration = {
		rounding = 10,
		rounding_power = 4.0,
		blur = { size = 5, passes = 3, input_methods = true },
		shadow = { range = 60, color = "0xaa1a1a1a", color_inactive = "0x331a1a1a" },
	},
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#group
	group = { groupbar = { font_size = 12 } },
})
