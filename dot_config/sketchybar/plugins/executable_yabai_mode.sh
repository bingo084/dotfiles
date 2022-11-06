#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$yabai_mode" in
    bsp)
    sketchybar -m --set yabai_mode icon="$BSP"
    ;;
    stack)
    sketchybar -m --set yabai_mode icon="$STACK"
    ;;
    float)
    sketchybar -m --set yabai_mode icon="$FLOAT"
    ;;
esac
