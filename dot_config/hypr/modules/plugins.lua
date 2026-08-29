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

		local shift_pressed = {}

		local function update_scrolling_mode()
			hl.config({
				plugin = {
					scrolloverview = {
						input = {
							scrolling_mode = next(shift_pressed) and 1 or 0,
						},
					},
				},
			})
		end

		local function bind_scroll_modifier(key)
			hl.bind(key, function()
				shift_pressed[key] = true
				update_scrolling_mode()
			end, { transparent = true, non_consuming = true })

			hl.bind("SHIFT + " .. key, function()
				shift_pressed[key] = nil
				update_scrolling_mode()
			end, {
				release = true,
				transparent = true,
				non_consuming = true,
				submap_universal = true,
			})
		end

		update_scrolling_mode()
		bind_scroll_modifier("Shift_L")
		bind_scroll_modifier("Shift_R")
	end)
end
