#!/bin/bash

REMINDERS_COUNT=$(osascript -l JavaScript -e "Application('Reminders').lists.byName('提醒').reminders.whose({completed: false}).name().length")

if [[ $REMINDERS_COUNT -gt 0 ]]; then
  sketchybar    --set reminders label="$REMINDERS_COUNT"
else
  sketchybar    --set reminders drawing=off
fi
