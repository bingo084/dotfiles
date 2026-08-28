-- https://wiki.hypr.land/Configuring/Basics/Variables/#gestures
hl.config({
	gestures = {
		workspace_swipe_distance = 350,
		workspace_swipe_min_speed_to_force = 10,
		workspace_swipe_cancel_ratio = 0.25,
		workspace_swipe_direction_lock = false,
		workspace_swipe_forever = true,
	},
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 2, direction = "pinch", mods = "SUPER", action = "cursor_zoom", mode = "live" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move", scale = 1.6 })
hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER", action = "move" })
local resize = function(event)
	hl.dispatch(hl.dsp.window.resize({ x = event.delta.x, y = event.delta.y, relative = true }))
end
hl.gesture({ fingers = 3, direction = "swipe", mods = "ALT", action = { update = resize } })
