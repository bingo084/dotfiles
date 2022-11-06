#!/usr/bin/env bash

sketchybar  --add   item            ram_label right                 \
            --set   ram_label       label.font="$FONT:Regular:10.0" \
                                    label=RAM                       \
                                    y_offset=6                      \
                                    width=0                         \
            --add   item            ram_percentage right            \
            --set   ram_percentage  label.font="$FONT:Regular:10.0" \
                                    y_offset=-4                     \
                                    update_freq=1                   \
                                    script="$PLUGIN_DIR/ram.sh"
