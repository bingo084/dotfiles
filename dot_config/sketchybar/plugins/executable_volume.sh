#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh
source $HOME/.config/sketchybar/colors.sh

popup(){
    sketchybar --set $NAME popup.drawing=$1
}
volume_update(){
    MUTED=$(osascript -e "output muted of (get volume settings)")
    VOLUME=$(osascript -e "output volume of (get volume settings)")
    case ${VOLUME} in
      100) ICON="$VOLUME_HIGH" COLOR="$RED";;
      9[0-9]) ICON="$VOLUME_HIGH" COLOR="$RED";;
      8[0-9]) ICON="$VOLUME_HIGH" COLOR="$RED";;
      7[0-9]) ICON="$VOLUME_HIGH" COLOR="$RED";;
      6[6-9]) ICON="$VOLUME_HIGH" COLOR="$RED";;
      6[0-5]) ICON="$VOLUME_MIDDLE" COLOR="$ORANGE";;
      5[0-9]) ICON="$VOLUME_MIDDLE" COLOR="$ORANGE";;
      4[0-9]) ICON="$VOLUME_MIDDLE" COLOR="$ORANGE";;
      3[3-9]) ICON="$VOLUME_MIDDLE" COLOR="$ORANGE";;
      3[0-2]) ICON="$VOLUME_LOW" COLOR="$YELLOW";;
      2[0-9]) ICON="$VOLUME_LOW" COLOR="$YELLOW";;
      1[0-9]) ICON="$VOLUME_LOW" COLOR="$YELLOW";;
      [1-9]) ICON="$VOLUME_LOW" COLOR="$YELLOW";;
      0) ICON="$VOLUME_ZERO" COLOR="$GRAY";;
      *) ICON="$VOLUME_LOW" COLOR="$GRAY"
    esac
    if [[ $MUTED == true ]]; then
        ICON="$VOLUME_MUTE"
        COLOR="$GRAY"
    fi
    sketchybar  --set $NAME icon=$ICON          \
                            icon.color=$COLOR   \
                --set $NAME.level label="$VOLUME%"
}

toggle_mute(){
    MUTED=$(osascript -e "output muted of (get volume settings)")
    echo $MUTED
    if [ "$MUTED" == true ]; then
        osascript -e "set volume without output muted"
    else
        osascript -e "set volume with output muted"
    fi
}
case "$SENDER" in
  "volume_change"|"forced") volume_update 
  ;;
  "mouse.entered") popup on
  ;;
  "mouse.exited.global") popup off
  ;;
  "mouse.clicked") toggle_mute
  ;;
esac
