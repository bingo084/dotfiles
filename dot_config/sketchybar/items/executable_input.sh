#!/usr/bin/env bash

sketchybar  --add       item    input right                     \
            --set       input   script="$PLUGIN_DIR/input.sh"   \
            --subscribe input   input_change
