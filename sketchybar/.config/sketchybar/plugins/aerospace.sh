#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set space.$1 background.drawing=on \
    background.color=$ACCENT_COLOR \
    label.color=$BAR_COLOR \
    icon.color=$BAR_COLOR
else
  sketchybar --set space.$1 background.drawing=off \
    label.color=$ACCENT_COLOR \
    icon.color=$ACCENT_COLOR
fi
