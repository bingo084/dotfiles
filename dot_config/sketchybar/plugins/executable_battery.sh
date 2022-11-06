#!/bin/bash

source $HOME/.config/sketchybar/colors.sh
source $HOME/.config/sketchybar/icons.sh

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON="$BATTERY_FULL" COLOR=$BLUE
  ;;
  [6-8][0-9]) ICON="$BATTERY_THREE_QUARTERS" COLOR=$BLUE
  ;;
  [3-5][0-9]) ICON="$BATTERY_HALF" COLOR=$YELLOW
  ;;
  [1-2][0-9]) ICON="$BATTERY_QUARTER" COLOR=$ORANGE
  ;;
  *) ICON="$BATTERY_ZERO" COLOR=$RED
esac

if [[ $CHARGING != "" ]]; then
  ICON="$BATTERY_CHARGING"
  COLOR="$GREEN"
fi

sketchybar  --set   $NAME               icon="$ICON"            \
                                        icon.color=$COLOR       \
            --set   $NAME.percentage    label="${PERCENTAGE}%"

popup(){
    sketchybar --set $NAME popup.drawing=$1
}
case "$SENDER" in
  "mouse.entered") popup on
  ;;
  "mouse.exited"|"mouse.exited.global") popup off
  ;;
  "mouse.clicked") popup toggle
  ;;
esac
