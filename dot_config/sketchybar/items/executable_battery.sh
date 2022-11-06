#!/bin/bash

sketchybar  --add       item    battery right                   \
            --set       battery script="$PLUGIN_DIR/battery.sh" \
                                icon.padding_right=10           \
                                icon.font="$FONT:Light:17.0"    \
                                label.drawing=off               \
                                update_freq=10                  \
            --subscribe battery mouse.entered                   \
                                mouse.exited                    \
                                mouse.clicked                   \
            --add       item    battery.percentage popup.battery                         \
