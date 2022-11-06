#!/usr/bin/env bash

sketchybar  --add   item    weather right                           \
            --set   weather update_freq=600                         \
                            script="$PLUGIN_DIR/weather.sh"         \
                            icon.font="qweather-icons:Regular:14.0"
