#!/usr/bin/env bash

sketchybar  --add       item        yabai_mode  left                                \
            --set       yabai_mode  update_freq=3                                   \
                                    icon.width=20                                   \
                                    label.drawing=off                               \
                                    script="$PLUGIN_DIR/yabai_mode.sh"              \
                                    click_script="$PLUGIN_DIR/yabai_mode_click.sh"  \
            --subscribe yabai_mode  space_change
