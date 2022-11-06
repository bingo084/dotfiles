#!/usr/bin/env bash

update(){
    source $HOME/.config/sketchybar/icons.sh
    source $HOME/.config/sketchybar/colors.sh

    APP_STATE=$(pgrep -x Music)
    if [[ ! $APP_STATE ]]; then 
      sketchybar --set music drawing=off
      exit 0
    fi

    PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
    MUSIC_NAME=$(osascript -e 'tell application "Music" to get name of current track')
    ARTIST=$(osascript -e 'tell application "Music" to get artist of current track')

    if [[ $PLAYER_STATE == "paused" ]]; then
        ICON=$MUSIC_PLAY
        COLOR="$RED"
    elif [[ $PLAYER_STATE == "playing" ]]; then
        ICON=$MUSIC_PAUSE
        COLOR="$GREEN"
    else
        ICON=$MUSIC_PLAY
        COLOR="$GRAY"
        sketchybar --set $NAME label.drawing=off
    fi

    if [[ ${#MUSIC_NAME} -gt 25 ]]; then
        MUSIC_NAME=$(printf "$(echo $MUSIC_NAME | cut -c 1-25)…")
    fi

    if [[ ${#ARTIST} -gt 25 ]]; then
        ARTIST=$(printf "$(echo $ARTIST | cut -c 1-25)…")
    fi

    sketchybar  --set music label="${MUSIC_NAME} x ${ARTIST}"   \
                            label.color="$MAGENTA"              \
                            icon.color="$COLOR"                 \
                            drawing=on                          \
                --set music.playpause icon=$ICON
}

popup(){
    sketchybar --set music popup.drawing=$1
}

click(){
    if [[ $NAME == "music" ]]; then
        open -a Music
    elif [[ $NAME == "music.previous" ]]; then
        osascript -e "tell application \"Music\" to previous track"
    elif [[ $NAME == "music.playpause" ]]; then
        osascript -e "tell application \"Music\" to playpause"
    else
        osascript -e "tell application \"Music\" to next track"
    fi
    popup off
}

case "$SENDER" in
  "song_update"|"routine"|"forced") update
  ;;
  "mouse.entered") popup on
  ;;
  "mouse.exited.global") popup off
  ;;
  "mouse.clicked") click
  ;;
esac
