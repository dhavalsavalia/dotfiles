#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# Source the utility functions first
source "$DOTFILES_DIR/scripts/utils.sh"

print_usage() {
    cat <<EOF
Usage: $0 [options]

Options:
    -p <profile>    Specify profile (home or garda or minimal)
    -n <name>       Git author name (optional, precedence given to git config)
    -e <email>      Git author email (optional, precedence given to git config)
    -d              Dry run mode
    -m              Run macOS defaults setup
    -g              Ignore git related settings
    -h              Show this help message

Example:
    $0 -p home -n "Your Name" -e "your.email@example.com"  # Regular install for home profile
    $0 -p home -d                                          # Dry run for home profile
    $0 -p home -m                                          # Install and run macOS defaults
EOF
}

# Parse arguments
while getopts "p:n:e:dmgh" opt; do
    case $opt in
    p) PROFILE="$OPTARG" ;;
    n) PROVIDED_GITAUTHORNAME="$OPTARG" ;;
    e) PROVIDED_GITAUTHOREMAIL="$OPTARG" ;;
    d) export DRY_RUN="true" ;;
    m) MACOS_DEFAULTS="true" ;;
    g) NO_GIT="true" ;;
    h)
        print_usage
        exit 0
        ;;
    *)
        print_usage
        exit 1
        ;;
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

if [ "$NO_GIT" != "true" ]; then
    # Get git author info
    source "$DOTFILES_DIR/scripts/git.sh"
    GIT_AUTHOR_INFO=$(get_git_author "$PROVIDED_GITAUTHORNAME" "$PROVIDED_GITAUTHOREMAIL")
    GITAUTHORNAME=$(echo "$GIT_AUTHOR_INFO" | cut -d'|' -f1)
    GITAUTHOREMAIL=$(echo "$GIT_AUTHOR_INFO" | cut -d'|' -f2)
fi

# Confirm settings
warn "Configuration:"
warn "  Profile: $PROFILE"
warn "  Dry Run: ${DRY_RUN:-false}"
warn "  macOS Defaults: ${MACOS_DEFAULTS:-false}"
if [ "$NO_GIT" != "true" ]; then
    warn "  Git Author Name: $GITAUTHORNAME"
    warn "  Git Author Email: $GITAUTHOREMAIL"
fi

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

if [ "$NO_GIT" != "true" ]; then
  # Setup name and email for git
  log "Setting up git author name and email..."
  source "$DOTFILES_DIR/scripts/git.sh"
  setup_git_author "$GITAUTHORNAME" "$GITAUTHOREMAIL"
fi

# Install LunarVim
log "Installing LunarVim..."
source "$DOTFILES_DIR/scripts/lunarvim.sh"
install_lunarvim

# Install tmux
log "Setting up tmux..."
source "$DOTFILES_DIR/scripts/tmux.sh"
setup_tmux
setup_tmuxifier

# Install AeroSpace
source "$DOTFILES_DIR/scripts/aerospace.sh"
setup_aerospace

# Setup VSCode
log "Setting up VSCode..."
source "$DOTFILES_DIR/scripts/vscode.sh"

log "Setup completed successfully!"
