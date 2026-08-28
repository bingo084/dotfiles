-- Niri 26.04-like animations.
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- Niri's easing curves, approximated as cubic Bezier curves.
hl.curve("niriEaseOutExpo", {
	type = "bezier",
	points = { { 0.16, 1 }, { 0.3, 1 } },
})

hl.curve("niriEaseOutQuad", {
	type = "bezier",
	points = { { 0.5, 1 }, { 0.89, 1 } },
})

-- Niri uses mass 1 and critically damped springs.
hl.curve("niriWorkspace", {
	type = "spring",
	mass = 1,
	stiffness = 1000,
	dampening = 63.2456,
})

hl.curve("niriMovement", {
	type = "spring",
	mass = 1,
	stiffness = 800,
	dampening = 56.5685,
})

-- Fallback for animation leaves without a more specific definition.
hl.animation({ leaf = "global", enabled = true, speed = 1.5, bezier = "niriEaseOutExpo" })

-- Window open: scale from 50% and fade in over 150 ms.
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 1.5,
	bezier = "niriEaseOutExpo",
	style = "popin 50%",
})
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.5, bezier = "niriEaseOutExpo" })

-- Window close: scale to 80% and fade out over 150 ms.
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 1.5,
	bezier = "niriEaseOutQuad",
	style = "popin 80%",
})
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "niriEaseOutQuad" })

-- Hyprland combines Niri's horizontal view movement, window movement and resize.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, spring = "niriMovement" })

-- Niri workspaces are arranged vertically.
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 3,
	spring = "niriWorkspace",
	style = "slidevert",
})

-- Layer-shell surfaces have no exact Niri equivalent; use matching easing.
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.5, bezier = "niriEaseOutExpo", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "niriEaseOutQuad", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "niriEaseOutExpo" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "niriEaseOutQuad" })

hl.animation({ leaf = "border", enabled = true, speed = 1.5, bezier = "niriEaseOutExpo" })
