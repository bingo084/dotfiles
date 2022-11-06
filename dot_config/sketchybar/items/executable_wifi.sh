#!/bin/bash

sketchybar  --add       item    wifi right                      \
            --set       wifi    script="$PLUGIN_DIR/wifi.sh"    \
                                update_freq=20                  \
                                label.drawing=off               \
            --subscribe wifi    mouse.entered                   \
                                mouse.exited                    \
                                mouse.clicked                   \
            --add       item    wifi.ssid   popup.wifi          \
            --add       item    wifi.txrate popup.wifi                        
