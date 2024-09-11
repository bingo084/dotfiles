#!/bin/sh

handle() {
  case $1 in
  monitoradded* | monitorremoved*)
    echo "$1" | grep -q "eDP-1" && return
    echo "Monitor added or removed, checking monitor status..."
    monitor_count=$(hyprctl monitors -j | jq '. | length')

    if [ "$monitor_count" -gt 1 ]; then
      echo "More than one monitor detected, disabling eDP-1..."
      hyprctl keyword monitor eDP-1, disable
      hyprctl dispatch workspace 1
    elif [ "$monitor_count" -eq 0 ]; then
      echo "Only one monitor detected, enabling eDP-1..."
      hyprctl keyword monitor eDP-1, preferred, auto, 1
      hyprctl dispatch workspace 1
    fi
    ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
