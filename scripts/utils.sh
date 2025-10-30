#!/bin/bash

# Set DOTFILES_DIR if not already set
if [ -z "$DOTFILES_DIR" ]; then
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    export DOTFILES_DIR
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to execute commands with dry run support
execute() {
    if [ "$DRY_RUN" = "true" ]; then
        echo "WOULD EXECUTE: $*"
        return 0
    else
        echo "EXECUTING: $*"
        eval "$@"
        return $?
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

test_stow() {
    # TODO: Check for app specific symlinks
    log "Testing stow setup..."

    # Ensure stow is installed
    if ! command_exists "stow"; then
        return 1
    fi

    if [ -L "$HOME/.zshenv" ]; then
        return 0
    else
        return 1
    fi
}

# Get profile from .brewprofile or prompt user
get_profile() {
    local brewprofile_path="${XDG_CONFIG_HOME:-$HOME/.config}/.brewprofile"

    if [ -f "$brewprofile_path" ]; then
        cat "$brewprofile_path"
    else
        echo ""
    fi
}

# Get or create profile (interactive)
get_or_create_profile() {
    local brewprofile_path="${XDG_CONFIG_HOME:-$HOME/.config}/.brewprofile"

    # Check if .brewprofile exists
    if [ ! -f "$brewprofile_path" ]; then
        log ".brewprofile not found at $brewprofile_path"
        read -rp "Enter profile (home/garda/minimal): " user_profile

        # Validate input
        while [[ "$user_profile" != "home" && "$user_profile" != "garda" && "$user_profile" != "minimal" ]]; do
            echo "Invalid profile. Please enter 'home', 'garda', or 'minimal'."
            read -rp "Enter profile: " user_profile
        done

        # Create .brewprofile and save the profile
        mkdir -p "$(dirname "$brewprofile_path")"
        echo "$user_profile" >"$brewprofile_path"
        log "Profile saved to $brewprofile_path"
    fi

    # Read and return the profile from .brewprofile
    cat "$brewprofile_path"
}
