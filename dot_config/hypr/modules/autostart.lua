-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprlock --immediate")
	hl.exec_cmd("google-chrome-stable", { workspace = 1 })
	hl.exec_cmd("Telegram", { workspace = 2 })
	-- Start rbw-agent to SSH requests
	hl.exec_cmd("rbw sync")
	hl.exec_cmd([[
    hyprpm reload || kitty --class hyprpm-update sh -lc '
      if hyprpm update; then
        hyprctl reload
      else
        printf "\nUpdate failed. Press Enter to close."
        read -r _
      fi
    '
  ]])
end)
