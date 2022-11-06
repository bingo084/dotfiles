#!/usr/bin/env bash

sketchybar --add    space           space_template left                 \
           --set    space_template  icon.font="$FONT:Bold:15.0"         \
                                    icon.padding_right=6                \
                                    icon.background.height=2            \
                                    icon.background.color=$TRANSPARENT  \
                                    icon.background.color=$TRANSPARENT  \
                                    icon.background.y_offset=-12        \
                                    label.drawing=off                   \
                                    script="$PLUGIN_DIR/space.sh"       \
                                    click_script="$SPACE_CLICK_SCRIPT"  \
                                                                        \
           --add    item            display_1.label left                \
           --set    display_1.label icon.drawing=off                    \
                                    label=spc                           \
                                    label.width=35.0                    \
                                    label.align=center                  \
                                    associated_display=1                \
                                                                        \
           --clone  space.code      space_template                      \
           --set    space.code      associated_space=1                  \
                                    associated_display=1                \
                                    icon=$CODE                          \
                                    icon.highlight_color=$RED           \
                                    icon.background.color=$RED          \
                                                                        \
           --clone  space.web       space_template                      \
           --set    space.web       associated_space=2                  \
                                    associated_display=1                \
                                    icon=$WEB                           \
                                    icon.highlight_color=$BLUE          \
                                    icon.background.color=$BLUE         \
                                                                        \
           --clone  space.msg       space_template                      \
           --set    space.msg       associated_space=3                  \
                                    associated_display=1                \
                                    icon=$CHAT                          \
                                    icon.highlight_color=$GREEN         \
                                    icon.background.color=$GREEN        \
                                                                        \
           --clone  space.doc       space_template                      \
           --set    space.doc       associated_space=4                  \
                                    associated_display=1                \
                                    icon=$DOC                           \
                                    icon.highlight_color=$MAGENTA       \
                                    icon.background.color=$MAGENTA      \
                                                                        \
           --clone  space.other     space_template                      \
           --set    space.other     associated_space=5                  \
                                    associated_display=1                \
                                    icon=$OTHER                         \
                                    icon.highlight_color=$YELLOW        \
                                    icon.background.color=$YELLOW

# sketchybar --add bracket primary_spaces display_1.label                 \
#                                         space.code                      \
#                                         space.web                       \
#                                         space.msg                       \
#                                         space.doc                       \
#                                         space.other                     \
#                                                                         \
#            --set         primary_spaces background.drawing=on           \
#                                         background.border_color=$WHITE                  \
#                                         background.border_width=$BACKGROUND_BORDER_WIDTH\
#                                         background.height=$BACKGROUND_HEIGHT            \
#                                         background.corner_radius=$CORNER_RADIUS
