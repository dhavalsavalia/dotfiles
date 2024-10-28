#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON="$(command -v python3)"

# Parse arguments
while getopts "p:d" opt; do
    case $opt in
        p) PROFILE="$OPTARG";;
        d) DRY_RUN="--dry-run";;
        *) echo "Usage: $0 [-p profile] [-d]" >&2
           exit 1;;
    esac
done

# Validate profile
if [ "$PROFILE" != "home" ] && [ "$PROFILE" != "1" ]; then
    echo "Error: Profile must be either 'home' or '1'"
    exit 1
fi

# Make scripts executable
chmod +x "$DOTFILES_DIR/scripts/"*.py

# Run Homebrew setup
"$PYTHON" "$DOTFILES_DIR/scripts/brew.py" --profile "$PROFILE" $DRY_RUN
