#!/bin/bash

args=()
if [ "$NAME" != "space_template" ]; then
  args+=(--set $NAME label=$NAME \
                     icon.highlight=$SELECTED)
fi

if [ "$SELECTED" = "true" ]; then
  args+=(--set display_$DID.label label=${NAME#"space."})
  args+=(--set $NAME icon.background.y_offset=-12)
else
  args+=(--set $NAME icon.background.y_offset=-20)
fi

sketchybar -m --animate tanh 20 "${args[@]}"
