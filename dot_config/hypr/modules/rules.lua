-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
hl.window_rule({
	name = "no-border-for-floating",
	match = { float = true },
	border_size = 0,
})
hl.window_rule({
	name = "float-some-windows",
	match = { class = "pavucontrol|blueman-manager" },
	float = true,
})
hl.window_rule({
	name = "float-some-windows",
	match = { title = "图片查看器|图片|预览|群聊的聊天记录|Media viewer|画中画" },
	float = true,
})
hl.window_rule({
	name = "telegram",
	match = { class = "org.telegram.desktop" },
	scroll_mouse = 1.2,
	scroll_touchpad = 1.2,
})

hl.layer_rule({
	match = { namespace = "gtk4-layer-shell|notifications" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.1,
})
