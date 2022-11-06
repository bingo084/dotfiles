#!/usr/bin/env bash

sketchybar  --add   item            network_up right                    \
            --set   network_up      label.font="$FONT:Bold:9"           \
                                    icon.font="$FONT:Bold:6"            \
                                    icon=$NETWORK_ARROWUP               \
                                    icon.highlight_color=$GREEN         \
                                    y_offset=5                          \
                                    width=0                             \
                                    updates=on                          \
                                    update_freq=2                       \
                                    script="$PLUGIN_DIR/network.sh"     \
                                                                        \
            --add   item            network_down right                  \
            --set   network_down    label.font="$FONT:Bold:9"           \
                                    icon.font="$FONT:Bold:6"            \
                                    icon=$NETWORK_ARROWDOWN             \
                                    icon.highlight_color=$GREEN         \
                                    y_offset=-5                         \
                                    updates=on                          \
                                    update_freq=2                       \
                                    script="$PLUGIN_DIR/network.sh"
