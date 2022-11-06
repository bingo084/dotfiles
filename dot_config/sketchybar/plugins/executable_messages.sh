TEXT=$(sqlite3 ~/Library/Messages/chat.db "SELECT text FROM message WHERE is_read=0 AND is_from_me=0 AND text!='' AND date_read=0" | wc -l | awk '{$1=$1};1')

if [ $TEXT = 0 ]; then
  sketchybar --set $NAME    drawing=off
else
  sketchybar --set $NAME    drawing=on      \
                            label="$TEXT"
fi
