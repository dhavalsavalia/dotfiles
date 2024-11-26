#!/bin/bash

# Add and subscribe to the aerospace_mode_change event
sketchybar --add event aerospace_mode_change

# Aerospace mode  settings
sketchybar --add item aerospace_mode right \
    --set aerospace_mode \
    script="$PLUGIN_DIR/aerospace_mode.sh" \
    --subscribe aerospace_mode aerospace_mode_change
