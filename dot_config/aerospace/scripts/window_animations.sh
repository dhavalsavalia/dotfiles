#!/bin/bash

# Window Animations for AeroSpace
# Provides visual feedback for workspace switches via border flash

ACTION="$1"  # workspace-change, window-focus, etc
WORKSPACE="$2"

# Monokai Pro Spectrum colors
declare -A COLORS=(
    ["B"]="0xff5ad4e6"  # Cyan
    ["C"]="0xfffc618d"  # Red
    ["D"]="0xff7bd88f"  # Green
    ["T"]="0xfffd9353"  # Orange
    ["A"]="0xff948ae3"  # Magenta
    ["O"]="0xfffce566"  # Yellow
    ["M"]="0xfff7f1ff"  # White
    ["X"]="0xfff7f1ff"  # White
)

case "$ACTION" in
    workspace-change)
        TARGET_COLOR="${COLORS[$WORKSPACE]}"

        # Flash animation: white -> target color
        # Quick pulse to indicate transition
        /opt/homebrew/bin/borders active_color=0xffffffff width=7.0 2>/dev/null
        sleep 0.05
        /opt/homebrew/bin/borders active_color="$TARGET_COLOR" width=5.0 2>/dev/null
        ;;

    window-focus)
        # Subtle pulse on window focus
        /opt/homebrew/bin/borders width=6.0 2>/dev/null
        sleep 0.1
        /opt/homebrew/bin/borders width=5.0 2>/dev/null
        ;;

    *)
        # Default: just update color
        TARGET_COLOR="${COLORS[$WORKSPACE]}"
        /opt/homebrew/bin/borders active_color="$TARGET_COLOR" 2>/dev/null
        ;;
esac
