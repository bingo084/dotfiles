-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Multi-GPU/
local drm = require("utils.drm")
local drm_devices = drm.preferred_devices()
if #drm_devices > 0 then
	hl.env("AQ_DRM_DEVICES", table.concat(drm_devices, ":"))
end

-- https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")
hl.env("QT_IM_MODULE", "fcitx")
