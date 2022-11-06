#!/usr/bin/env bash

sketchybar  --add       item        vpn right                   \
            --set       vpn         icon=$VPN                   \
                                    label.drawing=off           \
                                    update_freq=60              \
                                    script="$PLUGIN_DIR/vpn.sh" \
            --subscribe vpn         mouse.clicked               \
                                    mouse.entered               \
                                    mouse.exited.global         \
            --add       item        vpn.global  popup.vpn       \
            --set       vpn.global  label=Global                \
                                    icon.drawing=off            \
                                    script="$PLUGIN_DIR/vpn.sh" \
            --subscribe vpn.global  mouse.clicked               \
            --add       item        vpn.rule  popup.vpn         \
            --set       vpn.rule    label=Rule                  \
                                    icon.drawing=off            \
                                    script="$PLUGIN_DIR/vpn.sh" \
            --subscribe vpn.rule    mouse.clicked               \
            --add       item        vpn.direct  popup.vpn       \
            --set       vpn.direct  label=Direct                \
                                    icon.drawing=off            \
                                    script="$PLUGIN_DIR/vpn.sh" \
            --subscribe vpn.direct  mouse.clicked               \

