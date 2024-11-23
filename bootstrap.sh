#!/bin/bash

set -e

REPO_URL="https://github.com/dhavalsavalia/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Default values
PROFILE="${DOTFILES_PROFILE:-minimal}"
DRY_RUN="${DRY_RUN:-false}"
MACOS_DEFAULTS="${MACOS_DEFAULTS:-true}"
BRANCH="${DOTFILES_BRANCH:-main}"

DEFAULT_GITAUTHORNAME="Dhaval Savalia"
DEFAULT_GITAUTHOREMAIL="hello@dhavalsavalia.com"

# Prompt for GITAUTHORNAME if not set
if [ -z "$GITAUTHORNAME" ]; then
  read -p "Enter your Git author name [${DEFAULT_GITAUTHORNAME}]: " input_name
  GITAUTHORNAME=${input_name:-$DEFAULT_GITAUTHORNAME}
fi

# Prompt for GITAUTHOREMAIL if not set
if [ -z "$GITAUTHOREMAIL" ]; then
  read -p "Enter your Git author email [${DEFAULT_GITAUTHOREMAIL}]: " input_email
  GITAUTHOREMAIL=${input_email:-$DEFAULT_GITAUTHOREMAIL}
fi


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
    # TODO: Make Git Great Again
    echo "Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --ff-only
fi

# Navigate to the dotfiles directory and checkout the specified branch
cd "$DOTFILES_DIR"
if [ "$(git rev-parse --abbrev-ref HEAD)" != "$BRANCH" ]; then
    git checkout "$BRANCH"
fi

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
warn "  Git Author Name: $GITAUTHORNAME"
warn "  Git Author Email: $GITAUTHOREMAIL"

read -p "Proceed with these settings? (y/N) " CONFIRM
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
    setup_macos_defaults
fi

# Install Homebrew
log "Setting up Homebrew..."
source "$DOTFILES_DIR/scripts/brew.sh"
setup_homebrew "$PROFILE"

# Install stow
log "Setting up dotfiles with stow..."
source "$DOTFILES_DIR/scripts/stow.sh"
setup_stow

# use test_stow and exit if it returns 1
if ! test_stow; then
    error "Stow setup failed"
    exit 1
fi

# Setup name and email for git
log "Setting up git author name and email..."
source "$DOTFILES_DIR/scripts/git.sh"
setup_git_author "$GITAUTHORNAME" "$GITAUTHOREMAIL"

# Install LunarVim
log "Installing LunarVim..."
source "$DOTFILES_DIR/scripts/lunarvim.sh"
install_lunarvim

# Install tmux
log "Setting up tmux..."
source "$DOTFILES_DIR/scripts/tmux.sh"
setup_tmux
setup_tmuxifier

# Install sketchybar
source "$DOTFILES_DIR/scripts/sketchybar.sh"
setup_sketchybar

# Install AeroSpace
source "$DOTFILES_DIR/scripts/aerospace.sh"
setup_aerospace

log "Setup completed successfully!"
