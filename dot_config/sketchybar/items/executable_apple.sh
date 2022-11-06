#!/bin/bash

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_TOGGLE="sketchybar --set $NAME popup.drawing=toggle"

sketchybar --add item               apple.logo          left                                        \
           --set apple.logo         icon=$APPLE                                                     \
                                    icon.font="$FONT:Bold:17"                                       \
                                    icon.y_offset=1                                                 \
                                    label.drawing=off                                               \
                                    click_script="sketchybar --set \$NAME popup.drawing=toggle"  \
                                                                                                    \
           --add item               apple.preferences   popup.apple.logo                            \
           --set apple.preferences  icon=$PREFERENCES                                               \
                                    label="Preferences"                                             \
                                    click_script="open -a 'System Preferences'; $POPUP_OFF"         \
                                                                                                    \
           --add item               apple.finder        popup.apple.logo                            \
           --set apple.finder       icon=$FINDER                                                    \
                                    label="Finder"                                                  \
                                    click_script="open -a 'Finder'; $POPUP_OFF"                     \
                                                                                                    \
           --add item               apple.lock          popup.apple.logo                            \
           --set apple.lock         icon=$LOCK                                                      \
                                    label="Lock Screen"                                             \
                                    click_script="pmset displaysleepnow; $POPUP_OFF"
