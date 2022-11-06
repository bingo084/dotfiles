#/usr/bin/env bash

sketchybar  --add       item        animator left                \
            --set       animator    drawing=off                  \
                                    updates=on                   \
                                    script="$PLUGIN_DIR/wake.sh" \
            --subscribe             animator lock unlock
