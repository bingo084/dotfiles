#!/usr/bin/env bash

sketchybar  --add   item        reminders   right                   \
            --set   reminders   update_freq=20                      \
                                icon="$REMINDERS"                   \
                                icon.color=$BLUE                    \
                                label.color=$BLUE                   \
                                script="$PLUGIN_DIR/reminders.sh"   \
                                click_script="open -a Reminders"
