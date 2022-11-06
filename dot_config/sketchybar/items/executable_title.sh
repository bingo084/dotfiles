#!/bin/bash

sketchybar  --add       item    title left                                          \
            --set       title   associated_display=active                           \
                                icon.drawing=off                                    \
                                script="sketchybar --set \$NAME label=\"\$INFO\""   \
            --subscribe title   front_app_switched
            # background.drawing=on                               \
            # background.border_color=$WHITE                      \
            # background.border_width=$BACKGROUND_BORDER_WIDTH    \
            # background.height=$BACKGROUND_HEIGHT                \
            # background.corner_radius=$CORNER_RADIUS             \
