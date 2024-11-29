#!/bin/bash

# Mode icon
get_mode_icon() {
    case "$1" in
    main) echo " " ;;
    service) echo "" ;;
    *) echo " " ;; # Fallback icon for unknown modes
    esac
}

# Mode label
get_mode_label() {
    case "$1" in
    main) echo "Main" ;;
    service) echo "Service" ;;
    *) echo "$1 mode" ;; # Fallback label for unknown modes
    esac
}

# Get current mode; default to main
MODE="${MODE:-main}"

# Debugging: Log the mode for troubleshooting
# echo "$(date) - Mode: $MODE" >>/tmp/aerospace_mode_debug.log

# Set icon and label
ICON=$(get_mode_icon "$MODE")
LABEL=$(get_mode_label "$MODE")

# Update sketchybar item
sketchybar --set aerospace_mode \
    icon="$ICON" \
    label="$LABEL"
