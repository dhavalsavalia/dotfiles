#!/bin/bash

# Function to launch or focus an app
launch_or_focus() {
    app_name="$1"
    if ! osascript -e "tell application \"$app_name\" to activate"; then
        open -a "$app_name"
    fi
}

case "$1" in
    # Terminal (t)
    "t")
        launch_or_focus "Alacritty"
        ;;
    # Browser (b)
    "b")
        launch_or_focus "Arc"
        ;;
    # Teams (m - meeting)
    "m")
        launch_or_focus "Microsoft Teams"
        ;;
    # Outlook (o)
    "o")
        launch_or_focus "Microsoft Outlook"
        ;;
    # Postman (p)
    "p")
        launch_or_focus "Postman"
        ;;
    # MongoDB Compose (d - database)
    "d")
        launch_or_focus "MongoDB Compass"
        ;;
    *)
        echo "Unknown app shortcut: $1"
        exit 1
        ;;
esac
