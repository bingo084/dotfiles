#!/usr/bin/env bash

source $HOME/.config/sketchybar/icons.sh

INPUT=$(im-select)

case ${INPUT} in
    'com.apple.keylayout.UnicodeHexInput') LABEL="$INPUT_ENGLISH"
    ;;
    'com.apple.inputmethod.SCIM.Shuangpin') LABEL="$INPUT_CHINESE"
    ;;
esac

sketchybar --set $NAME label="$LABEL"

