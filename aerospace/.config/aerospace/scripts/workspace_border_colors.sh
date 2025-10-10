#!/bin/bash

# JankyBorders workspace color switcher
# Matches Monokai Pro Spectrum theme from Zellij config
# Called by AeroSpace exec-on-workspace-change callback

WORKSPACE=$1

# Monokai Pro Spectrum colors
case $WORKSPACE in
    "B") # Browser - Cyan
        COLOR="0xff5ad4e6"
        ;;
    "C") # Communication (Teams) - Red
        COLOR="0xfffc618d"
        ;;
    "D") # Development (VSCode #1) - Green
        COLOR="0xff7bd88f"
        ;;
    "T") # Terminal - Orange
        COLOR="0xfffd9353"
        ;;
    "A") # API Tools - Magenta
        COLOR="0xff948ae3"
        ;;
    "O") # Outlook - Yellow
        COLOR="0xfffce566"
        ;;
    "M") # More Dev (VSCode #2) - White
        COLOR="0xfff7f1ff"
        ;;
    "X") # Extra (VSCode #3+) - White
        COLOR="0xfff7f1ff"
        ;;
    *) # Default - White
        COLOR="0xfff7f1ff"
        ;;
esac

# Update borders color (updates running instance)
/opt/homebrew/bin/borders active_color=$COLOR 2>/dev/null &
