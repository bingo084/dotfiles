#!/usr/bin/env bash

sketchybar  --add   item        messages right                  \
            --set   messages    update_freq=10                  \
                                updates=on                      \
                                icon=$MESSAGE                   \
                                script="$PLUGIN_DIR/messages.sh"\
                                click_script="open -a Messages"
