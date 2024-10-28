#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# Source the utility functions
source "$DOTFILES_DIR/scripts/brew.sh"

# Parse arguments
while getopts "p:d" opt; do
    case $opt in
        p) PROFILE="$OPTARG";;
        d) DRY_RUN="true";;
        *) echo "Usage: $0 [-p profile] [-d]" >&2
           exit 1;;
    esac
done

# Validate profile
if [ "$PROFILE" != "home" ] && [ "$PROFILE" != "1" ]; then
    error "Profile must be either 'home' or '1'"
    exit 1
fi

# Make scripts executable
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# Run Homebrew setup
setup_homebrew "$PROFILE"
