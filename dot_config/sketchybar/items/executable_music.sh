#!/usr/bin/env bash

POPUP_ICON_PADDINGS=13
sketchybar  --add       item            music      right                            \
            --set       music           script="$PLUGIN_DIR/music.sh"               \
                                        icon=$MUSIC                                 \
                                        updates=on                                  \
                                        popup.horizontal=on                         \
                                        popup.align=center                          \
            --subscribe music           song_update                                 \
                                        mouse.entered                               \
                                        mouse.exited.global                         \
                                        mouse.clicked                               \
            --add       item            music.previous  popup.music                 \
            --set       music.previous  icon=$MUSIC_PREVIOUS                        \
                                        icon.padding_left=$POPUP_ICON_PADDINGS      \
                                        icon.padding_right=$POPUP_ICON_PADDINGS     \
                                        label.drawing=off                           \
                                        script="$PLUGIN_DIR/music.sh"               \
            --subscribe music.previous  mouse.clicked                               \
            --add       item            music.playpause popup.music                 \
            --set       music.playpause icon.padding_left=$POPUP_ICON_PADDINGS      \
                                        icon.padding_right=$POPUP_ICON_PADDINGS     \
                                        label.drawing=off                           \
                                        script="$PLUGIN_DIR/music.sh"               \
            --subscribe music.playpause mouse.clicked                               \
            --add       item            music.next      popup.music                 \
            --set       music.next      icon=$MUSIC_NEXT                            \
                                        icon.padding_left=$POPUP_ICON_PADDINGS      \
                                        icon.padding_right=$POPUP_ICON_PADDINGS     \
                                        label.drawing=off                           \
                                        script="$PLUGIN_DIR/music.sh"               \
            --subscribe music.next      mouse.clicked                               \
