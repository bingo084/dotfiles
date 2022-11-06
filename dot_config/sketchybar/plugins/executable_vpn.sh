#!/bin/bash

switch(){
    osascript -e "tell application \"ClashX\" to proxyMode \"$1\""
}

popup(){
    sketchybar --set vpn popup.drawing=$1
}

update(){
    source $HOME/.config/sketchybar/colors.sh

    MODE=$(defaults read com.west2online.ClashX 'selectOutBoundMode')
    ENABLE=$(defaults read com.west2online.ClashX 'proxyPortAutoSet')
    if [[ $ENABLE == 0 ]]; then
        COLOR="$GRAY"
    else
        if [[ $MODE == "" ]]; then
            sketchybar -m --set vpn drawing=off
            exit 0
        elif [[ $MODE == "global" ]]; then
            COLOR="$BLUE"
        elif [[ $MODE == "rule" ]]; then
            COLOR="$GREEN"
        elif [[ $MODE == "direct" ]]; then
            COLOR="$WHITE"
        fi
    fi
    sketchybar  --set   vpn icon.color="$COLOR" \
                            drawing=on
}

toggleProxy(){
    if [[ $NAME == vpn ]]; then
        osascript -e "tell application \"ClashX\" to toggleProxy"
    elif [[ $NAME == vpn.global ]]; then
        switch global
    elif [[ $NAME == vpn.rule ]]; then
        switch rule
    else 
        switch direct
    fi
    popup off
}

case "$SENDER" in
  "mouse.entered") popup on
  ;;
  "mouse.exited.global") popup off
  ;;
  "mouse.clicked") toggleProxy
  ;;
esac

update
