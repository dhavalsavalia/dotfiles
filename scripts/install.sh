#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# Source the utility functions first
source "$DOTFILES_DIR/scripts/utils.sh"

# Then source other scripts
source "$DOTFILES_DIR/scripts/brew.sh"
source "$DOTFILES_DIR/scripts/macos.sh"

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
if [ "$PROFILE" != "home" ] && [ "$PROFILE" != "garda" ]; then
    error "Profile must be either 'home' or 'garda'"
    exit 1
fi

log "Starting setup for profile: $PROFILE"

# Make scripts executable
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# Setup macOS defaults first
setup_macos_defaults

# Run Homebrew setup
setup_homebrew "$PROFILE"
