#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# Source the utility functions first
source "$DOTFILES_DIR/scripts/utils.sh"

print_usage() {
    cat << EOF
Usage: $0 [options]

Options:
    -p <profile>    Specify profile (home or garda)
    -d             Dry run mode
    -m             Run macOS defaults setup
    -l             Install LunarVim
    -h             Show this help message

Example:
    $0 -p home         # Regular install for home profile
    $0 -p home -d      # Dry run for home profile
    $0 -p home -m      # Install and run macOS defaults
    $0 -p home -l      # Install with LunarVim
EOF
}

# Parse arguments
while getopts "p:dmlh" opt; do
    case $opt in
        p) PROFILE="$OPTARG";;
        d) export DRY_RUN="true";;
        m) MACOS_DEFAULTS="true";;
        l) INSTALL_LVIM="true";;
        h) print_usage; exit 0;;
        *) print_usage; exit 1;;
    esac
done

# Validate profile
if [ -z "$PROFILE" ]; then
    error "Profile must be specified with -p option"
    print_usage
    exit 1
fi

if [ "$PROFILE" != "home" ] && [ "$PROFILE" != "garda" ] && [ "$PROFILE" != "minimal" ]; then
    error "Profile must be either 'home', 'garda', or 'minimal'"
    exit 1
fi

# Make scripts executable
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# Initialize setup
log "Starting setup for profile: $PROFILE"
log "Dry run mode: ${DRY_RUN:-false}"

# Run macOS defaults if requested
if [ "$MACOS_DEFAULTS" = "true" ]; then
    log "Setting up macOS defaults..."
    source "$DOTFILES_DIR/scripts/macos.sh"
    setup_macos_defaults "$PROFILE"
fi

# Run Homebrew setup
log "Setting up Homebrew..."
source "$DOTFILES_DIR/scripts/brew.sh"
setup_homebrew "$PROFILE"

# Run stow setup
log "Setting up dotfiles with stow..."
source "$DOTFILES_DIR/scripts/stow.sh"
setup_stow "$PROFILE"

# Install LunarVim if requested
if [ "$INSTALL_LVIM" = "true" ]; then
    log "Installing LunarVim..."
    source "$DOTFILES_DIR/scripts/lunarvim.sh"
    install_lunarvim
fi

# Setup tmux
log "Setting up tmux..."
source "$DOTFILES_DIR/scripts/tmux.sh"
setup_tmux

# Setup sketchybar
source "$DOTFILES_DIR/scripts/sketchybar.sh"

log "Setup completed successfully!"
