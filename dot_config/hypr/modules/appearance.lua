local colors = require("generated.colors")

hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
	general = {
		border_size = 0,
		gaps_in = 3,
		gaps_out = 6,
	},
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
	decoration = {
		rounding = 10,
		rounding_power = 4.0,
		blur = { size = 5, passes = 3, input_methods = true },
		shadow = {
			range = 60,
			color = colors.shadow[40],
			color_inactive = colors.shadow[20],
		},
	},
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#group
	group = {
		groupbar = {
			render_titles = false,
			rounding = 3,
			round_only_edges = false,
			col = {
				active = colors.primary[100],
				inactive = colors.primary[30],
				locked_active = colors.error[100],
				locked_inactive = colors.error[30],
			},
		},
	},
})
