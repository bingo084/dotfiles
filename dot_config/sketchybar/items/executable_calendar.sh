#!/bin/bash

sketchybar  --add   item        calendar    right                   \
            --set   calendar    update_freq=2                       \
                                icon.color=$BLACK                   \
                                label.color=$BLACK                  \
                                width=140                           \
                                align=center                        \
                                background.color=0xffe8e8e9         \
                                background.height=16                \
                                background.corner_radius=10         \
                                script="$PLUGIN_DIR/calendar.sh"    \
                                click_script="open -a Calendar"
