#!/usr/bin/env bash

sketchybar  --add   event   lock                "com.apple.screenIsLocked"      \
            --add   event   unlock              "com.apple.screenIsUnlocked"    \
            --add   event   front_app_switched                                  \
            --add   event   song_update         "com.apple.Music.playerInfo"    \
            --add   event   input_change        'AppleSelectedInputSourcesChangedNotification' \
