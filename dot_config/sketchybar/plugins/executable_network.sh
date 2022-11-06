#!/usr/bin/env bash

UPDOWN=$(ifstat -i "en0" -b 0.1 1 | tail -n1)
DOWN=$(echo $UPDOWN | awk "{ print \$1 }" | cut -f1 -d ".")
UP=$(echo $UPDOWN | awk "{ print \$2 }" | cut -f1 -d ".")

DOWN_FORMAT=""
if [ "$DOWN" -gt "999" ]; then
  DOWN_FORMAT=$(echo $DOWN | awk '{ printf "%.0f MB/s", $1 / 8000}')
else
  DOWN_FORMAT=$(echo $DOWN | awk '{ printf "%.0f KB/s", $1 / 8}')
fi

UP_FORMAT=""
if [ "$UP" -gt "999" ]; then
  UP_FORMAT=$(echo $UP | awk '{ printf "%.0f MB/s", $1 / 8000}')
else
  UP_FORMAT=$(echo $UP | awk '{ printf "%.0f KB/s", $1 / 8}')
fi

DOWN_ICON_HIGHLIGHT=off
UP_ICON_HIGHLIGHT=off
DRAWING=off
if [ "$DOWN" -gt "0" ]; then 
    DOWN_ICON_HIGHLIGHT=on
    if [ "$DOWN" -gt "100" ]; then 
        DRAWING=on
    fi
fi
if [ "$UP" -gt "0" ]; then 
    UP_ICON_HIGHLIGHT=on
    if [ "$UP" -gt "100" ]; then 
        DRAWING=on
    fi
fi

sketchybar  --set   network_down    label="$DOWN_FORMAT"                \
                                    icon.highlight=$DOWN_ICON_HIGHLIGHT \
                                    drawing=$DRAWING                    \
            --set   network_up      label="$UP_FORMAT"                  \
                                    icon.highlight=$UP_ICON_HIGHLIGHT   \
                                    drawing=$DRAWING
