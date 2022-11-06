#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

sketchybar  --add       item            volume right                    \
            --set       volume          script="$PLUGIN_DIR/volume.sh"  \
                                        label.drawing=off               \
                                        popup.horizontal=on             \
                                        popup.align=center              \
            --subscribe volume          volume_change                   \
                                        mouse.entered                   \
                                        mouse.exited.global             \
                                        mouse.clicked                   \
            --add       item            volume.minus    popup.volume    \
            --set       volume.minus    icon=$VOLUME_MINUS              \
                                        click_script="osascript -e \"set volume output volume (output volume of (get volume settings) - 6)\""\
            --add       item            volume.level    popup.volume    \
            --set       volume.level    icon.drawing=off                \
            --add       item            volume.plus     popup.volume    \
            --set       volume.plus     icon=$VOLUME_PLUS               \
                                        click_script="osascript -e \"set volume output volume (output volume of (get volume settings) + 6)\""
