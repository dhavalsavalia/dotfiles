#!/bin/bash

set -e

REPO_URL="https://github.com/dhavalsavalia/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Default values
PROFILE="${DOTFILES_PROFILE:-minimal}"
DRY_RUN="${DRY_RUN:-false}"
MACOS_DEFAULTS="${MACOS_DEFAULTS:-false}"
INSTALL_LVIM="${INSTALL_LVIM:-true}"
BRANCH="${DOTFILES_BRANCH:-main}"

# Clone the repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    # Check if repository has right remote URL
    if [ "$(git -C "$DOTFILES_DIR" remote get-url origin)" != "$REPO_URL" ]; then
        echo "Changing remote URL to $REPO_URL..."
        git -C "$DOTFILES_DIR" remote set-url origin "$REPO_URL"
    fi

    # Pull the latest changes
    echo "Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --ff-only
fi

# Navigate to the dotfiles directory and checkout the specified branch
cd "$DOTFILES_DIR"
git checkout "$BRANCH"

# Make scripts executable
chmod +x "$DOTFILES_DIR"/scripts/*.sh

source "$DOTFILES_DIR/scripts/utils.sh"

# Prompt for profile if not set
if [ -z "$PROFILE" ]; then
    log "Select a profile:"
    select PROFILE in "home" "garda" "minimal"; do
        if [[ "$PROFILE" ]]; then break; fi
        log "Invalid selection. Try again."
    done
fi

# Confirm settings
warn "Configuration:"
warn "  Profile: $PROFILE"
warn "  Dry Run: $DRY_RUN"
warn "  macOS Defaults: $MACOS_DEFAULTS"
warn "  Install LunarVim: $INSTALL_LVIM"

read -p "Proceed with these settings? (y/n) " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    error "Installation canceled."
    exit 1
fi

# Installation
log "Starting setup for profile: $PROFILE"

# Install MacOS defaults
if [ "$MACOS_DEFAULTS" = "true" ]; then
    log "Running macOS defaults setup..."
    source "$DOTFILES_DIR/scripts/macos.sh"
    # TODO: Tidy up macos.sh
    setup_macos_defaults "$PROFILE"  # WARNING: This is probably going to fail
fi

# Install Homebrew
log "Setting up Homebrew..."
source "$DOTFILES_DIR/scripts/brew.sh"
setup_homebrew "$PROFILE"

# Install stow
log "Setting up dotfiles with stow..."
source "$DOTFILES_DIR/scripts/stow.sh"
setup_stow "$PROFILE"

# Install LunarVim
if [ "$INSTALL_LVIM" = "true" ]; then
    log "Installing LunarVim..."
    source "$DOTFILES_DIR/scripts/lunarvim.sh"
    install_lunarvim
fi

# Install tmux
log "Setting up tmux..."
source "$DOTFILES_DIR/scripts/tmux.sh"
setup_tmux

# Install sketchybar
source "$DOTFILES_DIR/scripts/sketchybar.sh"

# Install AeroSpace
source "$DOTFILES_DIR/scripts/aerospace.sh"

log "Setup completed successfully!"
